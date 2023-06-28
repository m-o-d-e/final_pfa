import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../../exceptions/form_exceptions.dart';
import '../../../../services/auth_service.dart';
part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordFormState()) {
    on<ForgotPasswordSendCodeEvent>((event, emit) async {
      emit(ForgotPasswordLoadingState());
      try {
        await AuthService.sendLoginVerificationCode(
          event.phoneNumber,
          event.countryCode,
        );
        emit(const ForgotPasswordSendCodeSuccessState(
            "Code envoyé avec succès"));
      } on FormGeneralException catch (e) {
        emit(ForgotPasswordSendCodeErrorState(e.message));
      } on FormFieldsException catch (e) {
        emit(ForgotPasswordSendCodeErrorState(e.errors.toString()));
      }
      catch (e) {
        emit(const ForgotPasswordSendCodeErrorState(
            "Une erreur s'est produit, merci de réssayer plus tard"));
      }
    });

    on<ForgotPasswordVerifyCodeEvent>((event, emit) async {
      emit(ForgotPasswordLoadingState());
      try {
        print("event.phoneNumber: ${event.phoneNumber}");
        print("event.countryCode: ${event.countryCode}");
        print("event.code: ${event.code}");
        await AuthService.verifyResetPasswordCode(
            event.phoneNumber, event.countryCode, event.code
        );
        emit(const ForgotPasswordVerifyCodeSuccessState(
            "Code vérifié avec succès"));
      } on FormGeneralException catch (e) {
        emit(ForgotPasswordVerifyCodeErrorState(e.message));
      } on FormFieldsException catch (e) {
        emit(ForgotPasswordVerifyCodeErrorState(e.errors.toString()));
      }
      catch (e) {
        emit(ForgotPasswordVerifyCodeErrorState(e.toString()));
      }
    });

    on<ForgotPasswordChangePasswordEvent>((event, emit) async {
      emit(ForgotPasswordLoadingState());
      try {
        await AuthService.changePassword(
            event.password, event.phoneNumber, event.countryCode
        );
        emit(const ForgotPasswordChangeSuccessState(
            "Mot de passe changé avec succès"));
      } on FormGeneralException catch (e) {
        emit(ForgotPasswordChangeErrorState(e.message));
      }
      catch (e) {
        emit(const ForgotPasswordChangeErrorState(
            "Impossible de changer le mot de passe, merci de réssayer plus tard"));
      }
    });

    on<ForgotPasswordResendCodeEvent>((event, emit) async {
        emit(ForgotPasswordLoadingState());
        try{
          await AuthService.sendLoginVerificationCode(event.phoneNumber, event.countryCode);
          emit(const ForgotPasswordResendSuccessState());
        } on FormGeneralException catch (e){
          emit(ForgotPasswordResendErrorState(e.message));
        } catch(e){
          emit(ForgotPasswordResendErrorState(e.toString()));
      }
    });
  }
}
