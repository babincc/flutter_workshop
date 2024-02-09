import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/constants/strings/strings.dart';
import 'package:my_skeleton/navigation/my_routes.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/utils/my_tools.dart';
import 'package:my_skeleton/utils/my_validator.dart';
import 'package:my_skeleton/widgets/views/my_alert.dart';
import 'package:my_skeleton/widgets/views/my_text_field.dart';

/// This is used to control all of the logic on the account creation screen.
class CreateAccountScreenViewModel extends ChangeNotifier {
  /// Creates a view model for the account creation screen's UI.
  CreateAccountScreenViewModel(this.strings)
      : emailFieldKey = GlobalKey(),
        passwordFieldKey = GlobalKey(),
        confirmPasswordFieldKey = GlobalKey(),
        emailController = TextEditingController(),
        passwordController = TextEditingController(),
        confirmPasswordController = TextEditingController();

  /// The strings used throughout the app.
  final Strings strings;

  /// The key for the email text field.
  final GlobalKey<MyTextFieldState> emailFieldKey;

  /// The key for the password text field.
  final GlobalKey<MyTextFieldState> passwordFieldKey;

  /// The key for the confirm password text field.
  final GlobalKey<MyTextFieldState> confirmPasswordFieldKey;

  /// The text editing controller for the email text field.
  final TextEditingController emailController;

  /// The text editing controller for the password text field.
  final TextEditingController passwordController;

  /// The text editing controller for the confirm password text field.
  final TextEditingController confirmPasswordController;

  /// The tests that are run to see if the user's email input is valid.
  List<MyTextFieldValidator> get emailValidators => [
        const MyTextFieldValidator.testEmpty(testTrigger: TestTrigger.never),
        MyTextFieldValidator(
          test: (value) => MyValidator.isValidEmail(value),
          expected: true,
          errorText: strings.invalidEmail,
        ),
      ];

  /// The tests that are run to see if the user's password input is valid.
  List<MyTextFieldValidator> get passwordValidators => [
        const MyTextFieldValidator.testEmpty(testTrigger: TestTrigger.never),
        MyTextFieldValidator(
          test: (value) => MyValidator.isValidPassword(value),
          expected: true,
          errorText: strings.passwordTooWeak,
        ),
      ];

  /// The tests that are run to see if the user's confirm input is valid.
  List<MyTextFieldValidator> get confirmPasswordValidators => [
        const MyTextFieldValidator.testEmpty(testTrigger: TestTrigger.never),
        MyTextFieldValidator(
          test: (value) => value == passwordController.text.trim(),
          expected: true,
          errorText: strings.passwordsDontMatch,
        ),
      ];

  /// Called when the user clicks the sign up button.
  ///
  /// Verifies the user's credentials are properly formatted and if they are, it
  /// sends them to Firebase for an account to be created.
  ///
  /// Will return a [MyAlert] object if there is an error when giving Firebase
  /// the sign up credentials.
  Future<MyAlert?> onSignUp({
    required MyAuthProvider myAuthProvider,
    required GoRouter router,
  }) async {
    MyAlert? toReturn;

    /// The text the user typed in the email field.
    String email = emailController.text.trim();

    /// The text the user typed in the password field.
    String password = passwordController.text.trim();

    // Only continue if the user's input is formatted correctly.
    if (await hasInputError(displayErrorMsg: true)) return null;

    await myAuthProvider.signUp(email: email, password: password).then((value) {
      if (value == null) {
        router.goNamed(MyRoutes.dashboardScreen);
        return;
      }

      if (value.contains('email') &&
          value.contains('in') &&
          value.contains('use')) {
        if (emailFieldKey.currentState != null) {
          MyTextFieldState.setErrorText(
            key: emailFieldKey,
            errorText: strings.emailAlreadyExists,
          );
          return;
        }
      }

      toReturn = MyAlert(
        title: MyTools.capitalizeFirstLetter(strings.error),
        content:
            "${MyTools.capitalizeFirstLetter(strings.failedAccountCreation)}! "
            "${MyTools.capitalizeFirstLetter(strings.tryAgainLater)}.",
        buttons: {strings.ok: () {}},
      );
    });

    return toReturn;
  }

  /// Takes the user to the login page.
  void goToLogin(GoRouter router) {
    router.goNamed(MyRoutes.loginScreen);
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
    if (emailFieldKey.currentState != null) {
      emailHasError = await emailFieldKey.currentState!.hasErrors(
        displayErrorMsg: displayErrorMsg,
      );
    }

    // Check the password.
    bool passwordHasError = false;
    if (passwordFieldKey.currentState != null) {
      passwordHasError = await passwordFieldKey.currentState!.hasErrors(
        displayErrorMsg: displayErrorMsg,
      );
    }

    // Check confirm password.
    bool confirmPasswordHasError = false;
    if (confirmPasswordFieldKey.currentState != null) {
      confirmPasswordHasError =
          await confirmPasswordFieldKey.currentState!.hasErrors(
        displayErrorMsg: displayErrorMsg,
      );
    }

    return emailHasError || passwordHasError || confirmPasswordHasError;
  }
}
