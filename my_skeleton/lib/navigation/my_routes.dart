/// The are all of the navigation routes in the app.
class MyRoutes {
  static const String dashboardScreen = '/dashboard';

  static const String errorScreen = '${_MyFolders.error}/error';

  static const String formExampleScreen = '/form_example';

  static const String helpScreen = '/help_screen';

  static const String loginScreen = '${_MyFolders.userAccount}/login';

  static const String otpPage = '$loginScreen/otp';

  static const String profileScreen = '${_MyFolders.userAccount}/profile';

  static const String settingsScreen = '/settings';
}

/// These are navigation folders or packages that some pages may be found in.
class _MyFolders {
  static const String error = '/error';

  static const String userAccount = '/user_account';
}
