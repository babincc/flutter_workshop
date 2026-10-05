import 'package:my_skeleton/constants/database/db_columns.dart';
import 'package:my_skeleton/utils/debug_log.dart';

class MyError {
  /// Creates a [MyError] object.
  MyError({
    required this.file,
    required this.method,
    required this.message,
    required this.logType,
    required this.trace,
  });

  /// Creates a [MyError] object from a JSON data map.
  MyError.fromJson(Map<String, dynamic> data)
    : file = (data[DbColumns.file] as String?) ?? '',
      method = (data[DbColumns.method] as String?) ?? '',
      message = (data[DbColumns.message] as String?) ?? '',
      logType = LogType.fromString(data[DbColumns.type] as String? ?? ''),
      trace = (data[DbColumns.trace] as String?) ?? '';

  /// Creates an empty [MyError] object.
  MyError.empty()
    : file = '',
      method = '',
      message = '',
      logType = LogType.debug,
      trace = '';

  /// Whether or not this object is empty.
  bool get isEmpty =>
      file.isEmpty &&
      method.isEmpty &&
      message.isEmpty &&
      logType == LogType.debug &&
      trace.isEmpty;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The file where the error occurred.
  String file;

  /// The method where the error occurred.
  String method;

  /// The error message.
  String message;

  /// The type of error.
  LogType logType;

  /// The stack trace of the error.
  String trace;

  /// Returns a copy of this object.
  MyError copy() => copyWith();

  /// Returns a copy of this object with its field values replaced by the ones
  /// provided to this method.
  MyError copyWith({
    String? file,
    String? method,
    String? message,
    LogType? logType,
    String? trace,
  }) {
    return MyError(
      file: file ?? this.file,
      method: method ?? this.method,
      message: message ?? this.message,
      logType: logType ?? this.logType,
      trace: trace ?? this.trace,
    );
  }

  /// Returns a JSON representation of the object.
  Map<String, dynamic> toJson() {
    return {
      DbColumns.file: file,
      DbColumns.method: method,
      DbColumns.message: message,
      DbColumns.type: logType.value,
      DbColumns.trace: trace,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is MyError &&
        other.file == file &&
        other.method == method &&
        other.message == message &&
        other.logType == logType &&
        other.trace == trace;
  }

  @override
  int get hashCode => Object.hash(file, method, message, logType, trace);

  @override
  String toString() =>
      'Instance of MyError: {'
      'file: $file, '
      'method: $method, '
      'message: $message, '
      'logType: ${logType.value}, '
      'trace: $trace'
      '}';
}
