import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:renterii/authentication/data/models/transaction.dart';
import 'package:renterii/authentication/data/models/user.dart';
import 'package:renterii/authentication/data/repositories/wallet_repository.dart';

import '../../../../shared/enums.dart';
import '../../../data/repositories/auth_repository.dart';

part 'user_state.dart';

class UserCubit extends HydratedCubit<UserState> {
  final AuthRepository _authRepository;
  final WalletRepository _walletRepository;

  UserCubit({
    required AuthRepository authRepository,
    required WalletRepository walletRepository,
  })  : _authRepository = authRepository,
        _walletRepository = walletRepository,
        super(const UserState());

  Future<void> loginWithPhoneNumber({
    required String phoneNumber,
    int? forceResendingToken,
  }) async {
    emit(
      state.copyWith(
        status: UserStatus.loginLoading,
      ),
    );
    // await EasyLoading.show(status: 'loading...');

    Future<void> verificationCompleted(
        PhoneAuthCredential verificationCompleted) async {
      // await EasyLoading.dismiss();
      print('VERIFICATION COMPLETED');

      emit(
        state.copyWith(
          status: UserStatus.loginOtpSent,
          user: state.user.copyWith(phoneNumber: phoneNumber),
          phoneNumberVerificationId: verificationCompleted.verificationId,
        ),
      );

      PhoneAuthCredential authCredentials = PhoneAuthProvider.credential(
        verificationId: verificationCompleted.verificationId!,
        smsCode: verificationCompleted.smsCode!,
      );

      print('AUTH CREDENTIAL $authCredentials');

      final UserCredential userCredentials =
          await FirebaseAuth.instance.signInWithCredential(authCredentials);

      final token = await userCredentials.user!.getIdToken();

      // emit(
      //   state.copyWith(
      //     status: UserStatus.loginSuccess,
      //     isNewUser: userCredentials.additionalUserInfo!.isNewUser,
      //     user: CurrentUser(
      //       id: userCredentials.user!.uid,
      //       phoneNumber: userCredentials.user!.phoneNumber,
      //       name: userCredentials.user!.displayName!,
      //       photoUrl: userCredentials.user!.photoURL,
      //       email: userCredentials.user!.email,
      //     ),
      //     token: token,
      //   ),
      // );
      //
      // await _fetchUserProfile();

      print('USER CREDENTIAL $userCredentials');
    }

    Future<void> verificationFailed(
        FirebaseAuthException verificationFailed) async {
      // await EasyLoading.dismiss();

      print('VERIFICATION FAILED');
      print(verificationFailed.message);
      emit(
        state.copyWith(
          status: UserStatus.loginFailure,
        ),
      );
    }

    Future<void> codeSent(
      String verificationId,
      int? forceResendingToken,
    ) async {
      // await EasyLoading.dismiss();

      emit(
        state.copyWith(
          status: UserStatus.loginOtpSent,
          user: state.user.copyWith(phoneNumber: phoneNumber),
          phoneNumberVerificationId: verificationId,
        ),
      );
    }

    Future<void> codeAutoRetrievalTimeout(codeAutoRetrievalTimeout) async {
      // await EasyLoading.dismiss();
    }

    try {
      await _authRepository.loginWithPhoneNumber(
        phoneNumber: phoneNumber,
        forceResendingToken: forceResendingToken,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (error, stackTrace) {
      print('LOGIN WITH PHONE NUMBER ERROR $error');
      print(stackTrace);

      emit(
        state.copyWith(
          status: UserStatus.loginFailure,
        ),
      );
    }
  }

  Future<void> resendOTP() async {
    await loginWithPhoneNumber(
      phoneNumber: state.user.phoneNumber!,
      forceResendingToken: 1,
    );

    emit(
      state.copyWith(
        status: UserStatus.loginOtpReSent,
      ),
    );
  }

  Future<void> verifyOTP(String otp) async {
    try {
      // await EasyLoading.show(status: 'loading...');

      Map<String, dynamic> userData = await _authRepository.verifyOTP(
        otp,
        state.phoneNumberVerificationId,
      );

      // await EasyLoading.dismiss();

      emit(
        state.copyWith(
          status: UserStatus.loginSuccess,
          user: userData['user'],
          token: userData['token'],
          isNewUser: userData['isNewUser'],
        ),
      );

      if (!userData['isNewUser']) {
        _fetchUserProfile();
      }
    } catch (error, stackTrace) {
      print('VERIFY OTP ERROR $error');
      print(stackTrace);

      emit(
        state.copyWith(
          status: UserStatus.loginFailure,
        ),
      );
    }
  }

  Future<void> loginWithFacebook() async {}

  Future<void> loginWithGoogle() async {
    try {
      // await EasyLoading.show(status: 'loading...');

      final Map<String, dynamic> authData =
          await _authRepository.loginWithGoogle();

      final CurrentUser user = authData['user'];
      final String token = authData['token'];
      final bool isNewUser = authData['isNewUser'];

      // await EasyLoading.dismiss();

      emit(
        state.copyWith(
          status: UserStatus.loginGoogleSuccess,
          user: user,
          token: token,
          isNewUser: isNewUser,
        ),
      );

      if (!isNewUser) {
        _fetchUserProfile();
      }
    } catch (error, s) {
      print(error);
      print(s);
      emit(
        state.copyWith(
          status: UserStatus.loginFailure,
        ),
      );
    }
  }

  Future<void> loginWithApple() async {}

  Future<void> emitUpdatedUserInfos({
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    String? address,
    String? addressType,
    double? latitude,
    double? longitude,
  }) async {
    final user = state.user;

    emit(
      state.copyWith(
        user: state.user.copyWith(
          name: name ?? user.name,
          email: email ?? user.email,
          phoneNumber: phoneNumber ?? user.phoneNumber,
          photoUrl: photoUrl ?? user.photoUrl,
          address: address ?? user.address,
          addressType: addressType ?? user.addressType,
          latitude: latitude ?? user.latitude,
          longitude: longitude ?? user.longitude,
        ),
      ),
    );
  }

  Future<void> _fetchUserProfile() async {
    final data = await _authRepository.fetchUserProfile(
      userId: state.user.id,
    );

    final userProfileData = data['docData'];
    final List<UserTransaction> transactions = [];

    print('DATA_TRANSACTION ${userProfileData['transaction']}');
    print('DATA_WALLET_BALANCE ${userProfileData['walletBalance']}');

    if (userProfileData['transaction'] != null) {
      for (dynamic transaction in userProfileData['transaction']) {
        transactions.add(UserTransaction.fromMap(transaction));
      }
    }

    emit(
      state.copyWith(
        user: state.user.copyWith(
          name: userProfileData['name'],
          email: userProfileData['email'],
          phoneNumber: userProfileData['phoneNumber'],
          photoUrl: userProfileData['photoUrl'],
          address: userProfileData['address'],
          addressType: userProfileData['addressType'],
          latitude: userProfileData['latitude'],
          longitude: userProfileData['longitude'],
          walletBalance: userProfileData['walletBalance'],
          firestoreDocReference: data['docReference'],
          transactions: transactions,
        ),
      ),
    );
  }

  Future<void> addMoney(String amount) async {
    try {
      emit(
        state.copyWith(
          status: UserStatus.paymentLoading,
        ),
      );
      final paymentDone = await _walletRepository.makePayment(
        amount: double.parse(amount),
        currency: 'CAD',
        user: state.user,
      );
      final walletBalance = state.user.walletBalance ?? 0;

      if (paymentDone) {
        final double newWalletBalance = walletBalance + double.parse(amount);

        await _walletRepository.updateUserWalletBalance(
          amount: double.parse(amount),
          newWalletBalance: newWalletBalance,
          userId: state.user.id,
        );

        emit(
          state.copyWith(
            status: UserStatus.paymentSuccess,
            user: state.user.copyWith(
              walletBalance: newWalletBalance,
              transactions: [
                ...?state.user.transactions,
                UserTransaction(
                  date: DateTime.now(),
                  name: 'wallet reloaded',
                  sum: double.parse(amount),
                  type: 'payment',
                )
              ],
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: UserStatus.paymentFailure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> makePayment(
      String amount, PossiblePaymentMethods paymentMethod) async {
    try {
      emit(
        state.copyWith(
          status: UserStatus.paymentLoading,
        ),
      );
      bool paymentDone = false;
      final walletBalance = state.user.walletBalance ?? 0;

      switch (paymentMethod) {
        case PossiblePaymentMethods.creditCard:
          {
            paymentDone = await _walletRepository.makePayment(
              amount: double.parse(amount),
              currency: 'CAD',
              user: state.user,
            );

            if (paymentDone) {
              emit(
                state.copyWith(
                  status: UserStatus.paymentSuccess,
                ),
              );
            } else {
              throw 'Payment could not be processed!';
            }
          }
          break;

        case PossiblePaymentMethods.wallet:
          {
            if (walletBalance < double.parse(amount)) {
              throw 'Your wallet doesn\'t have enough money';
            }

            final double newWalletBalance =
                walletBalance - double.parse(amount);

            await _walletRepository.updateUserWalletBalance(
              amount: double.parse(amount),
              newWalletBalance: newWalletBalance,
              userId: state.user.id,
            );

            emit(
              state.copyWith(
                status: UserStatus.paymentSuccess,
                user: state.user.copyWith(
                  walletBalance: newWalletBalance,
                ),
              ),
            );
          }
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: UserStatus.paymentFailure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> logout() async {
    try {
      emit(
        state.copyWith(
          status: UserStatus.loading,
        ),
      );
      await _authRepository.logout();
      emit(
        state.copyWith(
          status: UserStatus.logout,
          token: null,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void onChange(Change<UserState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) {
    print('FROM JSON AAAAAAAAAAAAAA ${UserState.fromMap(json)}');
    return UserState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(UserState state) {
    if (state.user.id == '') {
      return null;
    }
    print('TO JSON ${state.toMap()}');
    return state.toMap();
  }
}