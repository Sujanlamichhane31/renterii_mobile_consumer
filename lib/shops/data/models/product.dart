import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.category,
      required this.rentDuration,
      this.shop,
      this.pickup,
      this.typeOfRental,
      this.rentingRules,
      this.rentalFor,
      this.ref});
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final DocumentReference? ref;
  final int rentDuration;
  Double? rentalPrice;
  final DocumentReference? shop;
  final int? pickup;
  final int? typeOfRental;
  final String? rentingRules;
  final String? rentalFor;
}
