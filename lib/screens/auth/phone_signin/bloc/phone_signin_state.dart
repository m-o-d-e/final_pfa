part of 'phone_signin_bloc.dart';

abstract class PhoneSigninState extends Equatable {
  const PhoneSigninState();

  @override
  List<Object> get props => [];
}

class PhoneSigninFormState extends PhoneSigninState {}

class PhoneSigninLoadingState extends PhoneSigninState {}

class PhoneSigninSuccessState extends PhoneSigninState {}

class PhoneSigninErrorState extends PhoneSigninState {
  final String message;

  const PhoneSigninErrorState(this.message);

  @override
  List<Object> get props => [message];
}