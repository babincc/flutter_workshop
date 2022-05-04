/// The are all of the navigation routes in the app.
class MyRoutes {
  static const String aboutScreen = "${_MyFolders.businessBasics}/about_screen";

  static const String contactScreen =
      "${_MyFolders.businessBasics}/contact_screen";

  static const String legalScreen = "${_MyFolders.businessBasics}/legal_screen";

  static const String dashboardScreen = "/dashboard_screen";

  static const String errorScreen = "/error_screen";

  static const String settingsScreen = "/settings_screen";

  static const String loginScreen = "${_MyFolders.userAccount}/login_screen";

  static const String profileScreen =
      "${_MyFolders.userAccount}/profile_screen";

  static const String signupScreen = "${_MyFolders.userAccount}/signup_screen";
}

/// These are navigation folders or packages that some pages may be found in.
class _MyFolders {
  static const String businessBasics = "/business_basics";

  static const String userAccount = "/user_account";
}
