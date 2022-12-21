import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserTransaction extends Equatable {
  final DateTime date;
  final String name;
  final double sum;
  final String type;

  const UserTransaction({
    required this.date,
    required this.name,
    required this.sum,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'name': name,
      'sum': sum,
      'type': type,
    };
  }

  factory UserTransaction.fromMap(Map<String, dynamic> map) {
    return UserTransaction(
      date: DateTime.fromMillisecondsSinceEpoch(
          (map['date'] as Timestamp).millisecondsSinceEpoch),
      name: map['name'] as String,
      sum: map['sum'] as double,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserTransaction.fromJson(String source) =>
      UserTransaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserTransaction{date: $date, name: $name, sum: $sum, type: $type}';
  }

  @override
  List<Object> get props => [date, name, sum, type];
}
