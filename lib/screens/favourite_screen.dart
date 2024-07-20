import 'package:flutter/material.dart';
import 'package:takoett/models/takoett.dart';
import 'package:takoett/screens/detail_screen.dart';
import 'package:takoett/services/favourite_services.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<Takoett>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    _favoritesFuture = FavoriteService.getFavorites();
  }

  void _removeFavorite(Takoett takoett) async {
    await FavoriteService.removeFavorite(takoett);
    setState(() {
      _loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Takoett>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No favorites added yet.'),
            );
          }
          return RefreshIndicator(
            onRefresh: () {
              setState(() {
                _loadFavorites();
              });
              return _favoritesFuture;
            },
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final takoett = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      takoett.image ?? '',
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(takoett.title),
                    subtitle: Text(takoett.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => _removeFavorite(takoett),
                    ),
                    onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(takoett: takoett),
                ),
              );
            },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
