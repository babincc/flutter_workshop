import 'package:my_skeleton/constants/strings/strings.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/features/user_account/features/create_account/screens/view_models/create_account_screen_view_model.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_string_provider.dart';
import 'package:my_skeleton/widgets/views/my_loading_overlay.dart';
import 'package:my_skeleton/widgets/views/my_scaffold.dart';
import 'package:my_skeleton/widgets/views/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Where the user goes to create a new account for this app.
class CreateAccountScreen extends StatelessWidget {
  /// Creates a screen that lets a user sign up for an account.
  const CreateAccountScreen({super.key});

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
          title: Text(strings.createAccount.capitalizeEachWord()),
        ),
        builder: (context) => SingleChildScrollView(
          child: Column(
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

                    /// Show a progress dialog.
                    final MyLoadingOverlay myLoadingOverlay = MyLoadingOverlay()
                      ..show(context);

                    // Call the view model's onSignUp method.
                    await viewModel
                        .onSignUp(
                      myAuthProvider: MyAuthProvider.of(context),
                      router: GoRouter.of(context),
                      myLoadingOverlay: myLoadingOverlay,
                    )
                        .then(
                      (myAlert) async {
                        // Close the progress dialog.
                        await myLoadingOverlay.close().then(
                              // Show the alert dialog.
                              (didClose) => myAlert?.show(context),
                            );
                      },
                    );
                  },
                  child: Text(
                    strings.createAccount.capitalizeEachWord(),
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
      ),
    );
  }
}
