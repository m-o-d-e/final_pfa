part of 'phone_signin_bloc.dart';

abstract class PhoneSigninEvent extends Equatable{
  const PhoneSigninEvent();
}

class PhoneSigninRequestEvent extends PhoneSigninEvent {
  final String phoneNumber;
  final String countryCode;

  const PhoneSigninRequestEvent({
    required this.phoneNumber,
    required this.countryCode
  });

  @override
  List<Object?> get props => [phoneNumber, countryCode];
}