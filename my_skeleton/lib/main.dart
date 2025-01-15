import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:my_skeleton/firebase_options.dart';
import 'package:my_skeleton/my_app.dart';
import 'package:my_skeleton/utils/my_file_explorer.dart';

Future<void> main() async {
  usePathUrlStrategy();

  // Initialize app.
  WidgetsFlutterBinding.ensureInitialized();
  await MyFileExplorer().ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
