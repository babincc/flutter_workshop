import 'package:my_skeleton/constants/database/db_columns.dart';
import 'package:my_skeleton/constants/database/db_tables.dart';
import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:my_skeleton/utils/debug_log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyUserService {
  static final SupabaseClient supabase = Supabase.instance.client;

  /// Fetches the user from Supabase.
  ///
  /// Returns `null` if the user does not exist.
  static Future<MyUser?> fetchUser(String userId) async {
    /// Fetch the user data from Supabase.
    final Map<String, dynamic>? data = await supabase
        .from(DbTables.users)
        .select()
        .eq(DbColumns.userId, userId)
        .maybeSingle();

    /// If the data does not exist, return null.
    if (data == null) {
      DebugLog.out(
        'MyUserService',
        'fetchUser',
        'Failed to fetch user $userId from Supabase!',
        logType: LogType.error,
        sendToDatabase: true,
      );
      return null;
    }

    return MyUser.fromJson(data);
  }

  /// Updates the given `user` in Supabase.
  ///
  /// Returns `true` if the `user` was updated in Supabase; otherwise, false.
  static Future<bool> updateUser(MyUser user) async {
    bool wasSuccessful = true;

    try {
      final updated = await supabase
          .from(DbTables.users)
          .update({
            DbColumns.nameFirst: user.firstName,
            DbColumns.nameLast: user.lastName,
            DbColumns.birthday: user.birthday.toIso8601String(),
          })
          .eq(DbColumns.userId, user.id)
          .select(DbColumns.userId)
          .maybeSingle();
      wasSuccessful = updated != null;
    } catch (e) {
      DebugLog.out(
        'MyUserService',
        'updateUser',
        'Failed to update user ${user.id} in '
            'Supabase!\n'
            'ErrorMsg: $e',
        logType: LogType.error,
        sendToDatabase: true,
      );
      wasSuccessful = false;
    }

    return wasSuccessful;
  }
}
