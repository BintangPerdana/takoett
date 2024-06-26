import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Takoett {
  String? id;
  final String title;
  final String description;
  String? image;
  double rating;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Takoett({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.rating,
    this.createdAt,
    this.updatedAt,
  });

  factory Takoett.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Takoett(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      image: data['image'],
      rating: data['rating'] ?? 0.0,
      createdAt: data['createdAt'] as Timestamp,
      updatedAt: data['updatedAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'rating': rating,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
