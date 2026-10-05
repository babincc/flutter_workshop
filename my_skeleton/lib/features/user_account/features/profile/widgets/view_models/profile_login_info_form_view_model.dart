import 'package:flutter/material.dart';
import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/utils/my_validator.dart';
import 'package:my_skeleton/widgets/views/my_alert/my_alert.dart';
import 'package:my_skeleton/widgets/views/my_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileLoginInfoFormViewModel {
  ProfileLoginInfoFormViewModel({
    required this.user,
    required this.supabaseUser,
  }) {
    _init();
  }

  final MyUser user;

  /// The Supabase auth user object.
  final User? supabaseUser;

  /// The Supabase auth email.
  String get supabaseUserEmail => supabaseUser?.email ?? '';

  /// The email the user was using before the changed it.
  String? oldEmail;

  /// Whether or not the user changed their email in the form.
  bool get didChangeEmail => oldEmail != null && oldEmail != email;

  /// The popup that makes the user verify their password.
  MyAlert? authAlert;

  bool readOnly = true;

  /// Whether or not the user correctly verified their password.
  bool didVerify = false;

  void _init() {
    emailController.text = supabaseUserEmail;
  }

  // =========================== FORM ELEMENTS =================================

  // ----------------------------- FORM KEYS -----------------------------------

  final GlobalKey<MyTextFieldState> emailKey = GlobalKey();

  // ------------------------- FORM CONTROLLERS --------------------------------

  final TextEditingController emailController = TextEditingController();

  // -------------------------- FORM VALIDATORS --------------------------------

  final List<MyTextFieldValidator> emailValidators = [
    const MyTextFieldValidator.testEmpty(testTrigger: TestTrigger.never),
    MyTextFieldValidator(
      test: (value) => MyValidator.isValidEmail(value),
      expected: true,
      errorText: 'Invalid email',
    ),
  ];

  // --------------------------- FORM GETTERS ----------------------------------

  /// The email text.
  String get email => emailController.text.trim();

  // ======================== END FORM ELEMENTS ================================

  /// Whether or not the user has input any data into the form.
  bool get hasData {
    final bool hasEmailData = email != supabaseUserEmail;

    return hasEmailData;
  }

  /// Clears the form and all error messages.
  void clearForm() {
    // Clear all text fields.
    emailController.clear();

    // Clear all error messages.
    MyTextField.setErrorText(key: emailKey, errorText: null);

    _init();
  }

  /// Called when the user hits the submit button for the form.
  ///
  /// This method will validate the form, and if there are no errors, it will
  /// submit the form. If there are errors, they will be displayed, and the form
  /// will not be submitted.
  ///
  /// Returns `true` if the data was submitted to the database successfully. If
  /// there is a failure to properly add this data to the database, `false` is
  /// returned instead.
  Future<bool?> onSubmit(MyAuthProvider myAuthProvider) async {
    if (await hasErrors()) return null;

    if (email != supabaseUserEmail) {
      oldEmail = supabaseUserEmail;
    }

    final bool wasSuccessful = await myAuthProvider.changeCredentials(
      email: email.isEmpty ? null : email,
    );

    if (!wasSuccessful) {
      oldEmail = null;
    }

    return wasSuccessful;
  }

  /// Whether or not the form has errors.
  ///
  /// If `displayErrorMsg` is `true`, then error messages will be displayed, if
  /// there are any.
  Future<bool> hasErrors([bool displayErrorMsg = true]) async {
    bool emailHasErrors = false;
    if (emailKey.currentState != null && emailKey.currentState!.mounted) {
      emailHasErrors = await emailKey.currentState!.hasErrors(
        displayErrorMsg: displayErrorMsg,
      );
    }

    return emailHasErrors;
  }

  /// Properly dispose this view model.
  void dispose() {
    emailController.dispose();
  }
}
