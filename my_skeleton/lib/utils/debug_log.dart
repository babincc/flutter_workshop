// @author Christian Babin
// @version 1.1.2
// https://github.com/babincc/flutter_workshop/blob/master/addons/debug_log.dart

import 'dart:math';

/// This class is used to help with debugging.
class DebugLog {
  /// This method is used for making print statements that can be traced back to
  /// a specific class.
  ///
  /// This makes it easier to find leftover print statements later when it is
  /// time to remove them.
  ///
  /// The `isImportant` boolean value will be `true` if you want to print a few
  /// lines above and below the message to make it stand out in the console.
  static void out(
    String className,
    String methodName,
    String? message, {
    bool isImportant = false,
  }) {
    assert(className.isNotEmpty, "WARNING: You must enter a class name!");
    assert(methodName.isNotEmpty, "WARNING: You must enter a method name!");

    // Pad the message if necessary.
    if (isImportant) {
      _printMessagePadding(
        className,
        methodName,
        padding: 3,
      );
    }

    // Print the message.
    // ignore: avoid_print
    print("$className/$methodName: $message");

    // Pad the message if necessary.
    if (isImportant) {
      _printMessagePadding(
        className,
        methodName,
        padding: 3,
        isPrePadding: false,
      );
    }
  }

  /// This method prints a statement that pads the debug message to make it
  /// stand out in the console.
  ///
  /// The `padding` variable is the number of times the statement will print.
  ///
  /// The `isPrePadding` variable will be `true` if the padding is to be printed
  /// before the error message; conversely, it will be `false` if it is to be
  /// printed after the error message. This will make the "stair-step" pattern
  /// in the console symmetrical.
  static void _printMessagePadding(
    String className,
    String methodName, {
    int padding = 1,
    bool isPrePadding = true,
  }) {
    // `padding` must be >= 1.
    padding = max(padding, 1);

    /// The default number of exclamation marks.
    const String baseExclamation = "!!!!!!";

    // Print the attention getter `padding` number of times.
    for (int i = 0; i < padding; i++) {
      // The base of the string tells where the print statement is coming from.
      String toPrint = "$className/$methodName: ";

      // Add the exclamation marks.
      toPrint += baseExclamation;

      // Add more exclamation marks based on what line is being printed.
      if (isPrePadding) {
        for (int j = 0; j < i; j++) {
          toPrint += "!";
        }
      } else {
        for (int j = padding - 1; j > i; j--) {
          toPrint += "!";
        }
      }

      // Add the attention grabbing message and the base number of exclamation
      // marks.
      toPrint += " IMPORTANT $baseExclamation";

      // Add more exclamation marks based on what line is being printed.
      if (isPrePadding) {
        for (int j = 0; j < i; j++) {
          toPrint += "!";
        }
      } else {
        for (int j = padding - 1; j > i; j--) {
          toPrint += "!";
        }
      }

      // ignore: avoid_print
      print(toPrint);
    }
  }
}
