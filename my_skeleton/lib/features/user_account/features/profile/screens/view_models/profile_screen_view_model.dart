import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:my_skeleton/features/user_account/features/profile/widgets/view_models/profile_login_info_form_view_model.dart';
import 'package:my_skeleton/features/user_account/features/profile/widgets/view_models/profile_personal_info_form_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreenViewModel {
  ProfileScreenViewModel({required this.user, required User? supabaseUser})
    : profilePersonalInfoFormViewModel = ProfilePersonalInfoFormViewModel(
        user: user,
      ),
      profileLoginInfoFormViewModel = ProfileLoginInfoFormViewModel(
        user: user,
        supabaseUser: supabaseUser,
      );

  final MyUser user;

  final ProfilePersonalInfoFormViewModel profilePersonalInfoFormViewModel;

  final ProfileLoginInfoFormViewModel profileLoginInfoFormViewModel;

  /// Whether or not there is any unsaved data on the page.
  bool get hasData {
    if (!profilePersonalInfoFormViewModel.readOnly &&
        profilePersonalInfoFormViewModel.hasData) {
      return true;
    }

    if (!profileLoginInfoFormViewModel.readOnly &&
        profileLoginInfoFormViewModel.hasData) {
      return true;
    }

    return false;
  }
}
