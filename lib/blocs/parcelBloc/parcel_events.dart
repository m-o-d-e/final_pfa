import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ParcelEvent extends Equatable {
  const ParcelEvent();
}

class LoadParcelEvent extends ParcelEvent {
  @override
  List<Object?> get props => [];
}
