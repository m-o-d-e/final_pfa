import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repos/repositories.dart';
import 'parcel_events.dart';
import 'parcel_states.dart';

class ParcelBloc extends Bloc<ParcelEvent, ParcelState> {
  final ParcelRepository _userRepository;

  ParcelBloc(this._userRepository) : super(ParcelLoadingState()) {
    on<LoadParcelEvent>((event, emit) async {
      emit(ParcelLoadingState());
      try {
        final users = await _userRepository.getParcels();
        emit(ParcelLoadedState(users));
      } catch (e) {
        emit(ParcelErrorState(e.toString()));
      }
    });
  }
}
