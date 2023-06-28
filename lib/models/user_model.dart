import 'dart:convert';

import '../exceptions/user_exceptions.dart';
import '../services/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class User {
  int id;
  String email;
  String firstName;
  String lastName;
  String phoneNumber;
  String countryCode;
  String accessToken;
  int tokenExpiration;
  String refreshToken;
  int refreshTokenExpiration;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.countryCode,
    required this.accessToken,
    required this.tokenExpiration,
    required this.refreshToken,
    required this.refreshTokenExpiration,

  }) {
    if (isValidRefreshToken()) {
    } else {
      throw InvalidUserException();
    }
  }


  factory User.fromJson(Map<String, dynamic> json) {
    //print the json
    Map<String, dynamic> decodedToken = JwtDecoder.decode(json['token']);
    int exp = decodedToken['exp'];
    User user = User(
      id: json['id'].toInt(),
      email: json['email'].toString(),
      firstName: json['firstName'].toString(),
      lastName: json['lastName'].toString(),
      phoneNumber: json['phone'].toString(),
      countryCode: json['countryCode'].toString(),
      accessToken: json['token'].toString(),
      tokenExpiration: exp,
      refreshToken: json['refresh_token'].toString(),
      refreshTokenExpiration: json['refresh_token_expiration'].toInt(),
    );

    if (user.isValidRefreshToken()) {
      return user;
    } else {
      throw InvalidUserException();
    }
  }

  factory User.fromLoginJson(Map<String, dynamic> json) {
    //print the json
    Map<String, dynamic> decodedToken = JwtDecoder.decode(json['token']);
    int exp = decodedToken['exp'];
    User user = User(
      id: json['user']['id'].toInt(),
      email: json['user']['email'].toString(),
      firstName: json['user']['firstName'].toString(),
      lastName: json['user']['lastName'].toString(),
      phoneNumber: json['user']['phone'].toString(),
      countryCode: json['user']['countryCode'].toString(),
      accessToken: json['token'].toString(),
      tokenExpiration: exp,
      refreshToken: json['refresh_token'].toString(),
      refreshTokenExpiration: json['refresh_token_expiration'].toInt(),
    );

    if (user.isValidRefreshToken()) {
      return user;
    } else {
      throw InvalidUserException();
    }
  }

  String fullName() {
    return '$firstName $lastName';
  }

  bool isValidRefreshToken() {
     return DateTime.now().millisecondsSinceEpoch <
          refreshTokenExpiration * 1000;
  }

  bool isValidAccessToken() {
    print("Current time ${DateTime.now().millisecondsSinceEpoch}");
    print("tokenExpiration : ${tokenExpiration * 1000}");
    return DateTime.now().millisecondsSinceEpoch <
        tokenExpiration * 1000;
  }

  void getNewToken() async {
   try{
      User user = await AuthService.refreshToken(this);
      print("Saving the New user after refreshé");
      accessToken = user.accessToken;
      tokenExpiration = user.tokenExpiration;
      refreshToken = user.refreshToken;
      refreshTokenExpiration = user.refreshTokenExpiration;
      AuthService.saveUser(this);
    }catch(e){
      print("Inside getNewToken() catch block of user_model.dart");
      print(e);
   }
  }

  String toJson() {
    return jsonEncode(
      {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phoneNumber,
        'countryCode': countryCode,
        "token": accessToken,
        "refresh_token": refreshToken,
        "refresh_token_expiration": refreshTokenExpiration,
      },
    );
  }


}