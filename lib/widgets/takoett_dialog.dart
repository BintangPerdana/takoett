import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:takoett/models/takoett.dart';
import 'package:takoett/services/location_services.dart';
import 'package:takoett/services/takoett_services.dart';

class TambahPost extends StatefulWidget {
  final Takoett? takoett;
  const TambahPost({super.key, this.takoett});

  @override
  State<TambahPost> createState() => _TambahPostState();
}

class _TambahPostState extends State<TambahPost> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  double _rating = 0;
  XFile? _imageFile;
  Position? _position;


  @override
  void initState() {
    super.initState();
    if (widget.takoett != null) {
      _titleController.text = widget.takoett!.title;
      _descriptionController.text = widget.takoett!.description;
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _getLocation() async {
    final location = await LocationService().getCurrentLocation();
    setState(() {
      _position = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.takoett == null ? 'Add Posts' : 'Update Posts'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Title',
            textAlign: TextAlign.start,
          ),
          TextField(
            controller: _titleController,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('Description : '),
          ),
          TextField(
            controller: _descriptionController,
            maxLines: null,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('Rating : '),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Image.asset(
                  index < _rating
                      ? 'images/icon/skull_selected.png'
                      : 'images/icon/skull.png',
                  color: index < _rating
                      ? Colors.red
                      : Colors.grey, // Optional: Adjust color if needed
                  width: 24, // Adjust the size as needed
                  height: 24, // Adjust the size as needed
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
              );
            }),
          ),
          Text('Current Rating: $_rating'),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('Image: '),
          ),
          Expanded(
            child: _imageFile != null
                ? Image.network(_imageFile!.path,
                    fit: BoxFit.cover) // Gunakan Image.network untuk web
                : (widget.takoett?.image != null &&
                        Uri.parse(widget.takoett!.image!).isAbsolute
                    ? Image.network(widget.takoett!.image!, fit: BoxFit.cover)
                    : Container()),
          ),
          TextButton(
            onPressed: _pickImage,
            child: const Text('Pick Image'),
          ),
          TextButton(
            onPressed: _getLocation,
            child: const Text("Get Location"),
          ),
          Text(
            _position?.latitude != null && _position?.longitude != null
                ? 'Current Position : ${_position!.latitude.toString()}, ${_position!.longitude.toString()}'
                : 'Current Position : ${widget.takoett?.lat}, ${widget.takoett?.lng}',
            textAlign: TextAlign.start,
          )
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            String? image;
            if (_imageFile != null) {
              image = await TakoettServices.uploadImage(_imageFile!);
            } else {
              image = widget.takoett?.image;
            }
            Takoett takoett = Takoett(
              id: widget.takoett?.id,
              title: _titleController.text,
              description: _descriptionController.text,
              image: image,
              rating: _rating,
              createdAt: widget.takoett?.createdAt,
            );
            if (widget.takoett == null) {
              TakoettServices.addPost(takoett)
                  .whenComplete(() => Navigator.of(context).pop());
            } else {
              TakoettServices.updateNote(takoett)
                  .whenComplete(() => Navigator.of(context).pop());
            }
          },
          child: Text(widget.takoett == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
