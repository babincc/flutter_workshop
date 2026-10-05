import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/constants/theme/my_colors.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/features/user_account/features/login/screens/view_models/login_otp_page_view_model.dart';
import 'package:my_skeleton/navigation/my_routes.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/widgets/views/my_elevated_button/my_elevated_button_secondary.dart';
import 'package:my_skeleton/widgets/views/my_loading_overlay.dart';
import 'package:my_skeleton/widgets/views/my_scaffold.dart';
import 'package:my_skeleton/widgets/views/my_segmented_text_field.dart';
import 'package:my_skeleton/widgets/views/my_text.dart';

class LoginOtpPage extends StatefulWidget {
  const LoginOtpPage({super.key});

  @override
  State<LoginOtpPage> createState() => _LoginOtpPageState();
}

class _LoginOtpPageState extends State<LoginOtpPage> {
  late final LoginOtpPageViewModel viewModel;
  late final Timer _cooldownTimer;

  @override
  void initState() {
    super.initState();
    viewModel = LoginOtpPageViewModel(authProvider: MyAuthProvider.of(context));
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cooldownTimer.cancel();
    viewModel.otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyAuthProvider authProvider = MyAuthProvider.of(context);

    final MyColors colors = MyThemeProvider.of(context).colors;

    return MyScaffold(
      builder: (context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CHECK YOUR MAIL HEADER
            MyText('Check your inbox!', myTextStyle: MyTextStyle.title),

            const SizedBox(height: MyMeasurements.elementSpread),

            // CHECK YOUR MAIL MESSAGE
            Text('We sent a 6-digit magic code to'),

            const SizedBox(height: MyMeasurements.elementSpread),

            // EMAIL
            Text(authProvider.lastEmailSentAddress ?? 'Error'),

            const SizedBox(height: MyMeasurements.elementSpread * 4.5),

            /// OTP FIELD
            MySegmentedTextField(
              key: viewModel.otpKey,
              numFields: 6,
              controller: viewModel.otpController,
            ),

            const SizedBox(height: MyMeasurements.elementSpread * 2.5),

            // SEND CODE BUTTON
            MyElevatedButtonSecondary(
              onPressed: () async {
                FocusScope.of(context).unfocus();

                final MyLoadingOverlay myLoadingOverlay = MyLoadingOverlay()
                  ..show(context);

                await viewModel
                    .onLogIn(
                      myAuthProvider: MyAuthProvider.of(context),
                      router: GoRouter.of(context),
                    )
                    .then((myAlert) async {
                      await myLoadingOverlay.close();
                      if (context.mounted) {
                        await myAlert?.show(context);
                      }
                    });

                if (authProvider.lastEmailSentAddress == null) {
                  if (context.mounted) {
                    GoRouter.of(context).pop();
                  }
                }
              },
              text: 'Verify Code',
            ),

            const SizedBox(height: MyMeasurements.elementSpread),

            // DIDN'T RECEIVE CODE MESSAGE
            MyText('Didn\'t receive the code?', color: colors.hint),

            const SizedBox(height: MyMeasurements.elementSpread),

            // RESEND BUTTON
            InkWell(
              onTap: !viewModel.canResend
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();

                      final MyLoadingOverlay myLoadingOverlay =
                          MyLoadingOverlay()..show(context);

                      await viewModel.onResendOtp().then((myAlert) async {
                        await myLoadingOverlay.close();
                        if (context.mounted) {
                          await myAlert?.show(context);
                        }
                      });

                      if (authProvider.lastEmailSentAddress == null) {
                        if (context.mounted) {
                          GoRouter.of(context).pop();
                        }
                      }
                    },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // RESEND ICON
                  Icon(Icons.refresh, color: colors.primary),

                  const SizedBox(width: MyMeasurements.textPadding),

                  // RESEND TEXT
                  MyText('Resend Code', color: colors.primary),

                  // COOL DOWN
                  if (!viewModel.canResend)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: MyMeasurements.textPadding,
                      ),
                      child: MyText(
                        '(${viewModel.remainingCooldownSec})',
                        color: colors.primary,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: MyMeasurements.elementSpread * 2.5),

            // BACK TO EMAIL BUTTON
            InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();

                final GoRouter goRouter = GoRouter.of(context);

                if (goRouter.canPop()) {
                  goRouter.pop();
                } else {
                  goRouter.goNamed(MyRoutes.loginScreen);
                }
              },
              child: MyText('Back to Email', color: colors.hint),
            ),
          ],
        ),
      ),
    );
  }
}
