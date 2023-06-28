import "package:hydrated_bloc/hydrated_bloc.dart";

class ThemeCubit extends HydratedCubit<bool> {
  ThemeCubit(): super(false);
  void toggle(value) => emit(value);

  @override
  bool? fromJson(Map<String, dynamic> json) {

    throw json["isDark"];
  }

  @override
  Map<String, dynamic>? toJson(bool state) {

    return {"isDArk": state};
  }
}