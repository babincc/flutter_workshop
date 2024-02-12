// @author Christian Babin
// @version 3.1.1
// https://github.com/babincc/flutter_workshop/blob/master/addons/debug_log.dart

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:my_skeleton/my_app.dart';
import 'package:stack_trace/stack_trace.dart';

/// This class is used to help with debugging.
class DebugLog {
  const DebugLog._();

  /// Prints a message to the console in testing, and sends it to Crashlytics
  /// in production.
  ///
  /// ```dart
  /// DebugLog.out('Howdy'); // "Howdy"
  /// DebugLog.out('Howdy', logType: LogType.error); // "Howdy" (in red)
  /// ```
  ///
  /// In the above examples, if the app is live, nothing happens. The example
  /// below shows how to send to Crashlytics.
  ///
  /// ```dart
  /// // If live, this will send "Howdy" to Crashlytics.
  /// // If testing, this will print "Howdy" to the console.
  /// DebugLog.out('Howdy', sendToCrashlytics: true);
  /// ```
  static void out(
    Object? message, {
    LogType logType = LogType.debug,
    bool sendToCrashlytics = false,
  }) {
    String messageString;
    if (message == null) {
      messageString = 'null';
    } else if (message is String) {
      messageString = message;
    } else {
      messageString = message.toString();
    }

    final List<String> messageList = messageString.split('\n');

    final Trace trace = Trace.current();

    final Frame? frame = trace.frames.firstWhereOrNull(
        (frame) => !frame.uri.toString().contains('debug_log.dart'));

    String callPath;

    if (frame == null) {
      callPath = 'unknown_calling_class: ';
    } else {
      callPath = '${frame.uri} ${frame.line ?? '??'}:${frame.column ?? '??'}\t'
          '${frame.member ?? 'unknown_calling_method'}';
    }

    if (!MyApp.isLive || !kReleaseMode) {
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

    if (sendToCrashlytics) {
      // Send the message to Crashlytics.
      _sendToCrashlytics('$callPath: $messageString');
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

  /// Sends a `message` to Crashlytics.
  static Future<void> _sendToCrashlytics(String message) async {
    /// The Crashlytics instance.
    final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

    /// Get the stack trace of the call to this debugger.
    List<String> stackTraceList = StackTrace.current.toString().split('\n');

    // Remove the first two lines of the stack trace, which are the call to
    // this debugger.
    stackTraceList = stackTraceList.getRange(2, stackTraceList.length).toList();

    /// The stack trace as a string.
    final String stackTraceString = stackTraceList.join('\n');

    /// The stack trace as a StackTrace object.
    final StackTrace stackTrace = StackTrace.fromString(stackTraceString);

    /// The Crashlytics message.
    await crashlytics.recordError(message, stackTrace, printDetails: false);
  }
}

/// The type of log to be printed.
enum LogType {
  /// Something important, but not necessarily app breaking.
  ///
  /// Will print in orange text if not in production, and the console supports
  /// it.
  warning,

  /// Something important and app breaking.
  ///
  /// Will print in red text if not in production, and the console supports it.
  error,

  /// Something that is important to know was successful.
  ///
  /// Will print in green text if not in production, and the console supports
  /// it.
  success,

  /// Something that is useful for debugging.
  ///
  /// Will print in blue text if not in production, and the console supports it.
  debug,
}
