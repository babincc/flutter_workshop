/// The are all of the navigation routes in the app.
class MyRoutes {
  // static const String aboutScreen = "/about_screen";

  static const String createAccountScreen =
      "${_MyFolders.userAccount}/create_account_screen";

  static const String dashboardScreen = "/dashboard_screen";

  static const String errorScreen = "/error_screen";

  static const String helpScreen = "/help_screen";

  static const String loginScreen = "${_MyFolders.userAccount}/login_screen";

  static const String profileScreen =
      "${_MyFolders.userAccount}/profile_screen";

  static const String settingsScreen = "/settings_screen";
}

/// These are navigation folders or packages that some pages may be found in.
class _MyFolders {
  static const String userAccount = "/user_account";
}
