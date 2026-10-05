// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/material.dart';
import 'package:my_skeleton/my_app.dart';
import 'package:my_skeleton/utils/my_file_explorer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Removes the # sign from web urls.
  // usePathUrlStrategy();

  // Initialize app.
  WidgetsFlutterBinding.ensureInitialized();
  await MyFileExplorer().ensureInitialized();
  await Supabase.initialize(
    url: 'https://laksjdflaksgahgkjdkhfk.supabase.co',
    publishableKey: 'sb_publishable_kJHKJGggbJGjhd78dbEBbedgejkhe',
  );

  runApp(const MyApp());
}
