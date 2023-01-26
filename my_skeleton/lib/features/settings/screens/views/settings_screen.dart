import 'package:flutter/material.dart';
import 'package:my_skeleton/my_theme/colors/my_dark_theme_colors.dart';
import 'package:my_skeleton/my_theme/theme/my_theme.dart';
import 'package:my_skeleton/widgets/my_safe_area.dart';
import 'package:provider/provider.dart';

import '../view_models/settings_screen_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// All of the logic that controls this page's UI.
    final SettingsScreenViewModel viewModel =
        context.read<SettingsScreenViewModel?>() ?? SettingsScreenViewModel();

    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: MySafeArea(
          child: TextButton(
            onPressed: () => viewModel.toggleTheme(MyTheme.of(context)),
            style: MyTheme.of(context).myButtonStyle,
            child: Text(
              "Toggle Theme",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: MyDarkThemeColors().background,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
