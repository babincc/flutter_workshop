import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/features/user_account/features/profile/widgets/view_models/profile_login_info_form_view_model.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/widgets/views/my_alert/my_alert.dart';
import 'package:my_skeleton/widgets/views/my_alert/my_no_new_data_alert.dart';
import 'package:my_skeleton/widgets/views/my_loading_overlay.dart';
import 'package:my_skeleton/widgets/views/my_text.dart';
import 'package:my_skeleton/widgets/views/my_text_field.dart';

class ProfileLoginInfoForm extends StatefulWidget {
  const ProfileLoginInfoForm({super.key, required this.viewModel});

  final ProfileLoginInfoFormViewModel viewModel;

  @override
  State<ProfileLoginInfoForm> createState() => _ProfileLoginInfoFormState();
}

class _ProfileLoginInfoFormState extends State<ProfileLoginInfoForm> {
  ProfileLoginInfoFormViewModel get viewModel => widget.viewModel;

  @override
  void dispose() {
    viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
        Row(
          children: [
            // HEADER
            const MyText('Login Info', myTextStyle: MyTextStyle.header),

            const Spacer(),

            // EDIT/CLOSE BUTTON
            IconButton(
              onPressed: () async {
                bool leave = false;
                if (!viewModel.readOnly && viewModel.hasData) {
                  await MyAlert(
                    title: 'Unsaved Changes',
                    content: 'Are you sure you want to leave the form?',
                    buttons: {'Cancel': () {}, 'Leave': () => leave = true},
                  ).show(context);
                } else {
                  leave = true;
                }

                if (!leave) return;

                setState(() {
                  viewModel.readOnly = !viewModel.readOnly;
                  viewModel.clearForm();
                });
              },
              icon: Icon(viewModel.readOnly ? Icons.edit : Icons.close),
            ),
          ],
        ),

        const SizedBox(height: MyMeasurements.elementSpread),

        if (viewModel.readOnly) _buildReadOnly(),

        if (!viewModel.readOnly) _buildEditable(),
      ],
    );
  }

  /// Builds the read only form.
  Widget _buildReadOnly() {
    return SelectionArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // EMAIL LABEL
          const MyText('Email', myTextStyle: MyTextStyle.caption),

          // EMAIL
          Text(
            viewModel.supabaseUserEmail.isEmpty
                ? '[none]'
                : viewModel.supabaseUserEmail,
          ),
        ],
      ),
    );
  }

  /// Builds the editable form.
  Widget _buildEditable() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // EMAIL
        MyTextField(
          key: viewModel.emailKey,
          controller: viewModel.emailController,
          validators: viewModel.emailValidators,
          hint: 'Email',
        ),

        const SizedBox(height: MyMeasurements.elementSpread),

        // SUBMIT BTN
        ElevatedButton(
          onPressed: () async {
            final MyThemeProvider myThemeProvider = MyThemeProvider.of(context);
            final MyAuthProvider myAuthProvider = MyAuthProvider.of(context);

            /// Show a progress dialog.
            final MyLoadingOverlay myLoadingOverlay = MyLoadingOverlay()
              ..show(context);

            if (!viewModel.hasData) {
              myLoadingOverlay.closeWithCustomMessage(
                child: const MyNoNewDataAlert(),
              );

              return;
            }

            bool wasSuccessful = true;

            /// Whether or not the form has input errors.
            bool hasErrors = await viewModel.hasErrors();

            await viewModel.onSubmit(myAuthProvider).then((value) {
              if (value == null) {
                wasSuccessful = false;
                hasErrors = true;
                return;
              } else if (!value) {
                wasSuccessful = false;
                return;
              }
            });

            if (wasSuccessful) {
              if (!viewModel.didChangeEmail) {
                await myLoadingOverlay.closeWithSuccess();
              } else {
                await myLoadingOverlay.closeWithCustomMessage(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: myThemeProvider.colors.success,
                        size: 50.0,
                      ),
                      Text(
                        'Success! Check your email to apply changes.',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: myThemeProvider.colors.success,
                        ),
                      ),
                    ],
                  ),
                );
              }

              setState(() {
                viewModel.readOnly = true;
              });
            } else {
              if (hasErrors) {
                await myLoadingOverlay.close();
              } else {
                await myLoadingOverlay.closeWithCustomMessage(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error,
                        color: myThemeProvider.colors.error,
                        size: 50.0,
                      ),
                      Text(
                        'Unable to authenticate',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: myThemeProvider.colors.error,
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
