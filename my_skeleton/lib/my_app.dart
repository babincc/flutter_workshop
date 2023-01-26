import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/my_theme/theme/my_theme.dart';
import 'package:my_skeleton/navigation/my_router.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:provider/provider.dart';

/// This file sets up the app and is the root file connecting all of the others
/// at runtime. This file controls the navigation and the theme of the entire
/// app.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final MyAuthProvider myAuthProvider = MyAuthProvider(firebaseAuth);
    final MyTheme myTheme = MyTheme();

    final GoRouter router = MyRouter.getRoutes(myAuthProvider);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAuthProvider>(
          create: (context) => myAuthProvider,
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
