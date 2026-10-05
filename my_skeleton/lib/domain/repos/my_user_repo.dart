import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:my_skeleton/domain/services/my_user_service.dart';

class MyUserRepo {
  /// Fetches the user from Supabase.
  ///
  /// Returns `null` if the user does not exist.
  static Future<MyUser?> fetchUser(String userId) async =>
      await MyUserService.fetchUser(userId);

  /// Updates the given `user` in Supabase.
  ///
  /// Returns `true` if the `user` was updated in Supabase; otherwise, false.
  static Future<bool> updateUser(MyUser user) async =>
      await MyUserService.updateUser(user);
}
