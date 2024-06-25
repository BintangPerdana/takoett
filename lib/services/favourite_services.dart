import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:takoett/models/takoett.dart';

class FavoriteService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addFavorite(Takoett takoett) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(takoett.id)
        .set(takoett.toMap());
  }

  static Future<void> removeFavorite(Takoett takoett) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(takoett.id)
        .delete();
  }

  static Future<bool> isFavorite(Takoett takoett) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(takoett.id)
        .get();
    return doc.exists;
  }

  static Future<List<Takoett>> getFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];
    final querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();
    return querySnapshot.docs.map((doc) => Takoett.fromMap(doc)).toList();
  }
}
