import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../exceptions/form_exceptions.dart';
import '../../../../services/auth_service.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterFormState()) {
    on<RegisterRequestEvent>((event, emit) async {
      emit(RegisterLoadingState());
      try {
        final user = await AuthService.register(
          email: event.email,
          password: event.password,
          phoneNumber: event.phoneNumber,
          firstName: event.firstName,
          lastName: event.lastName,
          countryCode : event.countryCode,
        );
        emit(RegisterSuccessState());
      } on FormGeneralException catch (e) {
        emit(RegisterErrorState(e.message));
      } on FormFieldsException catch (e) {
        emit(RegisterErrorState(e.errors.toString()));
      } catch (e) {
        emit(const RegisterErrorState(
            "La connexion au server a échoué, merci de réessayer plus tard"
        ));
      }
    });
  }
}