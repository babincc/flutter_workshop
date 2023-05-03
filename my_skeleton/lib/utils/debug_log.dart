// @author Christian Babin
// @version 2.0.0
// https://github.com/babincc/flutter_workshop/blob/master/addons/debug_log.dart

// ignore_for_file: avoid_print

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_skeleton/my_app.dart';

/// This class is used to help with debugging.
class DebugLog {
  const DebugLog._();

  /// Prints a message to the console in testing, and sends it to Crashlytics
  /// in production.
  ///
  /// ```dart
  /// DebugLog.out("Howdy"); // Howdy
  /// DebugLog.out("Howdy", logType: LogType.error) // Howdy (in red)
  /// ```
  ///
  /// In the above examples, if the app is live, nothing happens. The example
  /// below shows how to send to Crashlytics.
  ///
  /// ```dart
  /// // If live, this will send "Howdy" to Crashlytics.
  /// // If testing, this will print "Howdy" to the console.
  /// DebugLog.out("Howdy", sendToCrashlytics: true)
  /// ```
  static void out(
    Object? message, {
    LogType logType = LogType.debug,
    bool sendToCrashlytics = false,
  }) {
    String messageString;
    if (message == null) {
      messageString = "null";
    } else if (message is String) {
      messageString = message;
    } else {
      messageString = message.toString();
    }

    /// The stack trace of the call to this debugger in a nicely formatted
    /// object.
    final _LoggerStackTrace stackTrace =
        _LoggerStackTrace.from(StackTrace.current);

    /// The runtime Type of the calling class.
    final String callingClass = stackTrace.callerClassName;

    /// The name of the calling method.
    final String callingMethod = stackTrace.callerFunctionName;

    final String callingFile = stackTrace.callerClassFileName;

    /// The line number of the call to this debugger in the calling method.
    final String callingLine = stackTrace.lineNumber.toString();

    /// The full path to the calling method.
    final String callPath =
        "$callingClass.$callingMethod [$callingFile:$callingLine]: ";

    /// The full message to be logged.
    final String logMessage = "$callPath$messageString";

    if (!MyApp.isLive) {
      switch (logType) {
        case LogType.warning:
          print("\x1B[33m$logMessage\x1B[0m");
          break;
        case LogType.error:
          print("\x1B[31m$logMessage\x1B[0m");
          break;
        case LogType.success:
          print("\x1B[32m$logMessage\x1B[0m");
          break;
        case LogType.debug:
          print("\x1B[34m$logMessage\x1B[0m");
          break;
      }

      return;
    }

    if (sendToCrashlytics) {
      // Send the message to Crashlytics.
      _sendToCrashlytics(logMessage);
    }
  }

  /// Sends a `message` to Crashlytics.
  static Future<void> _sendToCrashlytics(String message) async {
    /// The Crashlytics instance.
    final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

    /// Get the stack trace of the call to this debugger.
    List<String> stackTraceList = StackTrace.current.toString().split("\n");

    // Remove the first two lines of the stack trace, which are the call to
    // this debugger.
    stackTraceList = stackTraceList.getRange(2, stackTraceList.length).toList();

    /// The stack trace as a string.
    final String stackTraceString = stackTraceList.join("\n");

    /// The stack trace as a StackTrace object.
    final StackTrace stackTrace = StackTrace.fromString(stackTraceString);

    /// The Crashlytics message.
    await crashlytics.recordError(message, stackTrace, printDetails: false);
  }
}

/// Creates an object that allows the debugger to get information about the call
/// to this debugger.
class _LoggerStackTrace {
  const _LoggerStackTrace._({
    required this.callerFunctionName,
    required this.callerClassName,
    required this.callerClassFileName,
    required this.lineNumber,
  });

  factory _LoggerStackTrace.from(StackTrace trace) {
    final frames = trace.toString().split("\n");

    const String className = "debug_log.dart";

    final String frame = frames
        .firstWhere((frame) => _getFileInfoFromFrame(frame)[0] != className);

    final List<String> fileInfo = _getFileInfoFromFrame(frame);

    final String callerFunctionName = _getFunctionNameFromFrame(frame);

    return _LoggerStackTrace._(
      callerFunctionName: callerFunctionName.split(".")[1],
      callerClassName: callerFunctionName.split(".").first,
      callerClassFileName: fileInfo[0],
      lineNumber: int.parse(fileInfo[1]),
    );
  }

  final String callerFunctionName;
  final String callerClassName;
  final String callerClassFileName;
  final int lineNumber;

  static List<String> _getFileInfoFromFrame(String trace) {
    final indexOfFileName = trace.indexOf(RegExp(r"[A-Za-z_]+.dart"));
    final fileInfo = trace.substring(indexOfFileName);

    return fileInfo.split(":");
  }

  static String _getFunctionNameFromFrame(String trace) {
    final indexOfWhiteSpace = trace.indexOf(" ");
    final subStr = trace.substring(indexOfWhiteSpace);
    final indexOfFunction = subStr.indexOf(RegExp(r"[A-Za-z0-9_]"));

    return subStr
        .substring(indexOfFunction)
        .substring(0, subStr.substring(indexOfFunction).indexOf(" "));
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
