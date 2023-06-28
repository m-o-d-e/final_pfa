import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart';

import '../../models/parcel_model.dart';
import '../services/interceptors/dio_interceptor.dart';

class ParcelRepository {
  String ParcelUrl = '/api/all-parcels/farm/2';

  Future<List<dynamic>> getParcels() async {
    try {
      final response = await Api().get(ParcelUrl);
      final List<dynamic> parcels =
          response.data['parcels'].map((e) => ParcelModel.fromJson(e)).toList();

      return parcels;
    } on DioError {
      print("there was an errorrrrrrrr");
      throw Exception('Failed to load data');
    }
  }
}
