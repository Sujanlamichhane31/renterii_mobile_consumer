import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rentDuration,
    this.ref
  });
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final DocumentReference? ref;
  final int rentDuration;
}