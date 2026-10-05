import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/navigation/my_routes.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/utils/my_validator.dart';
import 'package:my_skeleton/widgets/views/my_alert/my_alert.dart';
import 'package:my_skeleton/widgets/views/my_text_field.dart';

/// This is used to control all of the logic on the login screen.
class LoginScreenViewModel {
  /// Creates a view model for the login screen's UI.
  LoginScreenViewModel({required this.authProvider})
    : emailKey = GlobalKey(),
      emailController = TextEditingController() {
    emailController.text = authProvider.lastEmailSentAddress ?? '';
  }

  final MyAuthProvider authProvider;

  /// The key for the email text field.
  final GlobalKey<MyTextFieldState> emailKey;

  /// The text editing controller for the email text field.
  final TextEditingController emailController;

  /// The tests that are run to see if the user's email input is valid.
  List<MyTextFieldValidator> get emailValidators => [
    const MyTextFieldValidator.testEmpty(testTrigger: TestTrigger.never),
    MyTextFieldValidator(
      test: (value) => MyValidator.isValidEmail(value),
      expected: true,
      errorText: 'Invalid email',
    ),
  ];

  /// Called when the user clicks the Log In button.
  ///
  /// Verifies the user's credentials are properly formatted and if they are, it
  /// sends them to Supabase to be verified. Upon receiving successful Supabase
  /// authentication, this method sends the user to their dashboard.
  ///
  /// Will return a [MyAlert] object if there is an error when giving Supabase
  /// the sign up credentials. Invalid user and invalid password are not
  /// included as exceptions here. This is for unforeseen errors.
  Future<MyAlert?> onLogIn({required GoRouter router}) async {
    /// The text the user typed in the email field.
    String email = emailController.text.trim();

    // Only continue if the user's input is formatted correctly.
    if (await hasInputError(displayErrorMsg: true)) return null;

    MyAlert? alert;

    await authProvider.sendOtp(email).then((value) {
      if (value == null) {
        router.pushNamed(MyRoutes.otpPage);
      } else {
        alert = handleLoginFail(value);
      }
    });

    return alert;
  }

  /// This method is called after the user's credentials are sent to Supabase
  /// and Supabase sends back an exception.
  ///
  /// `error` is the error message that was sent by Supabase.
  MyAlert? handleLoginFail(String error) {
    if (error.contains('email_not_confirmed')) {
      MyTextField.setErrorText(
        key: emailKey,
        errorText: 'Email address not verified',
      );
    } else if (error.contains('over_email_send_rate_limit')) {
      return MyAlert(
        title: 'Please Wait',
        content: 'You must wait before sending another passcode.',
        buttons: {'Okay': () {}},
      );
    } else {
      return MyAlert(
        title: 'Error',
        content: 'Something went wrong! Please try again later.',
        buttons: {'Okay': () {}},
      );
    }

    return null;
  }

  /// This method checks to see if there are any formatting errors in the user's
  /// input in the sign up form.
  ///
  /// If `displayErrorMsg` is true, then the error messages assigned to the
  /// text field controllers will be displayed to the user.
  ///
  /// Returns `true` if there are any errors.
  Future<bool> hasInputError({bool displayErrorMsg = false}) async {
    bool emailHasErrors = false;
    if (emailKey.currentState != null && emailKey.currentState!.mounted) {
      emailHasErrors = await emailKey.currentState!.hasErrors(
        displayErrorMsg: displayErrorMsg,
      );
    }

    return emailHasErrors;
  }
}
