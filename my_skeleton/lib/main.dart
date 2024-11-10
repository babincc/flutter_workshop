import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/firebase_options.dart';
import 'package:my_skeleton/my_app.dart';
import 'package:my_skeleton/navigation/my_router.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_string_provider.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/providers/my_user_provider.dart';
import 'package:my_skeleton/utils/my_file_explorer/my_file_explorer_provider.dart';

Future<void> main() async {
  usePathUrlStrategy();

  // Initialize app.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final MyAuthProvider myAuthProvider = MyAuthProvider(firebaseAuth);
  final MyUserProvider myUserProvider = MyUserProvider();
  final MyThemeProvider myThemeProvider = MyThemeProvider();
  final MyStringProvider myStringProvider = MyStringProvider();
  final MyFileExplorerProvider myFileExplorerProvider =
      MyFileExplorerProvider();
  final GoRouter myGoRouter = MyRouter.getRoutes(myAuthProvider);

  runApp(
    MyApp(
      myAuthProvider: myAuthProvider,
      myUserProvider: myUserProvider,
      myThemeProvider: myThemeProvider,
      myStringProvider: myStringProvider,
      myFileExplorerProvider: myFileExplorerProvider,
      myGoRouter: myGoRouter,
    ),
  );
}
