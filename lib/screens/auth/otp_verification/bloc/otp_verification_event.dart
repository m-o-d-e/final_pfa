part of 'otp_verification_bloc.dart';

abstract class OtpVerificationEvent extends Equatable{
  const OtpVerificationEvent();
}

class OtpVerificationRequestEvent extends OtpVerificationEvent {
  final String phoneNumber;
  final String countryCode;
  final String otp;

  const OtpVerificationRequestEvent({
    required this.phoneNumber,
    required this.countryCode,
    required this.otp
  });

  @override
  List<Object?> get props => [phoneNumber, countryCode, otp];
}

class OtpResendEvent extends OtpVerificationEvent{
  final String phoneNumber;
  final String countryCode;

  const OtpResendEvent({
    required this.phoneNumber,
    required this.countryCode,
  });
  @override
  List<Object?> get props => [phoneNumber, countryCode];

}

class RegisterPhoneNumberEvent extends OtpVerificationEvent{
  final String phoneNumber;
  final String countryCode;
  final String firstName;
  final String lastName;
  final String email;

  const RegisterPhoneNumberEvent({
    required this.phoneNumber,
    required this.countryCode,
    required this.firstName,
    required this.lastName,
    required this.email,
  });
  @override
  List<Object?> get props => [phoneNumber, countryCode, firstName, lastName, email];
}