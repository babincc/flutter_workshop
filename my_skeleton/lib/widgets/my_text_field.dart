import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';

/// A custom text field that only contains the parameters I need in this app.
///
/// It also has some bonus features added in.
class MyTextField extends StatefulWidget {
  const MyTextField({
    Key? key,
    this.controller,
    this.isPassword = false,
    this.label,
    this.hint,
    this.prefixIcon,
    this.validators,
    required this.isLastField,
  }) : super(key: key);

  final TextEditingController? controller;

  final bool isLastField;

  /// Tells the user what to input into this text field.
  ///
  /// Stays visible to the user, even when they have typed an input.
  final String? label;

  /// Tells the user what to input into this text field.
  ///
  /// Is replaced by the user's input text.
  final String? hint;

  /// Icon that goes on the left side of the text field.
  final Icon? prefixIcon;

  /// If `true` the user's input text will be obfuscated with "*" as it is
  /// typed.
  final bool isPassword;

  /// Tests that can be run on this text field's input as well as error messages
  /// if it fails.
  final List<MyTextFieldValidator>? validators;

  @override
  State<MyTextField> createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField> {
  /// The message that will be displayed with this text field to let the user
  /// know their input is invalid.
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller ?? TextEditingController(),
      decoration: MyThemeProvider.myInputDecoration(
        label: widget.label,
        hint: widget.hint,
        prefixIcon: widget.prefixIcon,
        errorText: errorText,
      ),
      obscureText: widget.isPassword,
      onChanged: (_) => hasErrors(testTrigger: TestTrigger.onChange),
      onEditingComplete: () {
        hasErrors(testTrigger: TestTrigger.onComplete);

        if (widget.isLastField) {
          FocusScope.of(context).unfocus();
        } else {
          FocusScope.of(context).nextFocus();
        }
      },
    );
  }

  /// This method allows the error text to be set manually from outside of this
  /// widget.
  static void setErrorText({
    required GlobalKey<MyTextFieldState> key,
    String? errorText,
  }) {
    if (key.currentState != null && key.currentState!.mounted) {
      key.currentState!.setState(() {
        key.currentState!.errorText = errorText;
      });
    }
  }

  /// Tests to see if the input to this text field has any errors based on the
  /// `validators` provided when this widget was created.
  ///
  /// Will display error messages by default, but that can be turned off by
  /// setting `displayErrorMsg` to `false`.
  ///
  /// By setting `testTrigger`, only the validators with a matching
  /// [TestTrigger] will run. Leaving this `null` will run all of the tests.
  ///
  /// Returns `true` if there are errors.
  Future<bool> hasErrors({
    bool displayErrorMsg = true,
    TestTrigger? testTrigger,
  }) async {
    // If there are no tests or no controller, there can be no errors.
    if (widget.validators == null || widget.controller == null) return false;

    bool hasErrors = false;
    String? errorMsg;

    /// Number of tests that have been run.
    int completedTests = 0;

    // Run each test and stop at the first fail.
    for (MyTextFieldValidator validator in widget.validators!) {
      if (testTrigger == null ||
          identical(validator.testTrigger, testTrigger)) {
        completedTests++;
        if (!(await validator.isValid(widget.controller!.text.trim()))) {
          hasErrors = true;
          errorMsg = validator.errorText;
          break;
        }
      }
    }

    // Display the error message if applicable.
    if (completedTests > 0 && displayErrorMsg && mounted) {
      if (!(errorText == null && errorMsg == null)) {
        if ((errorText == null || errorMsg == null) || errorText != errorMsg) {
          setState(() {
            errorText = errorMsg;
          });
        }
      }
    }

    return hasErrors;
  }
}

/// This allows the text field to hold a validation test for its input, as well
/// as an error message if the input fails the test.
///
/// Multiples of these can be used together with a text field to have many
/// different tests for input as well as different error messages.
class MyTextFieldValidator {
  /// Creates a validator that can be used with [MyTextField].
  ///
  /// The given `test` can be run on the input string of the [MyTextField]
  /// object this validator belongs to.
  ///
  /// The result of `test` will be compared against `expected` to see if the
  /// input passes or not.
  ///
  /// `testTrigger` tells the program when to run the `test`. It is set to run
  /// tests when the user is done in this text field.
  ///
  /// Note: If you do not want your error messages to display automatically, set
  /// `testTrigger` to `null`.
  const MyTextFieldValidator({
    this.key,
    required FutureOr<bool> Function(String) test,
    required this.expected,
    this.errorText,
    this.testTrigger = TestTrigger.onComplete,
  }) : _test = test;

  /// Pre-built validator to test if the text field input is empty.
  const MyTextFieldValidator.testEmpty({
    this.key,
    this.errorText = "required",
    this.testTrigger = TestTrigger.onComplete,
  })  : _test = _isEmpty,
        expected = false;

  /// A unique key to identify this text field validator.
  final Key? key;

  /// The test that is run on the input string to see if it is valid.
  final FutureOr<bool> Function(String) _test;

  /// The result you are hoping the test yields.
  ///
  /// If this matches the test result, then the input will be considered valid.
  final bool expected;

  /// The error text that will be displayed if the input string fails the test.
  final String? errorText;

  /// When should this test be run.
  final TestTrigger? testTrigger;

  /// Whether or not the input string passes the validation test.
  Future<bool> isValid(String text) async {
    bool actual = await _test(text);

    return actual == expected;
  }

  static bool _isEmpty(String text) => text.isEmpty;
}

/// Tells the program when it is supposed to run the validation tests.
enum TestTrigger {
  /// Run the validation tests every time the user makes a change to the input.
  onChange,

  /// Only run the validation tests when the user is done typing and leaves the
  /// text field.
  onComplete,

  /// Do not automatically run the validation tests.
  never,
}
