// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/material.dart';
import 'package:my_skeleton/my_app.dart';
import 'package:my_skeleton/utils/my_file_explorer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Removes the # sign from web urls.
  // usePathUrlStrategy();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
  if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
    throw StateError(
      'Set SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY with --dart-define.',
    );
  }

  // Initialize app.
  WidgetsFlutterBinding.ensureInitialized();
  await MyFileExplorer().ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);

  runApp(const MyApp());
}
