import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:renterii/authentication/data/data_providers/auth_data_provider.dart';
import 'package:renterii/authentication/data/models/user.dart';

class AuthRepository {
  final AuthDataProvider _authDataProvider;

  const AuthRepository({required AuthDataProvider authDataProvider})
      : _authDataProvider = authDataProvider;

  bool autoLogin() {
    return _authDataProvider.autoLogin();
  }

  Future<void> loginWithPhoneNumber({
    required String phoneNumber,
    int? forceResendingToken,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    await _authDataProvider.loginWithPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: forceResendingToken,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<Map<String, dynamic>> verifyOTP(
      String otp, String phoneNumberVerificationId) async {
    try {
      final userCredentials = await _authDataProvider.verifyOTP(
        otp,
        phoneNumberVerificationId,
      );

      final token = await userCredentials.user!.getIdToken();
      final user = userCredentials.user;

      return {
        'user': CurrentUser(
          id: user!.uid,
          phoneNumber: user.phoneNumber ?? '',
          name: user.displayName ?? '',
          photoUrl: user.photoURL ?? '',
        ),
        'token': token,
        'isNewUser': userCredentials.additionalUserInfo!.isNewUser
      };
    } catch (error) {
      rethrow;
    }
  }

  Future<void> loginWithFacebook() async {
    await _authDataProvider.loginWithFacebook();
  }

  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      final Map<String, dynamic> googleSignInData =
          await _authDataProvider.loginWithGoogle();

      final User googleUser = googleSignInData['googleUser'];
      final isNewUser = googleSignInData['isNewUser'];

      final token = await googleUser.getIdToken();

      return {
        'user': CurrentUser(
          id: googleUser.uid,
          name: googleUser.displayName ?? '',
          email: googleUser.email ?? '',
          photoUrl: googleUser.photoURL ?? '',
          phoneNumber: googleUser.phoneNumber ?? '',
        ),
        'token': token,
        'isNewUser': isNewUser,
      };
    } catch (error) {
      rethrow;
    }
  }

  Future<void> loginWithApple() async {
    await _authDataProvider.loginWithApple();
  }

  Future<Map<String, dynamic>> fetchUserProfile({
    required String userId,
  }) async {
    final data = await _authDataProvider.fetchUserProfile(userId: userId);
    final DocumentSnapshot docSnapshot = data['docSnapshot'];
    final DocumentReference docReference = data['docReference'];

    if (!docSnapshot.exists) {
      return {};
    }

    return {
      'docData': docSnapshot.data() as Map<String, dynamic>,
      'docReference': docReference,
    };
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    required String userId,
    String? address,
    double? latitude,
    double? longitude,
    String? description,
    String? category,
  }) async {
    try {
      await _authDataProvider.updateUserProfile(
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          photoUrl: photoUrl,
          address: address,
          description: description,
          latitude: latitude,
          longitude: longitude,
          category: category,
          userId: userId);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateUserLocation({
    required String address,
    required String addressType,
    required double latitude,
    required double longitude,
    required String userId,
  }) async {
    try {
      await _authDataProvider.updateUserLocation(
          address: address,
          addressType: addressType.toUpperCase(),
          latitude: latitude,
          longitude: longitude,
          userId: userId);
    } catch (error) {
      rethrow;
    }
  }

  Future<String> updateUserProfilePicture({
    required File image,
    required String fileName,
  }) async {
    final String imageUrl = await _authDataProvider.updateUserProfilePicture(
      image: image,
      fileName: fileName,
    );

    return imageUrl;
  }

  Future<void> logout() async {
    try {
      await _authDataProvider.logout();
    } catch (e) {
      rethrow;
    }
  }
}
