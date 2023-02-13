import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/constants/strings/strings.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_string_provider.dart';
import 'package:my_skeleton/utils/my_tools.dart';
import 'package:my_skeleton/widgets/my_scaffold.dart';
import 'package:my_skeleton/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

import '../view_models/create_account_screen_view_model.dart';

/// Where the user goes to create a new account for this app.
class CreateAccountScreen extends StatelessWidget {
  /// Creates a screen that lets a user sign up for an account.
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// All of the strings on this page.
    final Strings strings = MyStringProvider.of(
      context,
      listen: true,
    ).strings;

    /// All of the logic that controls this page's UI.
    final CreateAccountScreenViewModel viewModel =
        CreateAccountScreenViewModel(strings);

    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, _) => MyScaffold(
        appBar: AppBar(
          title: Text(MyTools.capitalizeEachWord(strings.createAccount)),
        ),
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// EMAIL text field
            Padding(
              padding: const EdgeInsets.only(
                bottom: MyMeasurements.elementSpread,
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
                bottom: MyMeasurements.elementSpread,
              ),
              child: MyTextField(
                key: viewModel.passwordFieldKey,
                controller: viewModel.passwordController,
                isLastField: false,
                hint: strings.password,
                prefixIcon: const Icon(
                  Icons.password,
                ),
                isPassword: true,
                validators: viewModel.passwordValidators,
              ),
            ),

            /// CONFIRM PASSWORD text field
            Padding(
              padding: const EdgeInsets.only(
                bottom: MyMeasurements.elementSpread,
              ),
              child: MyTextField(
                key: viewModel.confirmPasswordFieldKey,
                controller: viewModel.confirmPasswordController,
                isLastField: true,
                hint: strings.confirmPassword,
                prefixIcon: const Icon(
                  Icons.password,
                ),
                isPassword: true,
                validators: viewModel.confirmPasswordValidators,
              ),
            ),

            /// SIGN UP button
            Padding(
              padding: const EdgeInsets.only(
                bottom: MyMeasurements.elementSpread,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await viewModel
                      .onSignUp(
                        myAuthProvider: MyAuthProvider.of(context),
                        router: GoRouter.of(context),
                      )
                      .then((myAlert) => myAlert?.show(context));
                },
                child: Text(
                  MyTools.capitalizeEachWord(strings.createAccount),
                ),
              ),
            ),

            /// EXISTING ACCOUNT button
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                viewModel.goToLogin(GoRouter.of(context));
              },
              child: Text(strings.existingAccount),
            ),
          ],
        ),
      ),
    );
  }
}
