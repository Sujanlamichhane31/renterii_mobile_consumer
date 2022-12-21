import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:renterii/authentication/data/models/transaction.dart';

enum AddressType {
  Home,
  Office,
  Other,
}

class CurrentUser extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String? photoUrl;
  final String? phoneNumber;
  final String? address;
  final String? addressType;
  final double? latitude;
  final double? longitude;
  final String? description;
  final double? walletBalance;
  final String? category;
  final DocumentReference? firestoreDocReference;
  final List<UserTransaction>? transactions;

  CurrentUser({
    required this.id,
    required this.name,
    this.email,
    this.photoUrl,
    this.phoneNumber,
    this.address,
    this.addressType,
    this.latitude,
    this.longitude,
    this.description,
    this.walletBalance,
    this.firestoreDocReference,
    this.transactions,
    this.category,
  });

  const CurrentUser.empty({
    this.id = '',
    this.name = '',
    this.email = '',
    this.photoUrl = '',
    this.phoneNumber = '',
    this.address,
    this.addressType,
    this.latitude,
    this.longitude,
    this.walletBalance,
    this.transactions,
    this.firestoreDocReference,
    this.category,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'address': address,
      'addressType': addressType,
      'latitude': latitude,
      'longitude': longitude,
      // 'transactions': json.encode(transactions?.asMap() ?? [{}]),
      'walletBalance': walletBalance,
      // 'firestoreDocReference': firestoreDocReference,
      'category': category,
      'description': description,
    };
  }

  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    return CurrentUser(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      email: map['email'] as String,
      photoUrl: map['imageUrl'] as String,
      phoneNumber: map['phoneNumber'] as String,
      address: map['address'] as String,
      addressType: map['addressType'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      walletBalance: map['walletBalance'] as double,
      // firestoreDocReference: map['firestoreDocReference'] as DocumentReference,
      // transactions: List.from(json.decode(map['transactions'] as String)),
    );
  }

  CurrentUser copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    String? address,
    String? addressType,
    double? latitude,
    double? longitude,
    double? walletBalance,
    dynamic? transactions,
    DocumentReference? firestoreDocReference,
    String? description,
    String? category,
  }) {
    return CurrentUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      description: description ?? this.description,
      category: category ?? this.category,
      address: address ?? this.address,
      addressType: addressType ?? this.addressType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      walletBalance: walletBalance ?? this.walletBalance,
      transactions: transactions ?? this.transactions,
      firestoreDocReference:
          firestoreDocReference ?? this.firestoreDocReference,
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrentUser.fromJson(String source) =>
      CurrentUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CurrentUser{id: $id, name: $name, email: $email, category:$category, imageUrl: $photoUrl, '
        'phoneNumber: $phoneNumber, address: $address, addressType: $addressType, '
        'latitude: $latitude, longitude: $longitude, walletBalance: $walletBalance, '
        'transactions: $transactions}';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        photoUrl,
        description,
        phoneNumber,
        category,
        address,
        addressType,
        latitude,
        longitude,
        walletBalance,
        transactions,
        firestoreDocReference,
      ];
}
