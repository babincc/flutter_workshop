import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/features/dashboard/screens/views/dashboard_screen.dart';
import 'package:my_skeleton/features/error_404/screens/views/error_screen.dart';
import 'package:my_skeleton/features/help/screens/views/help_screen.dart';
import 'package:my_skeleton/features/user_account/features/create_account/screens/views/create_account_screen.dart';
import 'package:my_skeleton/features/user_account/features/login/screens/views/login_screen.dart';
import 'package:my_skeleton/features/user_account/features/profile/screens/views/profile_screen.dart';
import 'package:my_skeleton/features/settings/screens/views/settings_screen.dart';
import 'package:my_skeleton/navigation/my_routes.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';

/// This router is in control of navigation throughout the app.
class MyRouter {
  /// This returns the customized router with all of its credentials.
  static GoRouter getRoutes(MyAuthProvider myAuthProvider) {
    return GoRouter(
      restorationScopeId: 'router',
      refreshListenable: myAuthProvider,
      initialLocation: MyRoutes.loginScreen,
      redirect: (context, state) async {
        /// All of the pages that do not need the user to be logged in for them
        /// to be accessed.
        const List<String> publicPages = [
          // MyRoutes.aboutScreen,
          MyRoutes.helpScreen,
          MyRoutes.loginScreen,
          MyRoutes.settingsScreen,
          MyRoutes.createAccountScreen,
        ];

        /// This will be `true` if the user is attempting to log in.
        bool isLoggingIn =
            state.fullPath?.startsWith(MyRoutes.loginScreen) ?? false;

        /// This will be `true` if the user is logged in.
        bool isLoggedIn = myAuthProvider.isLoggedIn;

        /// This will be `true` if the user is attempting to access a page from
        /// [publicPages].
        bool isGoingToPublicPage = publicPages.contains(state.fullPath);

        // If the user is trying to log in and they are not logged in already,
        // let them proceed.
        if (isLoggingIn && !isLoggedIn) {
          return null;
        }

        // If the user is not logged in but they are trying to go to a page that
        // requires log in, stop them.
        if (!isLoggedIn && !isGoingToPublicPage) {
          return MyRoutes.loginScreen;
        }

        // If the user is already logged in, don't let them go to the login
        // page.
        if (isLoggingIn && isLoggedIn) {
          return MyRoutes.dashboardScreen;
        }

        return null;
      },
      routes: [
        GoRoute(
          name: '/',
          path: '/',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          name: MyRoutes.createAccountScreen,
          path: MyRoutes.createAccountScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const CreateAccountScreen(),
          ),
        ),
        GoRoute(
          name: MyRoutes.dashboardScreen,
          path: MyRoutes.dashboardScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const DashboardScreen(),
          ),
        ),
        GoRoute(
          name: MyRoutes.errorScreen,
          path: MyRoutes.errorScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const ErrorScreen(),
          ),
        ),
        GoRoute(
          name: MyRoutes.helpScreen,
          path: MyRoutes.helpScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const HelpScreen(),
          ),
        ),
        GoRoute(
          name: MyRoutes.loginScreen,
          path: MyRoutes.loginScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          name: MyRoutes.profileScreen,
          path: MyRoutes.profileScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const ProfileScreen(),
          ),
        ),
        GoRoute(
          name: MyRoutes.settingsScreen,
          path: MyRoutes.settingsScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const SettingsScreen(),
          ),
        ),
      ],
      errorPageBuilder: (context, state) => MaterialPage<void>(
        key: state.pageKey,
        child: const ErrorScreen(),
      ),
    );
  }
}
