import 'package:flutter/material.dart';
import 'package:takoett/models/takoett.dart';
import 'package:takoett/models/favourite.dart';
import 'package:takoett/services/favourite_services.dart';

class DetailScreen extends StatelessWidget {
  final Takoett takoett;

  const DetailScreen({Key? key, required this.takoett}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(takoett.title, style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (takoett.image != null)
              Image.network(
                takoett.image!,
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
                          takoett.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite_border, color: Colors.blue),
                        onPressed: () {
                          // Handle favorite action
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      takoett.description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Divider(),
                  Text(
                    "Reply",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text("Username"),
                    subtitle: Text("Description. Lorem ipsum dolor sit amet"),
                    trailing: TextButton(
                      onPressed: () {
                        // Handle reply action
                      },
                      child: Text("reply"),
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
        child: Icon(Icons.message),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
