import 'package:my_skeleton/constants/database/db_tables.dart';
import 'package:my_skeleton/domain/models/my_error.dart';
import 'package:my_skeleton/utils/debug_log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyErrorService {
  static final SupabaseClient supabase = Supabase.instance.client;

  /// Logs the error to Supabase.
  static Future<bool> sendError(MyError error) async {
    bool wasSuccessful = true;

    try {
      await supabase.from(DbTables.errors).insert(error.toJson());
    } catch (e) {
      DebugLog.out(
        'MyErrorService',
        'sendError',
        'Failed to log error in the database!\n'
            'ErrorMsg: $e',
        logType: LogType.error,
        sendToDatabase: false,
      );
      wasSuccessful = false;
    }

    return wasSuccessful;
  }
}
