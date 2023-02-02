import 'package:flutter/material.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/widgets/my_scaffold.dart';
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
      builder: (context, _) => MyScaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        builder: (context) => TextButton(
          onPressed: () => viewModel.toggleTheme(MyThemeProvider.of(context)),
          child: const Text(
            "Toggle Theme",
          ),
        ),
      ),
    );
  }
}
