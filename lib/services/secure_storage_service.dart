import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rive_animation/services/auth_service.dart';
import '../models/user_model.dart';

class SecureStorageService {
  static const storage = FlutterSecureStorage();

  static const String userKey = 'user';

  static void printSecureStorageContents() async {
    User user = await AuthService.loadUser();
    print("User: ${user.toJson()}");
  }
}