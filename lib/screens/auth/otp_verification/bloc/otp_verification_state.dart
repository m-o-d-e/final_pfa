part of 'otp_verification_bloc.dart';

@immutable
abstract class OtpVerificationState extends Equatable{
  const OtpVerificationState();

  @override
  List<Object> get props => [];
}

class OtpVerificationFormState extends OtpVerificationState {}

class OtpVerificationLoadingState extends OtpVerificationState {}

class OtpVerificationSuccessState extends OtpVerificationState {
  final User user;

  const OtpVerificationSuccessState({required this.user});
}

class OtpVerificationErrorState extends OtpVerificationState {
  final String message;

  const OtpVerificationErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class OtpVerificationResendLoadingState extends OtpVerificationState {}

class OtpVerificationResendSuccessState extends OtpVerificationState {}

class OtpVerificationResendErrorState extends OtpVerificationState {
  final String message;

  const OtpVerificationResendErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class OtpVerificationContinueRegisterState extends OtpVerificationState {}

class OtpVerificationAccountCreationLoadingState extends OtpVerificationState {}

class OtpVerificationAccountCreationSuccessState extends OtpVerificationState {
  final User user;

  const OtpVerificationAccountCreationSuccessState(this.user);

  @override
  List<Object> get props => [user];
}

class OtpVerificationAccountCreationErrorState extends OtpVerificationState {
  final String message;

  const OtpVerificationAccountCreationErrorState(this.message);

  @override
  List<Object> get props => [message];
}