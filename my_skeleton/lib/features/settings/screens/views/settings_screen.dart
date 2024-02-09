import 'package:flutter/material.dart';
import 'package:my_skeleton/features/settings/screens/view_models/settings_screen_view_model.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/widgets/views/my_scaffold.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
