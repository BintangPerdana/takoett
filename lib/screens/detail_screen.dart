import 'package:flutter/material.dart';
import 'package:takoett/models/takoett.dart';
import 'package:takoett/screens/google_maps_screen.dart';
import 'package:takoett/services/favourite_services.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final Takoett takoett;

  const DetailScreen({super.key, required this.takoett});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  void _checkFavorite() async {
    final isFavorited = await FavoriteService.isFavorite(widget.takoett);
    setState(() {
      _isFavorited = isFavorited;
    });
  }

  void _toggleFavorite() async {
    if (_isFavorited) {
      await FavoriteService.removeFavorite(widget.takoett);
    } else {
      await FavoriteService.addFavorite(widget.takoett);
    }
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.takoett.title,
            style: const TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.takoett.image != null)
              Image.network(
                widget.takoett.image!,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.takoett.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                      ),
                      IconButton(
                        icon: Icon(
                          _isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          // Handle favorite action
                          _toggleFavorite();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // add rating icon
                  Row(
                    children: List.generate(
                      5,
                      (index) {
                        return Image.asset(
                          index < widget.takoett.rating
                              ? 'images/icon/skull_selected.png'
                              : 'images/icon/skull.png',
                          color: index < widget.takoett.rating
                              ? Colors.red
                              : Colors.grey, // Optional: Adjust color if needed
                          width: 24, // Adjust the size as needed
                          height: 24, // Adjust the size as needed
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      widget.takoett.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Row(
                          children: [
                            widget.takoett.lat != null && widget.takoett.lng != null
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GoogleMapsScreen(
                                            widget.takoett.lat,
                                            widget.takoett.lng,
                                          ),
                                        ),
                                      );
                                      //openMap(document.lat, document.lng);
                                    },
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Icon(Icons.map),
                                    ),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Icon(
                                      Icons.map,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ],),
                  const Divider(),
                  const Text(
                    "Reply",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: const Text("Username"),
                    subtitle:
                        const Text("Description. Lorem ipsum dolor sit amet"),
                    trailing: TextButton(
                      onPressed: () {
                        // Handle reply action
                      },
                      child: const Text("reply"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle Add message action
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.message),
      ),
    );
  }
}

  Future<void> openMap(String? lat, String? lng) async {
    Uri uri =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat, $lng");
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
