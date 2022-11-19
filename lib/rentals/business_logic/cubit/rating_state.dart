part of 'rating_cubit.dart';

@immutable
class RatingState {
  final bool isSuccess;
  final bool isFailure;

  RatingState({
    this.isSuccess = false,
    this.isFailure = false
  });
  factory RatingState.loading() {
    return RatingState(isSuccess: true, isFailure: false);
  }

  factory RatingState.failure() {
    return RatingState(isSuccess: false, isFailure: true);
  }
  factory RatingState.success() {
    return RatingState(isSuccess: true, isFailure: false);
  }
}
