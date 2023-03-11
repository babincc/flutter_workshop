import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/strings/strings.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/utils/my_validator.dart';
import 'package:my_skeleton/widgets/views/my_text_field.dart';

/// This is used to control all of the logic on the forgot password popup.
class LoginForgotPasswordPopupViewModel {
  /// Creates a view model for the forgot password popup's UI.
  LoginForgotPasswordPopupViewModel(this.strings)
      : emailFieldKey = GlobalKey(),
        emailController = TextEditingController();

  /// The strings used throughout the app.
  final Strings strings;

  /// The key for the email text field.
  final GlobalKey<MyTextFieldState> emailFieldKey;

  /// The text editing controller for the email text field.
  final TextEditingController emailController;

  /// The tests that are run to see if the user's email input is valid.
  List<MyTextFieldValidator> get emailValidators => [
        MyTextFieldValidator(
          test: (value) => MyValidator.isValidEmail(value),
          expected: true,
          errorText: strings.invalidEmail,
        ),
      ];

  /// Called when the user clicks the reset button.
  ///
  /// Gets Firebase to send a password reset link to the email that the user
  /// has provided.
  ///
  /// If the email does not exist in Firebase, an error message is shown.
  ///
  /// Returns `0` if the form is not formatted correctly. This lets the program
  /// know that it needs to keep the form visible so the user can fix their
  /// errors.
  ///
  /// Returns `-1` if there is an unforeseen error. In this case, the program
  /// should display a message to the user, telling them something when wrong.
  ///
  /// Returns `1` if everything finishes successfully.
  Future<int> onReset(MyAuthProvider myAuthProvider) async {
    /// The text the user typed in the email field.
    String email = emailController.text.trim();

    // Only continue if the user's input is formatted correctly.
    if (await hasInputError(displayErrorMsg: true)) return 0;

    await myAuthProvider.forgotPassword(email).then(
      (value) {
        if (value != null) {
          return -1;
        }
      },
    );

    return 1;
  }

  /// This method checks to see if there are any formatting errors in the user's
  /// input in the sign up form.
  ///
  /// If `displayErrorMsg` is true, then the error messages assigned to the
  /// text field controllers will be displayed to the user.
  ///
  /// Returns `true` if there are any errors.
  Future<bool> hasInputError({bool displayErrorMsg = false}) async {
    // Check the email.
    bool emailHasError = false;
    if (emailController.text.isEmpty) {
      emailHasError = true;

      if (displayErrorMsg) {
        MyTextFieldState.setErrorText(
          key: emailFieldKey,
          errorText: strings.required,
        );
      }
    } else {
      if (emailFieldKey.currentState != null) {
        emailHasError = await emailFieldKey.currentState!.hasErrors(
          displayErrorMsg: displayErrorMsg,
        );
      }

      // If it is a validly formatted email, see if it exists in Firebase.
      if (!emailHasError &&
          (await FirebaseAuth.instance
                  .fetchSignInMethodsForEmail(emailController.text.trim()))
              .isEmpty) {
        if (displayErrorMsg) {
          MyTextFieldState.setErrorText(
            key: emailFieldKey,
            errorText: strings.emailDoesNotExist,
          );
        }
      }
    }

    return emailHasError;
  }
}
