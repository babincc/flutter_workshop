import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/constants/strings/strings.dart';
import 'package:my_skeleton/constants/theme/my_spacing.dart';
import 'package:my_skeleton/features/user_account/features/login/screens/view_models/login_screen_view_model.dart';
import 'package:my_skeleton/features/user_account/features/login/widgets/login_forgot_password_popup.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_string_provider.dart';
import 'package:my_skeleton/utils/my_tools.dart';
import 'package:my_skeleton/widgets/my_clickable_text.dart';
import 'package:my_skeleton/widgets/my_scaffold.dart';
import 'package:my_skeleton/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

/// The screen the user is sent to when they are not connected to Firebase.
class LoginScreen extends StatelessWidget {
  /// Creates a screen that gives the user different choices to get connected to
  /// Firebase.
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// All of the strings on this page.
    final Strings strings = MyStringProvider.of(
      context,
      listen: true,
    ).strings;

    /// All of the logic that controls this page's UI.
    final LoginScreenViewModel viewModel =
        context.read<LoginScreenViewModel?>() ?? LoginScreenViewModel(strings);

    return MyScaffold(
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /// LOGO image
          Padding(
            padding: const EdgeInsets.only(
              bottom: MySpacing.elementSpread,
            ),
            child: Image.asset(
              "assets/images/logo.png",
              width: 175,
            ),
          ),

          /// EMAIL text field
          Padding(
            padding: const EdgeInsets.only(
              bottom: MySpacing.elementSpread,
            ),
            child: MyTextField(
              key: viewModel.emailFieldKey,
              controller: viewModel.emailController,
              isLastField: false,
              hint: strings.email,
              prefixIcon: const Icon(
                Icons.email,
              ),
              validators: viewModel.emailValidators,
            ),
          ),

          /// PASSWORD text field
          Padding(
            padding: const EdgeInsets.only(
              bottom: MySpacing.elementSpread,
            ),
            child: MyTextField(
              key: viewModel.passwordFieldKey,
              controller: viewModel.passwordController,
              isLastField: true,
              hint: strings.password,
              prefixIcon: const Icon(
                Icons.password,
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
              onPressed: () async {
                FocusScope.of(context).unfocus();
                await viewModel
                    .onLogIn(
                      myAuthProvider: MyAuthProvider.of(context),
                      router: GoRouter.of(context),
                    )
                    .then((myAlert) => myAlert?.show(context));
              },
              child: Text(MyTools.capitalizeEachWord(strings.logIn)),
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
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: ((context) => const LoginForgotPasswordPopup()),
                );
              },
              text: strings.forgotPassword,
            ),
          ),

          /// CREATE ACCOUNT button
          MyClickableText(
            onTap: () {
              FocusScope.of(context).unfocus();
              viewModel.onSignUp(GoRouter.of(context));
            },
            text: strings.createAccount,
          ),
        ],
      ),
    );
  }
}
