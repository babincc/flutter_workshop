import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/strings/strings.dart';
import 'package:my_skeleton/constants/theme/my_spacing.dart';
import 'package:my_skeleton/features/user_account/features/login/screens/view_models/login_forgot_password_popup_view_model.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_string_provider.dart';
import 'package:my_skeleton/utils/my_tools.dart';
import 'package:my_skeleton/widgets/my_alert.dart';
import 'package:my_skeleton/widgets/my_text_field.dart';

class LoginForgotPasswordPopup extends StatefulWidget {
  const LoginForgotPasswordPopup({super.key});

  @override
  State<LoginForgotPasswordPopup> createState() =>
      _LoginForgotPasswordPopupState();
}

class _LoginForgotPasswordPopupState extends State<LoginForgotPasswordPopup> {
  _LoginForgotPasswordPopupState() : linkSent = false;

  /// Whether or not the email reset link has been sent to the user.
  bool linkSent;

  @override
  Widget build(BuildContext context) {
    /// All of the strings on this page.
    final Strings strings = MyStringProvider.of(
      context,
      listen: true,
    ).strings;

    final LoginForgotPasswordPopupViewModel viewModel =
        LoginForgotPasswordPopupViewModel(strings);

    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          MySpacing.distanceFromEdge,
          MySpacing.elementSpread,
          MySpacing.distanceFromEdge,
          MySpacing.distanceFromEdge,
        ),
        child: Column(
          children: [
            // RESIZE BAR
            Container(
              height: 5.0,
              width: 60.0,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
                borderRadius: BorderRadius.circular(999.0),
              ),
            ),

            // TITLE
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: MySpacing.elementSpread,
              ),
              child: Text(MyTools.capitalizeEachWord(strings.forgotPassword)),
            ),

            _buildBody(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, LoginForgotPasswordPopupViewModel viewModel) {
    if (linkSent) {
      return _buildSuccess(context, viewModel);
    } else {
      return _buildForm(viewModel);
    }
  }

  Widget _buildForm(LoginForgotPasswordPopupViewModel viewModel) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // INSTRUCTIONS
          Padding(
            padding: const EdgeInsets.only(
              bottom: MySpacing.elementSpread,
            ),
            child: Text(
              "${MyTools.capitalizeFirstLetter(viewModel.strings.resetPasswordInstructions)}.",
            ),
          ),

          // EMAIL text field
          Padding(
            padding: const EdgeInsets.only(
              bottom: MySpacing.elementSpread,
            ),
            child: MyTextField(
              key: viewModel.emailFieldKey,
              controller: viewModel.emailController,
              isLastField: true,
              hint: viewModel.strings.email,
              prefixIcon: const Icon(
                Icons.email,
              ),
              validators: viewModel.emailValidators,
            ),
          ),

          // RESET button
          TextButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await viewModel
                  .onReset(MyAuthProvider.of(context))
                  .then((result) {
                if (result > 0) {
                  setState(() {
                    linkSent = true;
                  });
                } else if (result < 0) {
                  MyAlert(
                    title:
                        MyTools.capitalizeFirstLetter(viewModel.strings.error),
                    content:
                        "${MyTools.capitalizeFirstLetter(viewModel.strings.failedPasswordReset)}! "
                        "${MyTools.capitalizeFirstLetter(viewModel.strings.tryAgainLater)}.",
                    buttons: {viewModel.strings.ok: () {}},
                  ).show(context);
                }
              });
            },
            child: Text(MyTools.capitalizeEachWord(viewModel.strings.reset)),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(
      BuildContext context, LoginForgotPasswordPopupViewModel viewModel) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SUCCESS icon
          Padding(
            padding: const EdgeInsets.only(
              bottom: MySpacing.elementSpread,
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: Theme.of(context).primaryColor,
            ),
          ),

          // Success text
          Padding(
            padding: const EdgeInsets.only(
              bottom: MySpacing.elementSpread,
            ),
            child: Text(
              "${MyTools.capitalizeFirstLetter(viewModel.strings.passwordResetLinkSent)}!",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
