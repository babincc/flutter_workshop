import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/features/user_account/features/profile/screens/view_models/profile_screen_view_model.dart';
import 'package:my_skeleton/features/user_account/features/profile/widgets/views/profile_login_info_form.dart';
import 'package:my_skeleton/features/user_account/features/profile/widgets/views/profile_personal_info_form.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_user_provider.dart';
import 'package:my_skeleton/widgets/views/my_alert/my_alert.dart';
import 'package:my_skeleton/widgets/views/my_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileScreenViewModel viewModel = ProfileScreenViewModel(
      user: MyUserProvider.of(context).user,
      supabaseUser: MyAuthProvider.of(context).user,
    );

    return MyScaffold(
      appBar: AppBar(title: const Text('Profile')),
      onPopInvoked: () async {
        if (!viewModel.hasData) return true;

        bool toPop = false;

        await MyAlert(
          title: 'Are you sure you want to leave?',
          content: 'Any data you have not submitted will be lost.',
          buttons: {'Cancel': () => toPop = false, 'Leave': () => toPop = true},
        ).show(context);

        return toPop;
      },
      builder: (context) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: MyMeasurements.contentWidth,
          ),
          child: Column(
            children: [
              // PERSONAL INFO
              ProfilePersonalInfoForm(
                viewModel: viewModel.profilePersonalInfoFormViewModel,
              ),

              const SizedBox(height: MyMeasurements.elementSpread * 3.5),

              // LOGIN INFO
              ProfileLoginInfoForm(
                viewModel: viewModel.profileLoginInfoFormViewModel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
