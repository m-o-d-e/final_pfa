
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../exceptions/form_exceptions.dart';
import '../../../../models/user_model.dart';
import '../../../../services/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginFormState()) {
    on<LoginRequestEvent>((event, emit) async {
      emit(LoginLoadingState());
      try {
        final user = await AuthService.login(
          email: event.email,
          password: event.password,
        );
        emit(LoginSuccessState(
          user,
        ));
      } on FormGeneralException catch (e) {
        emit(LoginErrorState(e.message));
      } on FormFieldsException catch (e) {
        emit(LoginErrorState(e.errors.toString()));
      } catch (e) {
        emit(const LoginErrorState(
          //e.toString(),
          "La connexion au serveur a échoué, merci de réessayer plus tard"
        ));
      }
    });
  }
}

