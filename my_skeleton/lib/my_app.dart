import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/domain/enums/my_theme_type.dart';
import 'package:my_skeleton/domain/models/my_app_initializer.dart';
import 'package:my_skeleton/domain/models/my_root_providers_container.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/providers/my_user_provider.dart';
import 'package:provider/provider.dart';

/// This file sets up the app and is the root file connecting all of the others
/// at runtime. This file controls the navigation and the theme of the entire
/// app.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final MyRootProvidersContainer myRootProviders;
  final MyAppInitializer initializer = MyAppInitializer();

  @override
  void initState() {
    super.initState();
    myRootProviders = MyRootProvidersContainer();
  }

  @override
  void dispose() {
    initializer.dispose();
    myRootProviders.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAuthProvider>.value(
          value: myRootProviders.myAuthProvider,
        ),
        ChangeNotifierProvider<MyUserProvider>.value(
          value: myRootProviders.myUserProvider,
        ),
        ChangeNotifierProvider<MyThemeProvider>.value(
          value: myRootProviders.myThemeProvider,
        ),
      ],
      builder: (context, _) {
        return Selector<MyAuthProvider, String?>(
          selector: (context, myAuthProvider) => myAuthProvider.user?.id,
          builder: (context, userId, _) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value:
                  context.watch<MyThemeProvider>().themeType == MyThemeType.dark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
              child: FutureBuilder(
                future: initializer.initApp(context),
                builder: (context, snapshot) {
                  final bool didInit;
                  if (snapshot.hasData && snapshot.data is bool) {
                    didInit = snapshot.data as bool;
                  } else {
                    didInit = false;
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    if (!didInit) {
                      // Failed to initialize the app, display error
                      // screen.
                      return _myMaterialApp(
                        context: context,
                        builder: (context, _) => Scaffold(
                          body: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Unable to load your profile. Check your '
                                  'connection and profile setup.',
                                ),

                                SizedBox(height: MyMeasurements.elementSpread),

                                TextButton(
                                  onPressed: () => setState(initializer.retry),
                                  child: const Text('Retry'),
                                ),

                                SizedBox(height: MyMeasurements.elementSpread),

                                TextButton(
                                  onPressed: () => myRootProviders
                                      .myAuthProvider
                                      .logOut(context),
                                  child: const Text('Sign out'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    // App is initialized, display the app.
                    return GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      child: _myMaterialAppRouter(
                        context: context,
                        routerConfig: myRootProviders.myGoRouter,
                      ),
                    );
                  } else {
                    // App is not initialized, display a blank screen.
                    return _myMaterialApp(
                      context: context,
                      builder: (context, _) {
                        return const Scaffold(); // TODO: Add a splash screen here
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

  // TODO: Change to app title.
  static const String _title = 'My Skeleton';

  Widget _myMaterialApp({
    required BuildContext context,
    required Widget Function(BuildContext, Widget?)? builder,
  }) {
    return MaterialApp(
      title: _title,
      theme: context.select<MyThemeProvider, ThemeData>(
        (MyThemeProvider myTheme) => myTheme.themeData,
      ),
      builder: builder,
    );
  }

  Widget _myMaterialAppRouter({
    required BuildContext context,
    required RouterConfig<Object>? routerConfig,
  }) {
    return MaterialApp.router(
      title: _title,
      routerConfig: routerConfig,
      theme: context.select<MyThemeProvider, ThemeData>(
        (MyThemeProvider myTheme) => myTheme.themeData,
      ),
    );
  }
}
