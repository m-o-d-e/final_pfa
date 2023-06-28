part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordState extends Equatable{
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordFormState extends ForgotPasswordState {}

class ForgotPasswordLoadingState extends ForgotPasswordState {}

class ForgotPasswordSendCodeSuccessState extends ForgotPasswordState {
  final String message;

  const ForgotPasswordSendCodeSuccessState(this.message);

  @override
  List<Object> get props => [message];
}

class ForgotPasswordSendCodeErrorState extends ForgotPasswordState {
  final String message;

  const ForgotPasswordSendCodeErrorState(this.message);

  @override
  List<Object> get props => [message];
}

///////////////////////////////////////////////

class ForgotPasswordVerifyCodeSuccessState extends ForgotPasswordState {
  final String message;

  const ForgotPasswordVerifyCodeSuccessState(this.message);

  @override
  List<Object> get props => [message];
}

class ForgotPasswordVerifyCodeErrorState extends ForgotPasswordState {
  final String message;

  const ForgotPasswordVerifyCodeErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class ForgotPasswordVerifyCodeResendState extends ForgotPasswordState {
  final String message;

  const ForgotPasswordVerifyCodeResendState(this.message);

  @override
  List<Object> get props => [message];
}

///////////////////////////////////////////////

class ForgotPasswordChangeSuccessState extends ForgotPasswordState {
  final String message;

  const ForgotPasswordChangeSuccessState(this.message);

  @override
  List<Object> get props => [message];
}

class ForgotPasswordChangeErrorState extends ForgotPasswordState {
  final String message;

  const ForgotPasswordChangeErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class ForgotPasswordResendLoadingState extends ForgotPasswordState {}

class ForgotPasswordResendSuccessState extends ForgotPasswordState {
  const ForgotPasswordResendSuccessState();
}

class ForgotPasswordResendErrorState extends ForgotPasswordState {
  final String message;

  const ForgotPasswordResendErrorState(this.message);

  @override
  List<Object> get props => [message];
}
