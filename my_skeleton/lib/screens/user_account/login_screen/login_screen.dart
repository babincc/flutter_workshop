import 'package:flutter/material.dart';
import 'package:my_skeleton/my_theme/my_colors.dart';
import 'package:my_skeleton/my_theme/my_spacing.dart';
import 'package:my_skeleton/my_theme/my_theme.dart';
import 'package:my_skeleton/screens/components/my_clickable_text.dart';
import 'package:my_skeleton/screens/components/my_safe_area.dart';
import 'package:my_skeleton/screens/components/my_text_field.dart';
import 'package:my_skeleton/screens/user_account/login_screen/login_screen_bloc.dart';
import 'package:my_skeleton/utils/database/auth_provider.dart';
import 'package:my_skeleton/utils/my_validator.dart';

/// The screen the user is sent to when they are not connected to Firebase.
class LoginScreen extends StatelessWidget {
  /// Creates a screen that gives the user different choices to get connected to
  /// Firebase.
  LoginScreen({Key? key})
      : myBloc = LoginScreenBloc(),
        emailController = TextEditingController(),
        passwordController = TextEditingController(),
        super(key: key);

  /// All of the business logic for this page.
  final LoginScreenBloc myBloc;

  /// The text editing controller for the email text field.
  final TextEditingController emailController;

  /// The text editing controller for the password text field.
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MySafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ///  LOGO image
              Padding(
                padding: const EdgeInsets.only(
                  bottom: MySpacing.elementSpread,
                ),
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 100,
                ),
              ),

              /// EMAIL text field
              Padding(
                padding: const EdgeInsets.only(
                  bottom: MySpacing.elementSpread,
                ),
                child: MyTextField(
                  controller: emailController,
                  decoration: MyTheme.myInputDecoration(
                    context,
                    emailController,
                    hint: "email",
                    prefixIcon: const Icon(
                      Icons.email,
                      color: MyColors.primary,
                    ),
                  ),
                ),
              ),

              /// PASSWORD text field
              Padding(
                padding: const EdgeInsets.only(
                  bottom: MySpacing.elementSpread,
                ),
                child: MyTextField(
                  controller: passwordController,
                  decoration: MyTheme.myInputDecoration(
                    context,
                    passwordController,
                    hint: "password",
                    prefixIcon: const Icon(
                      Icons.password,
                      color: MyColors.primary,
                    ),
                  ),
                  isPassword: true,
                ),
              ),

              /// LOG IN button
              Padding(
                padding: const EdgeInsets.only(
                  bottom: MySpacing.elementSpread,
                ),
                child: TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    onLogIn(context);
                  },
                  child: Text(
                    "Log In",
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: MyColors.background,
                        ),
                  ),
                  style: MyTheme.myButtonStyle(),
                ),
              ),

              /// FORGOT PASSWORD button
              Padding(
                padding: const EdgeInsets.only(
                  bottom: MySpacing.elementSpread,
                ),
                child: MyClickableText(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    onForgotPass(context);
                  },
                  text: "forgot password",
                ),
              ),

              /// CREATE ACCOUNT button
              MyClickableText(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  onSignUp(context);
                },
                text: "create account",
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Called when the user clicks the Log In button.
  ///
  /// Verifies the user's credentials are properly formatted and if they are, it
  /// sends them to Firebase to be verified. Upon receiving successful Firebase
  /// authentication, this method sends the user to their dashboard.
  Future<void> onLogIn(BuildContext context) async {
    /// The text the user typed in the email field.
    String email = emailController.text.trim();

    /// The text the user typed in the password field.
    String password = emailController.text.trim();

    // Only continue if the user's input is formatted correctly.
    if (!hasInputErrors()) {
      String? completionStr = await AuthProvider.of(context).logIn(
        email: email,
        password: password,
      );

      if (completionStr == null) {
        if (!AuthProvider.of(context).isLoggedIn) {
          // Login failed with no error message
          onLoginFail();
        }
      } else {
        if (completionStr == "user-not-found") {
          onLoginFail(invalidEmail: true);
        } else if (completionStr == "wrong-password") {
          onLoginFail(invalidPassword: true);
        } else {
          onLoginFail();
        }
      }
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
    // TODO
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
