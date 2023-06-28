import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rive_animation/exceptions/user_exceptions.dart';
import '../../../../exceptions/form_exceptions.dart';
import '../../../../models/user_model.dart';
import '../../../../services/auth_service.dart';
part 'otp_verification_event.dart';
part 'otp_verification_state.dart';

class OtpVerificationBloc extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  OtpVerificationBloc() : super(OtpVerificationFormState()) {

    on<OtpVerificationRequestEvent>((event, emit) async {
      emit(OtpVerificationLoadingState());
      try{
          final user = await AuthService.verifyOtp(
           event.phoneNumber, event.countryCode, event.otp
          );
          if(user == null){
            emit(OtpVerificationContinueRegisterState());
            return;
          }
          emit(OtpVerificationSuccessState(user: user));
      } on FormGeneralException catch(e){
        emit(OtpVerificationErrorState(e.message));
      } on InvalidUserException {
        emit(OtpVerificationContinueRegisterState());
      } catch(e){
        emit(const OtpVerificationErrorState("Un problème est survenu, merci de réssayer plus tard"));
      }
    });

    on<OtpResendEvent>((event, emit) async {
      emit(OtpVerificationResendLoadingState());
      try{
         await AuthService.sendLoginVerificationCode(event.phoneNumber, event.countryCode);
         emit(OtpVerificationResendSuccessState());
      } on FormGeneralException catch (e){
        emit(OtpVerificationResendErrorState(e.message));
      } catch(e){
        emit(OtpVerificationResendErrorState(e.toString()));
      }
    });

    on<RegisterPhoneNumberEvent>((event, emit) async {
      emit(OtpVerificationAccountCreationLoadingState());
      try{
        final user = await AuthService.registerPhoneNumber(
          event.phoneNumber,
          event.countryCode,
          event.firstName,
          event.lastName,
            event.email);
        emit(OtpVerificationAccountCreationSuccessState(user));
      } on FormGeneralException catch(e){
        emit(OtpVerificationAccountCreationErrorState(e.message));
      } catch(e){
         emit(const OtpVerificationAccountCreationErrorState("Une erreur est survenue lors du connexion au serveur, merci de réssayer plus tard"));
      }
    });
  }
}