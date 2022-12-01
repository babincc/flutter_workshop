import 'package:flutter/material.dart';
import 'package:my_skeleton/my_theme/my_spacing.dart';
import 'package:my_skeleton/my_theme/theme/my_theme.dart';
import 'package:my_skeleton/screens/components/my_clickable_text.dart';
import 'package:my_skeleton/screens/components/my_text_field.dart';
import 'package:my_skeleton/screens/user_account/login_screen/login_screen_logic.dart';
import 'package:provider/provider.dart';

/// The screen the user is sent to when they are not connected to Firebase.
class LoginScreen extends StatelessWidget {
  /// Creates a screen that gives the user different choices to get connected to
  /// Firebase.
  LoginScreen({Key? key})
      : loginScreenLogic = LoginScreenLogic(),
        super(key: key);

  /// All of the logic that controls this page's UI.
  final LoginScreenLogic loginScreenLogic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MySpacing.distanceFromEdge),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // /// LOGO image
                // Padding(
                //   padding: const EdgeInsets.only(
                //     bottom: MySpacing.elementSpread,
                //   ),
                //   child: Image.asset(
                //     "assets/images/logo.png",
                //     color: context.watch<MyTheme>().color.foreground,
                //     width: 100,
                //   ),
                // ),

                /// EMAIL text field
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: MySpacing.elementSpread,
                  ),
                  child: MyTextField(
                    controller: loginScreenLogic.emailController,
                    decoration: context.watch<MyTheme>().myInputDecoration(
                          context,
                          loginScreenLogic.emailController,
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
                    controller: loginScreenLogic.passwordController,
                    decoration: context.watch<MyTheme>().myInputDecoration(
                          context,
                          loginScreenLogic.passwordController,
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
                      loginScreenLogic.onLogIn(context);
                    },
                    child: Text(
                      "Log In",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: context.read<MyTheme>().color.background,
                          ),
                    ),
                    style: context.watch<MyTheme>().myButtonStyle,
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
                      loginScreenLogic.onForgotPass(context);
                    },
                    text: "forgot password",
                  ),
                ),

                /// CREATE ACCOUNT button
                MyClickableText(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    loginScreenLogic.onSignUp(context);
                  },
                  text: "create account",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
