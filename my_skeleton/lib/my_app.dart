import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/my_theme/theme/my_theme.dart';
import 'package:my_skeleton/navigation/my_router.dart';
import 'package:my_skeleton/utils/database/auth_provider.dart';
import 'package:provider/provider.dart';

/// This file sets up the app and is the root file connecting all of the others
/// at runtime. This file controls the navigation and the theme of the entire
/// app.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final AuthProvider authProvider = AuthProvider(firebaseAuth);
    final MyTheme myTheme = MyTheme();

    final GoRouter router = MyRouter.getRoutes(authProvider);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => authProvider,
        ),
        ChangeNotifierProvider<MyTheme>(
          create: (context) => myTheme,
        ),
      ],
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.watch<MyTheme>().themeType == ThemeType.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: MaterialApp.router(
          routerConfig: router,
          theme: context.select<MyTheme, ThemeData>(
              (MyTheme myTheme) => myTheme.themeData),
        ),
      ),
    );
  }
}
