import 'package:my_skeleton/constants/strings/strings.dart';
import 'package:my_skeleton/navigation/my_routes.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/utils/my_validator.dart';
import 'package:my_skeleton/widgets/views/my_alert.dart';
import 'package:my_skeleton/widgets/views/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// This is used to control all of the logic on the login screen.
class LoginScreenViewModel {
  /// Creates a view model for the login screen's UI.
  LoginScreenViewModel(this.strings)
      : emailFieldKey = GlobalKey(),
        passwordFieldKey = GlobalKey(),
        emailController = TextEditingController(),
        passwordController = TextEditingController();

  /// The strings used throughout the app.
  final Strings strings;

  /// The key for the email text field.
  final GlobalKey<MyTextFieldState> emailFieldKey;

  /// The key for the password text field.
  final GlobalKey<MyTextFieldState> passwordFieldKey;

  /// The text editing controller for the email text field.
  final TextEditingController emailController;

  /// The text editing controller for the password text field.
  final TextEditingController passwordController;

  /// The tests that are run to see if the user's email input is valid.
  List<MyTextFieldValidator> get emailValidators => [
        const MyTextFieldValidator.testEmpty(testTrigger: TestTrigger.never),
        MyTextFieldValidator(
          test: (value) => MyValidator.isValidEmail(value),
          expected: true,
          errorText: strings.invalidEmail,
        ),
      ];

  /// Called when the user clicks the Log In button.
  ///
  /// Verifies the user's credentials are properly formatted and if they are, it
  /// sends them to Firebase to be verified. Upon receiving successful Firebase
  /// authentication, this method sends the user to their dashboard.
  ///
  /// Will return a [MyAlert] object if there is an error when giving Firebase
  /// the sign up credentials. Invalid user and invalid password are not
  /// included as exceptions here. This is for unforeseen errors.
  Future<MyAlert?> onLogIn({
    required MyAuthProvider myAuthProvider,
    required GoRouter router,
  }) async {
    /// The text the user typed in the email field.
    String email = emailController.text.trim();

    /// The text the user typed in the password field.
    String password = passwordController.text.trim();

    // Only continue if the user's input is formatted correctly.
    if (await hasInputError(displayErrorMsg: true)) return null;

    await myAuthProvider.logIn(email: email, password: password).then(
      (value) {
        if (value == null) {
          router.goNamed(MyRoutes.dashboardScreen);
        } else {
          return handleLoginFail(value);
        }
      },
    );

    return null;
  }

  /// Called when the user clicks the Create Account button.
  ///
  /// Sends the user to the sign up page where they can fill in their
  /// information, verify it is real, and be given a new Firebase account.
  void onSignUp(GoRouter router) {
    router.goNamed(MyRoutes.createAccountScreen);
  }

  /// This method is called after the user's credentials are sent to Firebase
  /// and Firebase sends back an exception.
  ///
  /// `error` is the error message that was sent by Firebase.
  MyAlert? handleLoginFail(String error) {
    if (error == 'user-not-found') {
      MyTextFieldState.setErrorText(
        key: emailFieldKey,
        errorText: strings.emailDoesNotExist,
      );
      MyTextFieldState.setErrorText(
        key: passwordFieldKey,
      );
    } else if (error == 'wrong-password') {
      MyTextFieldState.setErrorText(
        key: passwordFieldKey,
        errorText: strings.invalidPassword,
      );
    } else {
      return MyAlert(
        title: strings.error.capitalizeFirstLetter(),
        content: '${strings.somethingWentWrong.capitalizeFirstLetter()}! '
            '${strings.tryAgainLater.capitalizeFirstLetter()}.',
        buttons: {strings.ok: () {}},
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
    bool emailHasError = false;
    if (emailFieldKey.currentState != null) {
      emailHasError = await emailFieldKey.currentState!.hasErrors(
        displayErrorMsg: displayErrorMsg,
      );
    }

    bool passwordHasError = false;
    if (passwordController.text.isEmpty) {
      passwordHasError = true;

      if (displayErrorMsg) {
        MyTextFieldState.setErrorText(
          key: passwordFieldKey,
          errorText: strings.required,
        );
      }
    } else {
      MyTextFieldState.setErrorText(
        key: passwordFieldKey,
        errorText: null,
      );
    }

    return emailHasError || passwordHasError;
  }
}
