import 'package:flutter/material.dart';
import 'package:skeleton_code/screens/home/home.dart';
import 'package:skeleton_code/theme/my_theme.dart';

// vvvvvvvvvvvvvvvvvvvvvvvvvvv Navigation Routes vvvvvvvvvvvvvvvvvvvvvvvvvvvv //

const String HomeRoute = "/home";

// ^^^^^^^^^^^^^^^^^^^^^^^^^ End Navigation Routes ^^^^^^^^^^^^^^^^^^^^^^^^^^ //

/// This file sets up the app and is the root file connecting all of the others
/// at runtime. This file controls the navigation and the theme of the entire
/// app.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: _routes(),
      theme: MyTheme.myTheme,
    );
  }
}

/// This method sets up the navigation for the app.
RouteFactory _routes() {
  return (settings) {
    Widget screen;

    switch (settings.name) {
      // login
      case "/":
      case HomeRoute:
        screen = Home();
        break;

      // FAILED
      default:
        return null;
    }

    return MaterialPageRoute(builder: (BuildContext context) => screen);
  };
}
