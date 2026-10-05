import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/constants/files/assets.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/features/user_account/features/login/screens/view_models/login_screen_view_model.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/widgets/views/my_elevated_button/my_elevated_button.dart';
import 'package:my_skeleton/widgets/views/my_loading_overlay.dart';
import 'package:my_skeleton/widgets/views/my_scaffold.dart';
import 'package:my_skeleton/widgets/views/my_text_field.dart';

/// The screen the user is sent to when they are not connected to Supabase.
class LoginScreen extends StatefulWidget {
  /// Creates a screen that gives the user different choices to get connected to
  /// Supabase.
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginScreenViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = LoginScreenViewModel(authProvider: MyAuthProvider.of(context));
  }

  @override
  void dispose() {
    viewModel.emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      builder: (context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// LOGO image
            Padding(
              padding: const EdgeInsets.only(
                bottom: MyMeasurements.elementSpread,
              ),
              child: Image.asset(Assets.logo, width: 175),
            ),

            const SizedBox(height: MyMeasurements.elementSpread * 2.0),

            /// EMAIL text field
            MyTextField(
              key: viewModel.emailKey,
              controller: viewModel.emailController,
              isLastField: false,
              hint: 'Email',
              prefixIcon: const Icon(Icons.email),
              validators: viewModel.emailValidators,
            ),

            const SizedBox(height: MyMeasurements.elementSpread * 2.0),

            // SEND CODE BUTTON
            MyElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();

                final MyLoadingOverlay myLoadingOverlay = MyLoadingOverlay()
                  ..show(context);

                await viewModel.onLogIn(router: GoRouter.of(context)).then((
                  myAlert,
                ) async {
                  await myLoadingOverlay.close();
                  if (context.mounted) {
                    myAlert?.show(context);
                  }
                });
              },
              text: 'Send Code',
            ),

            const SizedBox(height: MyMeasurements.elementSpread),

            // AUTO CREATE ACCOUNT MESSAGE
            Text('New here? We\'ll create your account automatically.'),
          ],
        ),
      ),
    );
  }
}
