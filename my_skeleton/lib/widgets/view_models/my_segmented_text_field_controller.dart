import 'dart:math';

import 'package:flutter/material.dart';

class MySegmentedTextFieldController {
  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = [];

  void init(int numFields) {
    if (numFields <= 0) return;

    clear();
    dispose();

    controllers
      ..clear()
      ..addAll(List.generate(numFields, (_) => TextEditingController()));

    focusNodes
      ..clear()
      ..addAll(List.generate(numFields, (_) => FocusNode()));

    focusNodes.first.requestFocus();
  }

  /// This is the value of each text field put together.
  ///
  /// If any fields are skipped, they are ignored here.
  ///
  /// ```dart
  /// /// EXAMPLES
  ///
  /// // This represents an empty form.
  /// // [ ][ ][ ][ ][ ]
  /// text = ''
  ///
  /// // This represents a completely filled form.
  /// // [9][0][2][1][0]
  /// text = '90210'
  ///
  /// // These two are partially filled forms.
  /// // [8][1][1][ ][ ]
  /// // [ ][6][ ][7][ ]
  /// text = '811'
  /// text = '67'
  /// ```
  String get text => controllers.map((c) => c.text.trim()).join();

  set text(String value) {
    final truncated = value.substring(0, min(value.length, controllers.length));

    for (int i = 0; i < controllers.length; i++) {
      controllers[i].text = i < truncated.length ? truncated[i] : '';
    }
  }

  /// Whether or not the form is completely filled.
  bool get isFilled =>
      controllers.isNotEmpty &&
      controllers.every((controller) => controller.text.trim().length == 1);

  /// Sets the value of the text in the form field at `index` to the given
  /// `value`.
  ///
  /// Throws `Exception` if `index` is out of bounds.
  void setTextAt(int index, String value) {
    final String char = value.isEmpty ? '' : value[0];

    if (index < 0 || index >= controllers.length) {
      throw Exception(
        '$index is out of bounds for range 0-${controllers.length - 1}!',
      );
    }

    controllers[index].text = char;
  }

  /// Empties all of the form fields.
  void clear() => text = '';

  /// Sets the focus to the form field at the given `index`.
  ///
  /// Throws `Exception` if `index` is out of bounds.
  void setFocus(int index) {
    if (index < 0 || index >= controllers.length) {
      throw Exception(
        '$index is out of bounds for range 0-${controllers.length - 1}!',
      );
    }

    focusNodes[index].requestFocus();
  }

  /// Handles the change of focus between form fields.
  ///
  /// Throws `Exception` if `index` is out of bounds.
  void handleFocusChange(int index) {
    if (index < 0 || index >= controllers.length) {
      throw Exception(
        '$index is out of bounds for range 0-${controllers.length - 1}!',
      );
    }

    if (focusNodes[index].hasFocus) {
      controllers[index].selection = TextSelection(
        baseOffset: 0,
        extentOffset: controllers[index].text.length,
      );
    }
  }

  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }
    controllers.clear();
    focusNodes.clear();
  }
}
