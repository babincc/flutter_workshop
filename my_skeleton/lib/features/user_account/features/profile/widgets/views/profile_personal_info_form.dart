import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/features/user_account/features/profile/widgets/view_models/profile_personal_info_form_view_model.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/widgets/views/my_alert/my_alert.dart';
import 'package:my_skeleton/widgets/views/my_alert/my_no_new_data_alert.dart';
import 'package:my_skeleton/widgets/views/my_loading_overlay.dart';
import 'package:my_skeleton/widgets/views/my_text.dart';
import 'package:my_skeleton/widgets/views/my_text_field.dart';

class ProfilePersonalInfoForm extends StatefulWidget {
  const ProfilePersonalInfoForm({super.key, required this.viewModel});

  final ProfilePersonalInfoFormViewModel viewModel;

  @override
  State<ProfilePersonalInfoForm> createState() =>
      _ProfilePersonalInfoFormState();
}

class _ProfilePersonalInfoFormState extends State<ProfilePersonalInfoForm> {
  ProfilePersonalInfoFormViewModel get viewModel => widget.viewModel;

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
            const MyText('Personal Info', myTextStyle: MyTextStyle.header),

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
          // NAME LABEL
          const MyText('Name', myTextStyle: MyTextStyle.caption),

          // NAME
          Text(viewModel.user.name.isEmpty ? '[none]' : viewModel.user.name),
        ],
      ),
    );
  }

  /// Builds the editable form.
  Widget _buildEditable() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // FIRST NAME
        MyTextField(
          key: viewModel.firstNameKey,
          controller: viewModel.firstNameController,
          validators: viewModel.firstNameValidators,
          hint: 'Name',
        ),

        const SizedBox(height: MyMeasurements.elementSpread),

        // LAST NAME
        MyTextField(
          key: viewModel.lastNameKey,
          controller: viewModel.lastNameController,
          validators: viewModel.lastNameValidators,
          hint: 'Name',
        ),

        const SizedBox(height: MyMeasurements.elementSpread),

        // SUBMIT BTN
        ElevatedButton(
          onPressed: () async {
            final MyThemeProvider myThemeProvider = MyThemeProvider.of(context);

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
            bool hasErrors = false;

            await viewModel.onSubmit().then((value) {
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
              await myLoadingOverlay.closeWithSuccess(
                color: myThemeProvider.colors.success,
              );

              setState(() {
                viewModel.readOnly = true;
              });
            } else {
              if (hasErrors) {
                await myLoadingOverlay.close();
              } else {
                await myLoadingOverlay.closeWithFailure(
                  color: myThemeProvider.colors.error,
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
