import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/parcel_model.dart';

@immutable
abstract class ParcelState extends Equatable {}

class ParcelLoadingState extends ParcelState {
  @override
  List<Object?> get props => [];
}

class ParcelLoadedState extends ParcelState {
  final List<dynamic> parcels;

  ParcelLoadedState(this.parcels);
  @override
  List<Object?> get props => [parcels];
}

class ParcelErrorState extends ParcelState {
  final String error;
  ParcelErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
