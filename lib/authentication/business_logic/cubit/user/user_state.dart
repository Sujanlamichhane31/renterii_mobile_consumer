part of 'user_cubit.dart';

enum UserStatus {
  initial,
  loginLoading,
  loginOtpSent,
  loginOtpReSent,
  loginSuccess,
  logout,
  loading,
  loginGoogleSuccess,
  loginFailure,
  paymentSuccess,
  paymentLoading,
  paymentFailure,
}

class UserState extends Equatable {
  final UserStatus status;
  final CurrentUser user;
  final String token;
  final String phoneNumberVerificationId;
  final bool isNewUser;
  final String? errorMessage;

  const UserState({
    this.status = UserStatus.initial,
    this.user = const CurrentUser.empty(),
    this.token = '',
    this.phoneNumberVerificationId = '',
    this.isNewUser = false,
    this.errorMessage = '',
  });

  UserState copyWith({
    UserStatus? status,
    CurrentUser? user,
    String? token,
    String? phoneNumberVerificationId,
    bool? isNewUser,
    String? errorMessage,
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      phoneNumberVerificationId:
          phoneNumberVerificationId ?? this.phoneNumberVerificationId,
      isNewUser: isNewUser ?? this.isNewUser,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.toString(),
      'user': user.toJson(),
      'token': token,
      'phoneNumberVerificationId': phoneNumberVerificationId,
      'isNewUser': isNewUser,
      'errorMessage': errorMessage,
    };
  }

  factory UserState.fromMap(Map<String, dynamic> map) {
    return UserState(
      status: UserStatus.values
          .firstWhere((status) => status.toString() == map['status'] as String),
      user: CurrentUser.fromJson(map['user'] as String),
      token: map['token'] as String,
      phoneNumberVerificationId: map['phoneNumberVerificationId'] as String,
      isNewUser: map['isNewUser'] as bool,
      errorMessage: map['errorMessage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserState.fromJson(String source) =>
      UserState.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LoginState{status: $status, user: $user, '
        'token: ${token == '' ? '' : token.substring(0, 5)}, '
        'phoneNumberVerificationId: ${phoneNumberVerificationId == '' ? '' : phoneNumberVerificationId.substring(0, 5)}, '
        'isNewUser: $isNewUser}'
        'errorMessage: $errorMessage';
  }

  @override
  List<Object?> get props => [
        status,
        user,
        token,
        phoneNumberVerificationId,
        isNewUser,
        errorMessage,
      ];
}
