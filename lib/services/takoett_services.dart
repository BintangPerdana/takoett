import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:takoett/models/takoett.dart';
import 'package:path/path.dart' as path;

class TakoettServices {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _takoettCollection =
      _database.collection('takoett');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Tambah data
  static Future<void> addPost(Takoett takoett) async {
    Map<String, dynamic> newPost = {
      'title': takoett.title,
      'description': takoett.description,
      'image': takoett.image,
      'rating': takoett.rating,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    try {
      await _takoettCollection.add(newPost);
    } catch (e) {
      print(e);
    }
  }

  // Tampil data
  static Stream<List<Takoett>> getPostList() {
    return _takoettCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Takoett(
          id: doc.id,
          title: data['title'],
          description: data['description'],
          image: data['image'],
          rating: data['rating'] ?? 0.0,
          lat: data['lat'],
          lng: data['lng'],
          createdAt:
              data['createdAt'] != null ? data['createdAt'] as Timestamp : null,
          updatedAt:
              data['updatedAt'] != null ? data['updatedAt'] as Timestamp : null,
        );
      }).toList();
    });
  }

  // Edit data
  static Future<void> updateNote(Takoett takoett) async {
    Map<String, dynamic> updatedPost = {
      'title': takoett.title,
      'description': takoett.description,
      'image': takoett.image,
      'rating': takoett.rating,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    try {
      await _takoettCollection.doc(takoett.id).update(updatedPost);
    } catch (e) {
      print(e);
    }
  }

  //hapus data
  static Future<void> deleteNote(Takoett takoett) async {
    await _takoettCollection.doc(takoett.id).delete();
  }

  //upload image
  static Future<String?> uploadImage(XFile file) async {
    try {
      String fileName = path.basename(file.path);
      Reference ref = _storage.ref().child('images').child('/${fileName}');
      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = ref.putData(await file.readAsBytes());
      } else {
        uploadTask = ref.putFile(io.File(file.path));
      }

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
