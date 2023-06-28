import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rive_animation/services/secure_storage_service.dart';
import '../blocs/auth_bloc.dart';
import '../exceptions/form_exceptions.dart';
import '../exceptions/sercure_storage_exception.dart';
import '../exceptions/user_exceptions.dart';
import '../models/user_model.dart';
import 'helper_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class AuthService {
  static const String loginPath = 'login_check';
  static const String registerPath = 'register';
  static const String refreshPath = 'token/refresh';
  static const String sendCodePath = 'send-verification-code';
  static const String verifyCodePath = 'verify-otp';
  static const String registerPhoneNumberPath = 'verify-otp/continue';
  static const String changePasswordPath = 'reset-password';

  final dio = Dio();

  static Future<User> loadUser() async {
    final json = await SecureStorageService.storage.read(
      key: SecureStorageService.userKey,
    );
    if (json != null) {
      User user = User.fromJson(jsonDecode(json));
      return user;
    } else {
      throw SecureStorageNotFoundException();
    }
  }

  static void saveUser(User user) async {
    print("Saving the user in the secure storage");
    await SecureStorageService.storage.write(
      key: SecureStorageService.userKey,
      value: user.toJson(),
    );
  }

  static Future<User> refreshToken(User user) async {
    print("We are refreshing the token");
    final response = await http.post(
      HelperService.buildUri(refreshPath, true),
      headers: HelperService.buildHeaders(),
      body: jsonEncode(
        {
          'refresh_token': user.refreshToken,
        },
      ),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        user.accessToken = json['token'];
        user.refreshToken = json['refresh_token'];
        user.refreshTokenExpiration = json['refresh_token_expiration'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(json['token']);
        int exp = decodedToken['exp'];
        user.tokenExpiration = exp;
        user.refreshTokenExpiration = json['refresh_token_expiration'];
        print("token refreshed and user saved");
        return user;
      case 400:
      case 300:
      case 500:
      default:
        logout();
        AuthBloc().add(AuthLogoutEvent());
        throw const HttpException(
          'An error occured while refreshing the token',
        );
    }
  }

  static Future<void> register(
      {required String email,
      required String password,
      required String phoneNumber,
      required String firstName,
      required String lastName,
      required String countryCode}) async {
    final uri = HelperService.buildUri(registerPath, false);
    final headers = HelperService.buildHeaders();
    final body = jsonEncode(
      {
        'email': email,
        'password': password,
        'phone': phoneNumber,
        'firstName': firstName,
        'lastName': lastName,
        'countryCode': countryCode
      },
    );
    print('Body: $body');

    final response = await http.post(
      uri,
      headers: headers,
      body: body,
    );
    print('Response status code: ${response.statusCode}');
    final statusType = (response.statusCode / 100).floor() * 100;
    print('Status type: $statusType');

    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        print('Response body: $json');
        break;

      case 400:
        if (response.statusCode == 406) {
          throw FormGeneralException(
              message: 'Adresse email ou numéro de téléphone déjà utilisé');
        }
        final json = jsonDecode(response.body);
        print(response.body);
        throw handleFormErrors(json);

      case 300:
      case 500:
      default:
        throw FormGeneralException(
            message: 'Erreur de connexion au serveur, réessayez plus tard');
    }
  }

  static Future<void> logout() async {
    await SecureStorageService.storage.delete(
      key: SecureStorageService.userKey,
    );
  }

  static Future<User> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      HelperService.buildUri(loginPath, true),
      headers: HelperService.buildHeaders(),
      body: jsonEncode(
        {
          'username': email.trim(),
          'password': password,
        },
      ),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        final user = User.fromLoginJson(json);

        saveUser(user);

        return user;
      case 400:
        if (response.statusCode == 401) {
          print("email : ${email} password: $password");
          print(response.body);
          throw FormGeneralException(
              message: 'Adresse email ou mot de passe est incorrect');
        }
        final json = jsonDecode(response.body);
        print(json);
        throw handleFormErrors(json);
      case 300:
      case 500:
      default:
        throw FormGeneralException(
            message: 'Erreur de connexion au serveur, réessayez plus tard');
    }
  }

  static Future<void> sendLoginVerificationCode(
      String phoneNumber, String countryCode) async {
    final response = await http.post(
      HelperService.buildUri(sendCodePath, true),
      headers: HelperService.buildHeaders(),
      body: jsonEncode(
        {'phone_number': phoneNumber, 'country_code': countryCode},
      ),
    );
    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        return;
      case 400:
        throw FormGeneralException(
            message: 'une erreur s\'est produite, merci de réssayer');
      case 300:
      case 500:
      default:
        throw FormGeneralException(
            message: 'Erreur de connexion au serveur, réessayez plus tard');
    }
  }

  static Future<dynamic> verifyOtp(
      String phoneNumber, String countryCode, String otpCode) async {
    final response = await http.post(
      HelperService.buildUri(verifyCodePath, true),
      headers: HelperService.buildHeaders(),
      body: jsonEncode(
        {
          'phone_number': phoneNumber,
          "country_code": countryCode,
          'code': otpCode
        },
      ),
    );
    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        final user = User.fromLoginJson(json);
        saveUser(user);
        return user;
      case 400:
        throw FormGeneralException(
            message:
                'Le code de vérification saisi est incorrect, veuillez réessayer s\'il vous plaît');
      case 300:
        throw InvalidUserException();
      case 500:
      default:
        throw FormGeneralException(
            message: 'Erreur de connexion au serveur, réessayez plus tard');
    }
  }

  static Future<dynamic> verifyResetPasswordCode(
      String phoneNumber, String countryCode, String otpCode) async {
    final response = await http.post(
      HelperService.buildUri(verifyCodePath, true),
      headers: HelperService.buildHeaders(),
      body: jsonEncode(
        {
          'phone_number': phoneNumber,
          "country_code": countryCode,
          'code': otpCode
        },
      ),
    );
    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
      case 300:
        return;
      case 400:
        throw FormGeneralException(
            message:
                'Le code de vérification saisi est incorrect, veuillez réessayer s\'il vous plaît');
      case 500:
      default:
        print(response.body);
        throw FormGeneralException(
            message: 'Erreur de connexion au serveur, réessayez plus tard');
    }
  }

  static Future<dynamic> registerPhoneNumber(
      String phoneNumber,
      String countryCode,
      String firstName,
      String lastName,
      String email) async {
    final response = await http.post(
      HelperService.buildUri(registerPhoneNumberPath, true),
      headers: HelperService.buildHeaders(),
      body: jsonEncode(
        {
          'phone': phoneNumber,
          "countryCode": countryCode,
          'firstName': firstName,
          'lastName': lastName,
          'email': email
        },
      ),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        final user = User.fromLoginJson(json);
        saveUser(user);
        return user;
      case 400:
      case 300:
      case 500:
      default:
        throw FormGeneralException(
            message: 'Erreur de connexion au serveur, réessayez plus tard');
    }
  }

  static Future<void> changePassword(
      String password, String phoneNumber, String countryCode) async {
    print(
        "password : $password, phoneNumber : $phoneNumber, countryCode : $countryCode");
    final response = await http.post(
      HelperService.buildUri(changePasswordPath, true),
      headers: HelperService.buildHeaders(),
      body: jsonEncode(
        {
          'new_password': password,
          'phone_number': phoneNumber,
          'country_code': countryCode
        },
      ),
    );
    print(response.body);
    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        return;
      case 400:
        throw FormGeneralException(
            message: 'Une erreur s\'est produite, veuillez réessayer');
      case 300:
      case 500:
      default:
        throw FormGeneralException(
            message: 'Erreur de connexion au serveur, réessayez plus tard');
    }
  }
}
