import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/navigation/my_routes.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/utils/my_validator.dart';

/// This is used to control all of the logic on the login screen.
class LoginScreenViewModel extends ChangeNotifier {
  /// Creates a controller for the login screen's UI.
  LoginScreenViewModel()
      : emailController = TextEditingController(),
        passwordController = TextEditingController();

  /// The text editing controller for the email text field.
  final TextEditingController emailController;

  /// The text editing controller for the password text field.
  final TextEditingController passwordController;

  /// Called when the user clicks the Log In button.
  ///
  /// Verifies the user's credentials are properly formatted and if they are, it
  /// sends them to Firebase to be verified. Upon receiving successful Firebase
  /// authentication, this method sends the user to their dashboard.
  Future<void> onLogIn(BuildContext context) async {
    /// The text the user typed in the email field.
    String email = emailController.text.trim();

    /// The text the user typed in the password field.
    String password = passwordController.text.trim();

    // Only continue if the user's input is formatted correctly.
    if (!hasInputErrors()) {
      MyAuthProvider.of(context)
          .logIn(
        email: email,
        password: password,
      )
          .then((value) {
        if (value == null) {
          context.goNamed(MyRoutes.dashboardScreen);
        } else {
          // TODO
          onLoginFail();
        }
      });
    } else {
      onLoginFail(
        invalidEmail: true,
        invalidPassword: true,
      );
    }
  }

  /// Called when the user clicks the Forgot Password button.
  ///
  /// Sends the user to a page that allows them to reset their password.
  void onForgotPass(BuildContext context) {
    // TODO
  }

  /// Called when the user clicks the Create Account button.
  ///
  /// Sends the user to the sign up page where they can fill in their
  /// information, verify it is real, and be given a new Firebase account.
  void onSignUp(BuildContext context) {
    // TODO
  }

  /// This method is called after the user's credentials are sent to Firebase
  /// and Firebase sends back an exception.
  ///
  /// If it is an unregistered email, then `invalidEmail` needs to be set to
  /// `true`.
  ///
  /// If it is not the right password for the user, then `invalidPassword` needs
  /// to be set to `true`.
  onLoginFail({
    bool invalidEmail = false,
    bool invalidPassword = false,
  }) {
    // TODO;
  }

  /// This method checks to see if there are any formatting errors in the user's
  /// input in the login form.
  ///
  /// If there are errors, it will return `true`; otherwise, it will return
  /// `false`.
  bool hasInputErrors() {
    /// The text the user typed in the email field.
    String email = emailController.text.trim();

    /// The text the user typed in the password field.
    String password = emailController.text.trim();

    // If either field is empty, there are errors.
    if (email.isEmpty || password.isEmpty) {
      return true;
    }

    // Return `false` if it is a valid email.
    return !MyValidator.isValidEmail(email);
  }
}
