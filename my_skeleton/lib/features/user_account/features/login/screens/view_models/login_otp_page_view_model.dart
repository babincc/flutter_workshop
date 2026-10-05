import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/navigation/my_routes.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/widgets/view_models/my_segmented_text_field_controller.dart';
import 'package:my_skeleton/widgets/views/my_alert/my_alert.dart';
import 'package:my_skeleton/widgets/views/my_segmented_text_field.dart';

class LoginOtpPageViewModel {
  LoginOtpPageViewModel({required this.authProvider})
    : otpKey = GlobalKey(),
      otpController = MySegmentedTextFieldController();

  /// The key for the email text field.
  final GlobalKey<MySegmentedTextFieldState> otpKey;

  final MySegmentedTextFieldController otpController;

  final MyAuthProvider authProvider;

  /// Called when the user clicks the Log In button.
  ///
  /// Verifies the user's credentials are properly formatted and if they are, it
  /// sends them to Supabase to be verified. Upon receiving successful Supabase
  /// authentication, this method sends the user to their dashboard.
  ///
  /// Will return a [MyAlert] object if there is an error when giving Supabase
  /// the sign up credentials. Invalid user and invalid password are not
  /// included as exceptions here. This is for unforeseen errors.
  Future<MyAlert?> onLogIn({
    required MyAuthProvider myAuthProvider,
    required GoRouter router,
  }) async {
    if (authProvider.lastEmailSentAddress == null) {
      return handleLoginFail('no_email_found');
    }

    final String email = myAuthProvider.lastEmailSentAddress!;

    final String passcode = otpController.text.trim();

    // Only continue if the user's input is formatted correctly.
    if (!otpController.isFilled) {
      MySegmentedTextField.setErrorText(
        key: otpKey,
        errorText: 'All fields required',
      );
      return null;
    }

    MyAlert? alert;

    await myAuthProvider.logIn(email: email, otp: passcode).then((value) {
      if (value == null) {
        router.goNamed(MyRoutes.dashboardScreen);
        otpController.dispose();
      } else {
        alert = handleLoginFail(value);
      }
    });

    return alert;
  }

  /// Resends a new OTP to the user's email.
  ///
  /// Will return a [MyAlert] object if there is an error when giving Supabase
  /// the sign up credentials. Invalid user and invalid password are not
  /// included as exceptions here. This is for unforeseen errors.
  Future<MyAlert?> onResendOtp() async {
    if (authProvider.lastEmailSentAddress == null) {
      return handleLoginFail('no_email_found');
    }

    MyAlert? alert;

    await authProvider.sendOtp(authProvider.lastEmailSentAddress!).then((
      value,
    ) {
      if (value != null) {
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
    if (error.contains('otp_expired')) {
      MySegmentedTextField.setErrorText(
        key: otpKey,
        errorText: 'Passcode invalid or expired',
      );
    } else if (error.contains('over_email_send_rate_limit')) {
      return MyAlert(
        title: 'Please Wait',
        content: 'You must wait before sending another passcode.',
        buttons: {'Okay': () {}},
      );
    } else if (error.contains('no_email_found')) {
      return MyAlert(
        title: 'Error',
        content: 'No email found. Please go back and re-enter it to try again.',
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

  static const int _cooldownMinutes = 1;
  static int get _cooldownSec => (_cooldownMinutes * 60) + 3;

  /// How many more seconds before the user can resend their OTP.
  int get remainingCooldownSec =>
      _cooldownSec -
      DateTime.now().difference(authProvider.lastEmailSentTime).inSeconds;

  /// Whether or not the OTP cooldown has expired.
  bool get canResend =>
      !(remainingCooldownSec > _cooldownSec || remainingCooldownSec <= 0);
}
