import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class WalletDataProvider {
  Future<Map<String, dynamic>> createPaymentIntent({
    required String amount,
  }) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': 'CAD',
        'payment_method_types[]': 'card'
      };

      final response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51HyNgHFrhUhdspsN1ylK5rk6p33wzN8jtEPA0pqaH6vHSwYjWhHp5qHwIov2adrVZJur0XvmzjAeNthvuSy8Q4Ow007eogWqsZ',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (err) {
      log('err charging user: ${err.toString()}');
      rethrow;
    }
  }

  Future<void> updateUserWalletBalance({
    required double amount,
    required double newWalletBalance,
    required String userId,
  }) async {
    Map<String, dynamic> transaction = {
      'date': DateTime.now(),
      'name': 'wallet_reloaded',
      'sum': amount,
      'type': 'payment'
    };
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final id = sharedPreferences.getString("userId");
    try {
      if (userId == null) {
        Future.error('User not logged in');
      }

      final doc = FirebaseFirestore.instance.collection('users').doc(id);

      doc.update({
        'walletBalance': newWalletBalance,
        'transaction': FieldValue.arrayUnion([transaction])
      });
    } catch (error) {
      rethrow;
    }
  }
}
