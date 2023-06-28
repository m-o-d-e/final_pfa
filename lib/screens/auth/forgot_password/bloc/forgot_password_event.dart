part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordEvent extends Equatable{
  const ForgotPasswordEvent();
}

class ForgotPasswordSendCodeEvent extends ForgotPasswordEvent {
  final String phoneNumber;
  final String countryCode;

  const ForgotPasswordSendCodeEvent({
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object> get props => [phoneNumber, countryCode];
}

class ForgotPasswordVerifyCodeEvent extends ForgotPasswordEvent {
  final String phoneNumber;
  final String countryCode;
  final String code;

  const ForgotPasswordVerifyCodeEvent({
    required this.phoneNumber,
    required this.countryCode,
    required this.code,
  });

  @override
  List<Object> get props => [phoneNumber, countryCode, code];
}

class ForgotPasswordChangePasswordEvent extends ForgotPasswordEvent {
  final String password;
  final String phoneNumber;
  final String countryCode;

  const ForgotPasswordChangePasswordEvent({
    required this.password,
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object> get props => [password, phoneNumber, countryCode];
}

class ForgotPasswordResendCodeEvent extends ForgotPasswordEvent {
  final String phoneNumber;
  final String countryCode;

  const ForgotPasswordResendCodeEvent({
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object> get props => [phoneNumber, countryCode];
}