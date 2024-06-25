import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:takoett/models/takoett.dart';
import 'package:takoett/screens/detail_screen.dart';
import 'package:takoett/screens/favourite_screen.dart';
import 'package:takoett/screens/user/login.dart';
import 'package:takoett/services/takoett_services.dart';
import 'package:takoett/widgets/takoett_dialog.dart';
import 'package:takoett/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Takoett'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          PostList(),
          FavoriteScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const TambahPost();
            },
          );
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PostList extends StatelessWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Takoett>>(
      stream: TakoettServices.getPostList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Tidak ada post'),
          );
        }
        return ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: snapshot.data!.map((document) {
            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(takoett: document),
                    ),
                  );
                },
                child: Column(
                  children: [
                    ListTile(
                      title: Text(document.title),
                      subtitle: Text(document.description),
                      trailing: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Konfirmasi Hapus'),
                                content: Text(
                                    'Yakin ingin menghapus data \'${document.title}\' ?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Hapus'),
                                    onPressed: () {
                                      TakoettServices.deleteNote(document)
                                          .whenComplete(() =>
                                              Navigator.of(context).pop());
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
