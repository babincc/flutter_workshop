/// This file contains the names of all of the column names as they appear in
/// Supabase.
///
/// This is done to prevent typos in code. By referring to these constant
/// strings, there won't be a chance of misspelling any of the names in other
/// parts of the code. This also allows for name changes in Supabase without
/// having to change the name in several places in the code.
class DbColumns {
  // --------------------------------- ERRORS ----------------------------------

  /// "created_at"
  static const String createdAt = 'created_at';

  /// "file"
  static const String file = 'file';

  /// "id"
  static const String id = 'id';

  /// "message"
  static const String message = 'message';

  /// "method"
  static const String method = 'method';

  /// "trace"
  static const String trace = 'trace';

  /// "type"
  static const String type = 'type';

  // ---------------------------------- USERS ----------------------------------

  /// "birthday"
  static const String birthday = 'birthday';

  // "created_at"
  // static const String createdAt = 'created_at';

  /// "friend_ids"
  static const String friendIds = 'friend_ids';

  /// "user_id"
  static const String userId = 'user_id';

  /// "name_first"
  static const String nameFirst = 'name_first';

  /// "name_last"
  static const String nameLast = 'name_last';

  /// "rank"
  static const String rank = 'rank';

  /// "role"
  static const String role = 'role';
}
