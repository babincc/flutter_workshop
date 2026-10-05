// @author Christian Babin
// @version 4.0.0
// https://github.com/babincc/flutter_workshop/blob/master/addons/debug_log.dart

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:my_skeleton/domain/models/my_error.dart';
import 'package:my_skeleton/domain/repos/my_error_repo.dart';
import 'package:stack_trace/stack_trace.dart';

/// This class is used to help with debugging.
class DebugLog {
  const DebugLog._();

  /// Prints a message to the console in testing, and sends it to the database
  /// in production.
  ///
  /// ```dart
  /// DebugLog.out('MyFile', 'MyMethod', 'Howdy'); // "MyFile/MyMethod: Howdy"
  /// DebugLog.out('MyFile', 'MyMethod', 'Howdy', logType: LogType.error); // "MyFile/MyMethod: Howdy" (in red)
  /// ```
  ///
  /// In the above examples, if the app is live, nothing happens. The example
  /// below shows how to send to the database.
  ///
  /// ```dart
  /// // If live, this will send "Howdy" to the database.
  /// // If testing, this will print "Howdy" to the console.
  /// DebugLog.out('MyFile', 'MyMethod', 'Howdy', sendToDatabase: true);
  /// ```
  static void out(
    String file,
    String method,
    Object? message, {
    LogType logType = LogType.debug,
    bool sendToDatabase = false,
  }) {
    String messagePrefix = '$file/$method: ';

    String messageString;
    if (message == null) {
      messageString = 'null';
    } else if (message is String) {
      messageString = message;
    } else {
      messageString = message.toString();
    }
    messageString = messagePrefix + messageString;

    final List<String> messageList = messageString.split('\n');

    final Trace trace = Trace.current();

    final Frame? frame = trace.frames.firstWhereOrNull(
      (frame) => !frame.uri.toString().contains('debug_log.dart'),
    );

    String callPath;

    if (frame == null) {
      callPath = 'unknown_calling_class: ';
    } else {
      callPath =
          '${frame.uri} ${frame.line ?? '??'}:${frame.column ?? '??'}\t'
          '${frame.member ?? 'unknown_calling_method'}';
    }

    if (!kReleaseMode) {
      // This print statement causes the console to create a hyperlink to the
      // file and line number of the call to this debugger. This can't be done
      // when color is applied.
      if (!kIsWeb && !Platform.isIOS) {
        print(callPath);
      }

      // Apply color to the message based on the log type, and print it.
      switch (logType) {
        case LogType.warning:
          _showWarning(callPath);
          for (String line in messageList) {
            _showWarning(line);
          }
          break;
        case LogType.error:
          _showError(callPath);
          for (String line in messageList) {
            _showError(line);
          }
          break;
        case LogType.success:
          _showSuccess(callPath);
          for (String line in messageList) {
            _showSuccess(line);
          }
          break;
        case LogType.debug:
          _showDebug(callPath);
          for (String line in messageList) {
            _showDebug(line);
          }
          break;
      }

      return;
    }

    if (sendToDatabase && kReleaseMode) {
      final MyError error = MyError(
        file: file,
        method: method,
        message: messageString,
        logType: logType,
        trace: callPath,
      );

      MyErrorRepo.sendError(error);
    }
  }

  /// Prints a message to the console in yellow text.
  static void _showWarning(String message) {
    // iOS doesn't support colored text in the console.
    if (!kIsWeb && Platform.isIOS) {
      print(message);
      return;
    }

    print('\x1B[33m$message\x1B[0m');
  }

  /// Prints a message to the console in red text.
  static void _showError(String message) {
    // iOS doesn't support colored text in the console.
    if (!kIsWeb && Platform.isIOS) {
      print(message);
      return;
    }

    print('\x1B[31m$message\x1B[0m');
  }

  /// Prints a message to the console in green text.
  static void _showSuccess(String message) {
    // iOS doesn't support colored text in the console.
    if (!kIsWeb && Platform.isIOS) {
      print(message);
      return;
    }

    print('\x1B[32m$message\x1B[0m');
  }

  /// Prints a message to the console in blue text.
  static void _showDebug(String message) {
    // iOS doesn't support colored text in the console.
    if (!kIsWeb && Platform.isIOS) {
      print(message);
      return;
    }

    print('\x1B[34m$message\x1B[0m');
  }
}

/// The type of log to be printed.
enum LogType {
  /// Something important, but not necessarily app breaking.
  ///
  /// Will print in orange text if not in production, and the console supports
  /// it.
  warning('warning'),

  /// Something important and app breaking.
  ///
  /// Will print in red text if not in production, and the console supports it.
  error('error'),

  /// Something that is important to know was successful.
  ///
  /// Will print in green text if not in production, and the console supports
  /// it.
  success('success'),

  /// Something that is useful for debugging.
  ///
  /// Will print in blue text if not in production, and the console supports it.
  debug('debug');

  const LogType(this.value);

  /// The string representation of this [LogType].
  final String value;

  /// Get a [LogType] from a given string `value`.
  static LogType fromString(String value) {
    return values.firstWhere(
      (role) => role.value == value,
      orElse: () => debug,
    );
  }
}
