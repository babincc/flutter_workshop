// @author Christian Babin
// @version 1.1.0
// https://github.com/babincc/flutter_workshop/blob/master/addons/alert.dart

import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This file allows for the creation of a pop-up that will cover a lot of the
/// screen with an opaque message box and fills the rest of the screen with a
/// translucent overlay to disable touching the page in the background.
///
/// This pop-up can be used to give the user warnings, give them information,
/// allow for confirmation before certain actions, etc.
///
/// ## Examples
///
/// {@tool snippet}
///
/// ### Warning Dialog Example
///
/// This example shows the creation of an alert that is used as a warning. It
/// can explain to the user why they are not being allowed to do a certain
/// thing.
///
/// ```dart
/// /// The alert dialog that will be shown to the user.
/// Alert myAlert = Alert(
///   context: context,
///   title: "Action Blocked!",
///   content: "Your attempt to do this action has been blocked because this "
///       "action can not be completed at this time. Thank you!",
///   buttons: {
///     "ok": () => null,
///   },
/// );
///
/// // Show [myAlert] to the user.
/// myAlert.show();
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// ### Information Dialog Example
///
/// This example shows the creation of an alert that is used as a way of giving
/// the user information.
///
/// ```dart
/// /// The alert dialog that will be shown to the user.
/// Alert myAlert = Alert(
///   context: context,
///   title: "Did you know?",
///   content: Text("Flutter was initially released in May of 2017?"),
///   buttons: {
///     "Now I Know": () => null,
///   },
/// );
///
/// // Show [myAlert] to the user.
/// myAlert.show();
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// ### Confirmation Dialog Example
///
/// This example shows the creation of an alert that is used as a way of
/// confirming something with the user.
///
/// ```dart
/// /// The alert dialog that will be shown to the user.
/// Alert myAlert = Alert(
///   context: context,
///   title: "Are you sure?",
///   content: "Are you sure you want to leave this page? Any unsaved data "
///       "will be lost.",
///   buttons: {
///     "leave": () => leavePageAnyway(),
///     "cancel": () => null,
///   },
/// );
///
/// // Show [myAlert] to the user.
/// myAlert.show();
/// ```
/// {@end-tool}
class Alert extends StatelessWidget {
  /// Creates a pop-up that covers a lot of the screen with an opaque message
  /// box and fills the rest of the screen with a translucent overlay to disable
  /// touching the page in the background.
  ///
  /// **Note:** To display this pop-up, call `this` Alert's [show] method.
  ///
  /// This pop-up can be used to display messages to the user. These messages
  /// can be warnings, information, confirmation for certain actions, etc.
  ///
  /// **Note:** Any `content` that is not a widget will be displayed as a string
  /// withing a [Text] widget.
  Alert({
    Key? key,
    required this.context,
    this.title,
    dynamic content,
    this.buttons,
  })  : body = (content is Widget) ? content : Text(content.toString()),
        super(key: key);

  /// The current app build context.
  final BuildContext context;

  /// The title at the top of the alert dialog box.
  final String? title;

  /// The main content in the alert dialog box.
  final dynamic body;

  /// All of the action buttons at the bottom of the alert dialog box as well as
  /// what they do.
  final Map<String?, Function>? buttons;

  /// This method displays `this` alert to the screen.
  void show() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return this;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Display an alert that looks native to the device's platform.
    if (Platform.isIOS) {
      return _iosAlert();
    } else {
      return _androidAlert();
    }
  }

  /// This method displays an alert using a layout that looks more native to
  /// Android devices.
  _androidAlert() {
    /// The list of buttons that will be displayed at the bottom of the dialog
    /// box.
    List<Widget> builtButtons = [];

    // If there are meant to be buttons, build them.
    if (buttons != null) {
      buttons!.forEach(
        (name, action) {
          builtButtons.add(
            TextButton(
              onPressed: () {
                // Close the dialog box once a button is pressed.
                _closeAlert();

                // Preform the action associated with that button.
                action();
              },
              child: Text(name!),
            ),
          );
        },
      );
    }

    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: body,
      actions: builtButtons.isEmpty ? [] : builtButtons,
    );
  }

  /// This method displays an alert using a layout that looks more native to iOS
  /// devices.
  _iosAlert() {
    /// The list of buttons that will be displayed at the bottom of the dialog
    /// box.
    List<Widget> builtButtons = [];

    // If there are meant to be buttons, build them.
    if (buttons != null) {
      buttons!.forEach(
        (name, action) {
          builtButtons.add(
            CupertinoDialogAction(
              onPressed: () {
                // Close the dialog box once a button is pressed.
                _closeAlert();

                // Preform the action associated with that button.
                action();
              },
              child: Text(name!),
            ),
          );
        },
      );
    }

    return CupertinoAlertDialog(
      title: title != null ? Text(title!) : null,
      content: body,
      actions: builtButtons.isEmpty ? [] : builtButtons,
    );
  }

  /// This method closes the alert dialog box.
  _closeAlert() {
    Navigator.pop(context);
  }
}
