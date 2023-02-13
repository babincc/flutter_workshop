import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:my_skeleton/domain/services/my_user_service.dart';

class MyUserRepo {
  /// Creates a new user, and adds them to Firebase.
  static Future<MyUser> createUserDoc(String userId) async {
    return await MyUserService.createUserDoc(userId);
  }

  /// Fetches the user from Firebase.
  ///
  /// Returns `null` if the user does not exist.
  static Future<MyUser?> fetchUser(String userId) async {
    return await MyUserService.fetchUser(userId);
  }
}
