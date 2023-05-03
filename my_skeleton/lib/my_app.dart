import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_skeleton/constants/assets.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:my_skeleton/domain/repos/my_user_repo.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/navigation/my_router.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_string_provider.dart';
import 'package:my_skeleton/providers/my_user_provider.dart';
import 'package:my_skeleton/widgets/views/my_text.dart';
import 'package:provider/provider.dart';

/// This file sets up the app and is the root file connecting all of the others
/// at runtime. This file controls the navigation and the theme of the entire
/// app.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /// TODO: Set this to true when you are ready to deploy to the app store.
  /// This will enable Crashlytics and disable the debug printouts.
  static const bool isLive = false;

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
      builder: (_, __) {
        return Selector<MyAuthProvider, bool>(
          selector: (_, myAuthProvider) => myAuthProvider.isLoggedIn,
          builder: (context, isLoggedIn, _) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value:
                  context.watch<MyThemeProvider>().themeType == ThemeType.dark
                      ? SystemUiOverlayStyle.light
                      : SystemUiOverlayStyle.dark,
              child: GlobalLoaderOverlay(
                useDefaultLoading: false,
                overlayWidget: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.progressSpinner,
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: MyMeasurements.elementSpread),
                      MyText(
                        "Loading...",
                        color: const Color.fromARGB(255, 72, 77, 98),
                      ),
                    ],
                  ),
                ),
                child: FutureBuilder(
                  future: _fetchMyUser(
                      context, myUserProvider, myAuthProvider.user?.uid),
                  builder: (context, snapshot) {
                    if (identical(
                        snapshot.connectionState, ConnectionState.done)) {
                      context.loaderOverlay.hide();
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
                          context.loaderOverlay.show();
                          return const Scaffold(
                            backgroundColor: Colors.black,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _fetchMyUser(BuildContext context, MyUserProvider myUserProvider,
      String? userId) async {
    if (userId != null) {
      MyUserRepo.fetchUser(userId).then((value) {
        final MyUser myUser = value ?? MyUser.empty();

        myUserProvider.myUser = myUser;
      });
    }
  }
}
