import "package:bloc/bloc.dart";

import "../repositories/parcel.repository.dart";

//Event
abstract class ParcelEvent {
  final String parcelName;
  final double area;
  ParcelEvent({required this.parcelName, required this.area});
}

class AddParcelEvent extends ParcelEvent {
  AddParcelEvent({required String parcelName, required double area})
      : super(parcelName: parcelName, area: area);
}

//State
abstract class ParcelState {}

class AddParcelSuccessState extends ParcelState {}

class AddParcelLoadingState extends ParcelState {}

class AddParcelErrorState extends ParcelState {
  final String errorMessage;

  AddParcelErrorState({required this.errorMessage});
}

class AddParcelInitialState extends ParcelState {}

//Bloc
class ParcelBloc1 extends Bloc<ParcelEvent, ParcelState> {
  ParcelRepository parcelRepository = ParcelRepository();
  ParcelBloc1() : super(AddParcelInitialState()) {
    on((AddParcelEvent event, emit) {
      emit(AddParcelLoadingState());
      try {
        parcelRepository.AddNewParcel(event.parcelName, event.area);
        emit(AddParcelSuccessState());
      } catch (e) {
        emit(
          AddParcelErrorState(
              errorMessage: "An error occurred while Adding New Parcel"),
        );
      }
    });
  }
}
