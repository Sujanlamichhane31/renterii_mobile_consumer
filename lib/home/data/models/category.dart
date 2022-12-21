import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ShopCategory extends Equatable {
  final DocumentReference? id;
  final String name;

  const ShopCategory({required this.name, this.id});

  @override
  List<Object?> get props => [];
}
