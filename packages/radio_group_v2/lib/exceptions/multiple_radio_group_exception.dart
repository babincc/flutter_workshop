import 'package:flutter/material.dart';
import 'package:radio_group_v2/widgets/view_models/radio_group_controller.dart';
import 'package:radio_group_v2/widgets/views/radio_group.dart';

/// The exception that is thrown when a [RadioGroupController] is applied to
/// multiple [RadioGroup]s.
class MultipleRadioGroupException implements Exception {
  /// Throws an exception for a [RadioGroupController] that is applied to
  /// multiple [RadioGroup]s.
  ///
  /// `radioGroupController` is the controller that is throwing the error.
  ///
  /// `key` is the key to the second [RadioGroup] that `radioGroupController`
  /// was being applied to.
  MultipleRadioGroupException({
    RadioGroupController? radioGroupController,
    GlobalKey<RadioGroupState>? key,
  }) {
    /// This piece of the error message is set when `radioGroupController` is
    /// provided.
    String? errMsgRGC;

    // Check to see if the radio group controller that caused `this` exception
    // to be thrown was provided.
    if (radioGroupController != null) {
      if (key == null) {
        errMsgRGC = "RadioGroupController:"
            "${radioGroupController.myRadioGroupKey.toString()} is being "
            "applied to another `RadioGroup`!";
      } else {
        errMsgRGC = "This controller was already applied to RadioGroup:"
            "${radioGroupController.myRadioGroupKey.toString()} and it now "
            "being applied to RadioGroup:${key.toString()}!";
      }

      throw ("$_errMsgPt1 $errMsgRGC $_errMsgPt2\n\n$_hint");
    } else {
      throw (_cause);
    }
  }

  /// The first part of the error message.
  static const String _errMsgPt1 = "ERROR:";

  /// The last part of the error message.
  static const String _errMsgPt2 =
      "A `RadioGroupController` must only be applied to one `RadioGroup`!";

  static const String _hint =
      "Hint: This error can be caused when the parent of a `RadioGroup` "
      "rebuilds. This can cause a new key to be made for the `RadioGroup`, and "
      "that will confuse it. Don't pass a generic "
      "`GlobalKey<RadioGroupState>()` to your radio group. Keep a key in the "
      "parent of the `RadioGroup` and pass that to your `RadioGroup`.";

  /// The default error message.
  static const String _cause = "$_errMsgPt1 $_errMsgPt2\n\n$_hint";
}
