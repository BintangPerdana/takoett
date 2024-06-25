import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:takoett/models/takoett.dart';

class FavoriteService {
  static Future<void> addFavorite(String userId, Takoett takoett) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .add(takoett.toMap());
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }
}
