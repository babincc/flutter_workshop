import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:my_skeleton/domain/repos/my_user_repo.dart';
import 'package:my_skeleton/navigation/my_router.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_string_provider.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/providers/my_user_provider.dart';
import 'package:my_skeleton/utils/my_file_explorer/my_file_explorer_provider.dart';
import 'package:provider/provider.dart';

/// This file sets up the app and is the root file connecting all of the others
/// at runtime. This file controls the navigation and the theme of the entire
/// app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// TODO: Set this to true when you are ready to deploy to the app store.
  /// This will enable Crashlytics and disable the debug printouts.
  static const bool isLive = false;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final MyAuthProvider myAuthProvider = MyAuthProvider(firebaseAuth);
    final MyUserProvider myUserProvider = MyUserProvider();
    final MyThemeProvider myTheme = MyThemeProvider();
    final MyStringProvider myStringProvider = MyStringProvider();
    final MyFileExplorerProvider myFileExplorerProvider =
        MyFileExplorerProvider();

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
        ChangeNotifierProvider<MyFileExplorerProvider>(
          create: (_) => myFileExplorerProvider,
        ),
      ],
      builder: (_, __) {
        return Selector<MyAuthProvider, bool>(
          selector: (_, myAuthProvider) => myAuthProvider.isLoggedIn,
          builder: (context, isLoggedIn, _) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value:
                  context.watch<MyThemeProvider>().themeType == ThemeType.dark
                      ? SystemUiOverlayStyle.light
                      : SystemUiOverlayStyle.dark,
              child: FutureBuilder(
                future:
                    _initApp(context, myUserProvider, myAuthProvider.user?.uid),
                builder: (context, snapshot) {
                  if (identical(
                      snapshot.connectionState, ConnectionState.done)) {
                    return GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      child: MaterialApp.router(
                        routerConfig: router,
                        theme: context.select<MyThemeProvider, ThemeData>(
                            (MyThemeProvider myTheme) => myTheme.themeData),
                      ),
                    );
                  } else {
                    return MaterialApp(
                      builder: (context, child) {
                        return const Scaffold(
                          backgroundColor: Colors.black,
                        );
                      },
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  /// Initializes the app.
  Future<void> _initApp(
    BuildContext context,
    MyUserProvider myUserProvider,
    String? userId,
  ) async {
    await MyFileExplorerProvider.of(context).ensureInitialized().then(
      (_) async {
        if (userId == null) return;

        // Fetch user data from Firestore.
        await MyUserRepo.fetchUser(userId).then(
          (value) async {
            final MyUser user = value ?? MyUser.empty();

            myUserProvider.user = user;
          },
        );
      },
    );
  }
}
