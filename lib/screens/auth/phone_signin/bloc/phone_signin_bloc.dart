import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../exceptions/form_exceptions.dart';
import '../../../../services/auth_service.dart';

part 'phone_signin_event.dart';
part 'phone_signin_state.dart';

class PhoneSigninBloc extends Bloc<PhoneSigninEvent, PhoneSigninState> {
  PhoneSigninBloc() : super(PhoneSigninFormState()) {
    on<PhoneSigninRequestEvent>((event, emit) async{
       emit(PhoneSigninLoadingState());
      try {
        await AuthService.sendLoginVerificationCode(
          event.phoneNumber,
          event.countryCode,
        );
        emit(PhoneSigninSuccessState());

      } on FormGeneralException catch (e) {
        emit(PhoneSigninErrorState(e.message));
      } on FormFieldsException catch (e) {
        emit(PhoneSigninErrorState(e.errors.toString()));
      }
      catch (e) {
        emit(const PhoneSigninErrorState("Une erreur s'est produit, merci de réssayer plus tard"));
      }
    });

  }
}