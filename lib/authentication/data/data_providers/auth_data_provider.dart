import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthDataProvider {
  bool autoLogin() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    }

    if (GoogleSignIn().currentUser != null) {
      return true;
    }

    return false;
  }

  Future<void> loginWithPhoneNumber({
    required String phoneNumber,
    int? forceResendingToken,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        forceResendingToken: forceResendingToken,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<UserCredential> verifyOTP(
      String otp, String phoneNumberVerificationId) async {
    PhoneAuthCredential authCredentials = PhoneAuthProvider.credential(
      verificationId: phoneNumberVerificationId,
      smsCode: otp,
    );
    try {
      final UserCredential userCredentials =
          await FirebaseAuth.instance.signInWithCredential(authCredentials);

      log('USER CREDENTIAL $userCredentials');

      if (userCredentials.user == null) {
        throw '!USER';
      }

      final String userId = FirebaseAuth.instance.currentUser!.uid;

      if (userCredentials.additionalUserInfo!.isNewUser) {
        await _startUserProfile(
          userId: userId,
          phoneNumber: userCredentials.user!.phoneNumber!,
        );
      }

      return userCredentials;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> loginWithFacebook() async {}

  Future<Map<String, dynamic>> loginWithGoogle() async {
    // GoogleSignIn _googleSignIn = GoogleSignIn(
    //   scopes: [
    //     'email',
    //     'https://www.googleapis.com/auth/contacts.readonly',
    //   ],
    // );
    //
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

      log("${googleAuthProvider.scopes}");

      final userCredential = await FirebaseAuth.instance
          .signInWithAuthProvider(googleAuthProvider);

      log("$userCredential");

      final user = userCredential.user;

      if (user == null) {
        throw 'NOT USER IN GOOGLE SIGN IN';
      }

      // final userId = userCredential.additionalUserInfo?.profile?['id'];
      final userId = user.uid;
      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? true;

      // final bool isNewUser = await _isNewUser(userId: userId);

      log('IS_NEW_USER: $isNewUser');

      if (isNewUser) {
        await _startUserProfile(
          userId: userId,
          name: user.displayName,
          email: user.email,
          phoneNumber: user.phoneNumber,
          imageUrl: user.photoURL,
        );
      }

      return {
        'googleUser': user,
        'isNewUser': isNewUser,
      };
    } catch (error) {
      rethrow;
    }
  }

  Future<void> loginWithApple() async {}

  Future<bool> _isNewUser({required String userId}) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(userId);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      return true;
    }

    return false;
  }

  Future<void> _startUserProfile({
    required String userId,
    String? name,
    String? email,
    String? phoneNumber,
    String? imageUrl,
  }) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(userId);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      doc.set({
        'walletBalance': 0.0,
        'name': name ?? '',
        'email': email ?? '',
        'phoneNumber': phoneNumber ?? '',
        'imageUrl': imageUrl ?? '',
        'description': '',
        'address': '',
        'latitude': 0.0,
        'longitude': 0.0,
      });
    } else {
      log('USER EXISTS');
    }
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    String? description,
    String? category,
    String? address,
    double? latitude,
    double? longitude,
    required String userId,
  }) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final id = sharedPreferences.getString("userId");
      final DocumentReference user = FirebaseFirestore.instance
          .collection('users')
          .doc(userId.isEmpty ? id : userId);
      final Map<String, dynamic> userData =
          (await user.get()).data() as Map<String, dynamic>;

      user.update({
        'name': name ?? '',
        'email': email ?? '',
        'phoneNumber': phoneNumber ?? '',
        'imageUrl': photoUrl ?? '',
        'description': description ?? '',
        'address': address ?? '',
        'latitude': latitude ?? 0.0,
        'longitude': longitude ?? 0.0,
        'category': category ?? '-1',
      });

      // if (name != null) {
      //   user.updateDisplayName(name);
      // }
      //
      // if (email != null) {
      //   user.updateEmail(email);
      // }
      //
      // if (photoUrl != null) {
      //   user.updatePhotoURL(photoUrl);
      // }

      // if (phoneNumber != null) {
      //   await FirebaseAuth.instance.verifyPhoneNumber(
      //     phoneNumber: phoneNumber,
      //     verificationCompleted: (PhoneAuthCredential verificationCompleted) {
      //       user.updatePhoneNumber(verificationCompleted);
      //     },
      //     verificationFailed: (FirebaseAuthException verificationFailed) {
      //       log('Verification failed');
      //       log(verificationFailed);
      //     },
      //     codeSent: (
      //         String verificationId,
      //         int? forceResendingToken,
      //         ) {
      //       phoneNumberVerificationId = verificationId;
      //       log(phoneNumberVerificationId);
      //     },
      //     codeAutoRetrievalTimeout: (codeAutoRetrievalTimeout) {},
      //   );
      // }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile(
      {required String userId}) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(userId);

    final snapshot = await doc.get();

    return {
      'docSnapshot': snapshot,
      'docReference': doc,
    };
  }

  Future<void> updateUserLocation({
    required String address,
    required String addressType,
    required double latitude,
    required double longitude,
    required String userId,
  }) async {
    try {
      final doc = FirebaseFirestore.instance.collection('users').doc(userId);

      doc.update({
        'address': address,
        'addressType': addressType,
        'latitude': latitude,
        'longitude': longitude,
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<String> updateUserProfilePicture({
    required File image,
    required String fileName,
  }) async {
    final storageRef = FirebaseStorage.instance.ref();
    final profilePictureRef = storageRef.child('profiles_pictures/$fileName');

    try {
      await profilePictureRef.putFile(image);

      final userId = FirebaseAuth.instance.currentUser!.uid;
      final doc = FirebaseFirestore.instance.collection('users').doc(userId);
      final imageUrl = await profilePictureRef.getDownloadURL();

      doc.update({
        'imageUrl': imageUrl,
      });

      return imageUrl;
    } on FirebaseException catch (e) {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
