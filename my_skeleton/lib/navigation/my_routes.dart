/// The are all of the navigation routes in the app.
class MyRoutes {
  // static const String aboutScreen = '/about';

  static const String createAccountScreen =
      '${_MyFolders.userAccount}/create_account';

  static const String dashboardScreen = '/dashboard';

  static const String errorScreen = '/error';

  static const String formExampleScreen = '/form_example';

  static const String helpScreen = '/help_screen';

  static const String loginScreen = '${_MyFolders.userAccount}/login';

  static const String profileScreen = '${_MyFolders.userAccount}/profile';

  static const String settingsScreen = '/settings';
}

/// These are navigation folders or packages that some pages may be found in.
class _MyFolders {
  static const String userAccount = '/user_account';
}
