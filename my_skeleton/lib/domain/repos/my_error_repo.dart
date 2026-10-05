import 'package:my_skeleton/domain/models/my_error.dart';
import 'package:my_skeleton/domain/services/my_error_service.dart';

class MyErrorRepo {
  /// Logs the error to Supabase.
  static Future<bool> sendError(MyError error) async =>
      await MyErrorService.sendError(error);
}
