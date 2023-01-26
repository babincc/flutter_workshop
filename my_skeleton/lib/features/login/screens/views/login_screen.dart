import 'package:flutter/material.dart';
import 'package:my_skeleton/features/login/screens/view_models/login_screen_view_model.dart';
import 'package:my_skeleton/my_theme/my_spacing.dart';
import 'package:my_skeleton/my_theme/theme/my_theme.dart';
import 'package:my_skeleton/widgets/my_clickable_text.dart';
import 'package:my_skeleton/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

/// The screen the user is sent to when they are not connected to Firebase.
class LoginScreen extends StatelessWidget {
  /// Creates a screen that gives the user different choices to get connected to
  /// Firebase.
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// All of the logic that controls this page's UI.
    final LoginScreenViewModel viewModel =
        context.read<LoginScreenViewModel?>() ?? LoginScreenViewModel();

    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, _) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(MySpacing.distanceFromEdge),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /// LOGO image
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: MySpacing.elementSpread,
                    ),
                    child: Image.asset(
                      "assets/images/logo.png",
                      color: context.watch<MyTheme>().color.foreground,
                      width: 100,
                    ),
                  ),

                  /// EMAIL text field
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: MySpacing.elementSpread,
                    ),
                    child: MyTextField(
                      controller: viewModel.emailController,
                      decoration: context.watch<MyTheme>().myInputDecoration(
                            context,
                            viewModel.emailController,
                            hint: "email",
                            prefixIcon: Icon(
                              Icons.email,
                              color: context.read<MyTheme>().color.foreground,
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
                      controller: viewModel.passwordController,
                      decoration: context.watch<MyTheme>().myInputDecoration(
                            context,
                            viewModel.passwordController,
                            hint: "password",
                            prefixIcon: Icon(
                              Icons.password,
                              color: context.read<MyTheme>().color.foreground,
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
                        viewModel.onLogIn(context);
                      },
                      style: context.watch<MyTheme>().myButtonStyle,
                      child: Text(
                        "Log In",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: context.read<MyTheme>().color.background,
                            ),
                      ),
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
                        viewModel.onForgotPass(context);
                      },
                      text: "forgot password",
                    ),
                  ),

                  /// CREATE ACCOUNT button
                  MyClickableText(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      viewModel.onSignUp(context);
                    },
                    text: "create account",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
