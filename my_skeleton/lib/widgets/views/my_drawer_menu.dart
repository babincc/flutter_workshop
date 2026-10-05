import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/navigation/my_routes.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';

class MyDrawerMenu extends StatelessWidget {
  const MyDrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // HEADER
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Row(children: []),
          ),

          // PROFILE
          ListTile(
            title: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: MyMeasurements.textPadding),
                  child: Icon(Icons.person),
                ),
                Text('Profile'),
              ],
            ),
            onTap: () {
              closeDrawer(context);
              goToScreen(context, MyRoutes.profileScreen);
            },
          ),

          // SETTINGS
          ListTile(
            title: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: MyMeasurements.textPadding),
                  child: Icon(Icons.settings),
                ),
                Text('Settings'),
              ],
            ),
            onTap: () {
              closeDrawer(context);
              goToScreen(context, MyRoutes.settingsScreen);
            },
          ),

          // FORM EXAMPLE
          ListTile(
            title: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: MyMeasurements.textPadding),
                  child: Icon(Icons.edit_document),
                ),
                Text('Form Example'),
              ],
            ),
            onTap: () {
              closeDrawer(context);
              goToScreen(context, MyRoutes.formExampleScreen);
            },
          ),

          // HELP
          ListTile(
            title: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: MyMeasurements.textPadding),
                  child: Icon(Icons.help),
                ),
                Text('Help'),
              ],
            ),
            onTap: () {
              closeDrawer(context);
              goToScreen(context, MyRoutes.helpScreen);
            },
          ),

          // LOG OUT
          ListTile(
            title: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: MyMeasurements.textPadding),
                  child: Icon(Icons.logout),
                ),
                Text('Sign Out'),
              ],
            ),
            onTap: () {
              MyAuthProvider.of(context).logOut(context).then((value) {
                if (context.mounted) {
                  context.goNamed(MyRoutes.loginScreen);
                }
              });
            },
          ),
          const SizedBox(height: MyMeasurements.distanceFromEdge),
        ],
      ),
    );
  }

  void closeDrawer(BuildContext context) => Navigator.of(context).pop();

  void goToScreen(BuildContext context, String screenName) =>
      GoRouter.of(context).pushNamed(screenName);
}
