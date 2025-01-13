import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_skeleton/domain/enums/my_theme_type.dart';
import 'package:my_skeleton/domain/models/my_app_initializer.dart';
import 'package:my_skeleton/domain/models/my_root_providers_container.dart';
import 'package:my_skeleton/navigation/my_routes.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_string_provider.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/providers/my_user_provider.dart';
import 'package:provider/provider.dart';

/// This file sets up the app and is the root file connecting all of the others
/// at runtime. This file controls the navigation and the theme of the entire
/// app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAuthProvider>.value(
          value: MyRootProvidersContainer().myAuthProvider,
        ),
        ChangeNotifierProvider<MyUserProvider>.value(
          value: MyRootProvidersContainer().myUserProvider,
        ),
        ChangeNotifierProvider<MyThemeProvider>.value(
          value: MyRootProvidersContainer().myThemeProvider,
        ),
        ChangeNotifierProvider<MyStringProvider>.value(
          value: MyRootProvidersContainer().myStringProvider,
        ),
      ],
      builder: (context, _) {
        return Selector<MyAuthProvider, bool>(
          selector: (context, myAuthProvider) => myAuthProvider.isLoggedIn,
          builder: (context, isLoggedIn, _) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: identical(context.watch<MyThemeProvider>().themeType,
                      MyThemeType.dark)
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
              child: FutureBuilder(
                future: MyAppInitializer.didInit
                    ? Future.value(true)
                    : MyAppInitializer.initApp(context),
                builder: (context, snapshot) {
                  final bool didInit;
                  if (snapshot.hasData && snapshot.data is bool) {
                    didInit = snapshot.data as bool;
                  } else {
                    didInit = false;
                  }

                  if (identical(
                      snapshot.connectionState, ConnectionState.done)) {
                    if (!didInit) {
                      // Failed to initialize the app, display error screen.
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          MyRootProvidersContainer()
                              .myGoRouter
                              .goNamed(MyRoutes.errorScreen);
                        },
                      );
                    }

                    // App is initialized, display the app.
                    return GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      child: MaterialApp.router(
                        title: 'My Skeleton',
                        routerConfig: MyRootProvidersContainer().myGoRouter,
                        theme: context.select<MyThemeProvider, ThemeData>(
                            (MyThemeProvider myTheme) => myTheme.themeData),
                      ),
                    );
                  } else {
                    // App is not initialized, display a blank screen.
                    return MaterialApp(
                      title: 'My Skeleton',
                      theme: context.select<MyThemeProvider, ThemeData>(
                          (MyThemeProvider myTheme) => myTheme.themeData),
                      builder: (context, _) {
                        return const Scaffold();
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
}
