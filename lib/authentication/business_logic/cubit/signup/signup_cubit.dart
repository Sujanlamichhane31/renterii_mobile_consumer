import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';

import '../../../data/repositories/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  final UserCubit _userCubit;

  SignupCubit({
    required AuthRepository authRepository,
    required UserCubit userCubit,
  })  : _authRepository = authRepository,
        _userCubit = userCubit,
        super(SignupInitial());

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    double? latitude,
    double? longitude,
    String? address,
    String? description,
    required String userId,
    String? category,
  }) async {
    try {
      await _authRepository.updateUserProfile(
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          photoUrl: photoUrl,
          userId: userId,
          address: address,
          description: description,
          latitude: latitude,
          longitude: longitude,
          category: category);

      _userCubit.emitUpdatedUserInfos(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        photoUrl: photoUrl,
      );
      emit(SignupInfosSuccess());
    } catch (error) {
      emit(SignupInfosFailure());
    }
  }

  void startUpdatingUserLocation({
    required String address,
    required String addressType,
    required double latitude,
    required double longitude,
    required String userId,
  }) {
    emit(Loading());
    emit(
      UpdatingLocation(
        address: address,
        addressType: addressType,
        latitude: latitude,
        longitude: longitude,
        userId: userId,
      ),
    );
  }

  Future<void> updateUserLocation({
    required String address,
    required String addressType,
    required double latitude,
    required double longitude,
    required String userId,
  }) async {
    try {
      await _authRepository.updateUserLocation(
        address: address,
        addressType: addressType,
        latitude: latitude,
        longitude: longitude,
        userId: userId,
      );

      _userCubit.emitUpdatedUserInfos(
        address: address,
        addressType: addressType,
        latitude: latitude,
        longitude: longitude,
      );
      emit(SignupLocationSuccess());
    } catch (error) {
      emit(SignupLocationFailure());
    }
  }

  Future<void> updateUserProfilePicture({required File image}) async {
    final fileName = '${_userCubit.state.user.id}.jpg';

    try {
      emit(ImageUploadLoading());

      final String imageUrl = await _authRepository.updateUserProfilePicture(
        image: image,
        fileName: fileName,
      );

      _userCubit.emitUpdatedUserInfos(photoUrl: imageUrl);

      emit(ImageUploadSuccess());
    } catch (e) {
      print(e);
      emit(ImageUploadFailure());
    }
  }

  @override
  void onChange(Change<SignupState> change) {
    super.onChange(change);
    print(change);
  }
}
