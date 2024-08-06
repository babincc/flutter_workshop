import 'package:flutter/material.dart';
import 'package:my_skeleton/utils/my_validator.dart';
import 'package:my_skeleton/widgets/views/my_text_field.dart';

class FormExampleScreenViewModel {
  // =========================== FORM ELEMENTS =================================

  // ----------------------------- FORM KEYS -----------------------------------

  final GlobalKey<MyTextFieldState> colorKey = GlobalKey();
  final GlobalKey<MyTextFieldState> shapeKey = GlobalKey();
  final GlobalKey<MyTextFieldState> luckyNumberKey = GlobalKey();
  final GlobalKey<MyTextFieldState> emailKey = GlobalKey();

  // ------------------------- FORM CONTROLLERS --------------------------------

  final TextEditingController colorController = TextEditingController();
  final TextEditingController shapeController = TextEditingController();
  final TextEditingController luckyNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // -------------------------- FORM VALIDATORS --------------------------------

  final List<MyTextFieldValidator> colorValidators = [
    const MyTextFieldValidator.testEmpty(testTrigger: TestTrigger.never),
  ];
  final List<MyTextFieldValidator> shapeValidators = [
    const MyTextFieldValidator.testEmpty(testTrigger: TestTrigger.never),
  ];
  final List<MyTextFieldValidator> luckyNumberValidators = [
    const MyTextFieldValidator.testEmpty(testTrigger: TestTrigger.never),
    MyTextFieldValidator(
      test: (value) => double.tryParse(value) != null,
      expected: true,
      errorText: 'Must be a number',
    ),
  ];
  final List<MyTextFieldValidator> emailValidators = [
    const MyTextFieldValidator.testEmpty(testTrigger: TestTrigger.never),
    MyTextFieldValidator(
      test: (value) => value.isEmpty || MyValidator.isValidEmail(value),
      expected: true,
      errorText: 'Invalid email',
    ),
  ];

  // --------------------------- FORM GETTERS ----------------------------------

  /// The color text.
  String get color => colorController.text.trim();

  /// The shape text.
  String get shape => shapeController.text.trim();

  /// The lucky number text.
  num get luckyNumber => num.tryParse(luckyNumberController.text.trim()) ?? -1;

  /// The email text.
  String get email => emailController.text.trim();

  // ======================== END FORM ELEMENTS ================================

  /// Clears the form and all error messages.
  void clearForm() {
    // Clear all text fields.
    colorController.clear();
    shapeController.clear();
    luckyNumberController.clear();
    emailController.clear();

    // Clear all error messages.
    MyTextField.setErrorText(key: colorKey, errorText: null);
    MyTextField.setErrorText(key: shapeKey, errorText: null);
    MyTextField.setErrorText(key: luckyNumberKey, errorText: null);
    MyTextField.setErrorText(key: emailKey, errorText: null);
  }

  /// Called when the user hits the submit button.
  ///
  /// This method will validate the form, and if there are no errors, it will
  /// submit the form. If there are errors, they will be displayed, and the form
  /// will not be submitted.
  ///
  /// Returns `true` if the form was submitted successfully; otherwise, `false`.
  Future<bool> onSubmit() async {
    if (await hasErrors()) return false;

    // DO SOMETHING

    return true;
  }

  /// Whether or not the form has errors.
  ///
  /// If `displayErrorMsg` is `true`, then error messages will be displayed, if
  /// there are any.
  Future<bool> hasErrors([bool displayErrorMsg = true]) async {
    bool colorHasErrors = false;
    if (colorKey.currentState != null && colorKey.currentState!.mounted) {
      colorHasErrors = await colorKey.currentState!
          .hasErrors(displayErrorMsg: displayErrorMsg);
    }

    bool shapeHasErrors = false;
    if (shapeKey.currentState != null && shapeKey.currentState!.mounted) {
      shapeHasErrors = await shapeKey.currentState!
          .hasErrors(displayErrorMsg: displayErrorMsg);
    }

    bool luckyNumberHasErrors = false;
    if (luckyNumberKey.currentState != null &&
        luckyNumberKey.currentState!.mounted) {
      luckyNumberHasErrors = await luckyNumberKey.currentState!
          .hasErrors(displayErrorMsg: displayErrorMsg);
    }

    bool emailHasErrors = false;
    if (emailKey.currentState != null && emailKey.currentState!.mounted) {
      emailHasErrors = await emailKey.currentState!
          .hasErrors(displayErrorMsg: displayErrorMsg);
    }

    return colorHasErrors ||
        shapeHasErrors ||
        luckyNumberHasErrors ||
        emailHasErrors;
  }
}
