part of 'signup_cubit.dart';

abstract class SignupState extends Equatable {
  const SignupState();
}

class SignupInitial extends SignupState {
  @override
  List<Object> get props => [];
}

class Loading extends SignupState {
  @override
  List<Object> get props => [];
}

class SignupInfosSuccess extends SignupState {
  @override
  List<Object> get props => [];
}

class SignupInfosFailure extends SignupState {
  @override
  List<Object> get props => [];
}

class SignupLocationSuccess extends SignupState {
  @override
  List<Object> get props => [];
}

class SignupLocationFailure extends SignupState {
  @override
  List<Object> get props => [];
}

class SignupLoading extends SignupState {
  @override
  List<Object> get props => [];
}

class ImageUploadSuccess extends SignupState {
  @override
  List<Object> get props => [];
}

class ImageUploadLoading extends SignupState {
  @override
  List<Object> get props => [];
}

class ImageUploadFailure extends SignupState {
  @override
  List<Object> get props => [];
}

class UpdatingLocation extends SignupState {
  final String address;
  final String addressType;
  final double latitude;
  final double longitude;
  final String userId;

  const UpdatingLocation({
    required this.address,
    required this.addressType,
    required this.latitude,
    required this.longitude,
    required this.userId,
  });

  @override
  List<Object> get props => [];
}
