import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/navigation/my_router.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_string_provider.dart';
import 'package:my_skeleton/providers/my_user_provider.dart';
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
    final MyUserProvider myUserProvider = MyUserProvider(MyUser.empty());
    final MyThemeProvider myTheme = MyThemeProvider();
    final MyStringProvider myStringProvider = MyStringProvider();

    final GoRouter router = MyRouter.getRoutes(myAuthProvider);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAuthProvider>(
          create: (_) => myAuthProvider,
        ),
        ChangeNotifierProvider<MyUserProvider>(
          create: (_) => myUserProvider,
        ),
        ChangeNotifierProvider<MyThemeProvider>(
          create: (_) => myTheme,
        ),
        ChangeNotifierProvider<MyStringProvider>(
          create: (_) => myStringProvider,
        ),
      ],
      builder: (context, _) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.watch<MyThemeProvider>().themeType == ThemeType.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: GlobalLoaderOverlay(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: MaterialApp.router(
              routerConfig: router,
              theme: context.select<MyThemeProvider, ThemeData>(
                  (MyThemeProvider myTheme) => myTheme.themeData),
            ),
          ),
        ),
      ),
    );
  }
}
