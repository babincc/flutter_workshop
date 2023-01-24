import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/my_theme/my_spacing.dart';
import 'package:my_skeleton/my_theme/theme/my_theme.dart';
import 'package:my_skeleton/navigation/my_routes.dart';
import 'package:my_skeleton/utils/database/my_auth_provider.dart';

class MyDrawerMenu extends StatelessWidget {
  const MyDrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: MyTheme.of(context).color.background,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyTheme.of(context).color.background,
            ),
            child: Row(
              children: const [],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: MySpacing.textPadding),
                  child: Icon(
                    Icons.person,
                    color: MyTheme.of(context).color.foreground,
                  ),
                ),
                Text(
                  "Profile",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            onTap: () {
              closeDrawer(context);
              goToScreen(context, MyRoutes.profileScreen);
            },
          ),
          ListTile(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: MySpacing.textPadding),
                  child: Icon(
                    Icons.settings,
                    color: MyTheme.of(context).color.foreground,
                  ),
                ),
                Text(
                  "Settings",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            onTap: () {
              closeDrawer(context);
              goToScreen(context, MyRoutes.settingsScreen);
            },
          ),
          ListTile(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: MySpacing.textPadding),
                  child: Icon(
                    Icons.help,
                    color: MyTheme.of(context).color.foreground,
                  ),
                ),
                Text(
                  "Help",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            onTap: () {
              closeDrawer(context);
              goToScreen(context, MyRoutes.helpScreen);
            },
          ),
          // ListTile(
          //   title: Row(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(right: MySpacing.textPadding),
          //         child: Icon(
          //           Icons.info,
          //           color: MyTheme.of(context).color.primary,
          //         ),
          //       ),
          //       Text(
          //         "About",
          //         style: Theme.of(context).textTheme.bodyText2,
          //       ),
          //     ],
          //   ),
          //   onTap: () {
          //     closeDrawer(context);
          //     goToScreen(context, MyRoutes.aboutScreen);
          //   },
          // ),
          ListTile(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: MySpacing.textPadding),
                  child: Icon(
                    Icons.logout,
                    color: MyTheme.of(context).color.foreground,
                  ),
                ),
                Text(
                  "Logout",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            onTap: () {
              MyAuthProvider.of(context).logOut();
            },
          ),
          const SizedBox(
            height: MySpacing.distanceFromEdge,
          ),
        ],
      ),
    );
  }

  void closeDrawer(BuildContext context) => Navigator.of(context).pop();

  void goToScreen(BuildContext context, String screenName) =>
      GoRouter.of(context).pushNamed(screenName);
}
