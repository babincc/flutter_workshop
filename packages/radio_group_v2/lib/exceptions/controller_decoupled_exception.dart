import 'package:radio_group_v2/widgets/view_models/radio_group_controller.dart';

/// The exception that is thrown when the [RadioGroupController] can no longer
/// see its [RadioGroup].
class ControllerDecoupledException implements Exception {
  /// Throws an exception for a [RadioGroupController] that can no longer see
  /// its [RadioGroup].
  ///
  /// `radioGroupController` is the controller that is throwing the error.
  ControllerDecoupledException({RadioGroupController? radioGroupController}) {
    // Check to see if the radio group controller that caused `this` exception
    // to be thrown was provided.
    if (radioGroupController == null) {
      // If no controller was provided, throw the default error message.
      throw (_cause);
    } else {
      // If the radio group controller was provided, include it in the error
      // message to help with debugging.
      throw ("$_errMsgPt1 "
          "RadioGroupController:"
          "${radioGroupController.myRadioGroupKey.toString()} $_errMsgPt2");
    }
  }

  /// The first part of the error message.
  static const String _errMsgPt1 = "ERROR:";

  /// The last part of the error message.
  static const String _errMsgPt2 = "has lost track of its `RadioGroup`!";

  /// The default error message.
  static const String _cause =
      "$_errMsgPt1 This `RadioGroupController` $_errMsgPt2";
}
