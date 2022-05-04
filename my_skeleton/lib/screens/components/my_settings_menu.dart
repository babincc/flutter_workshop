import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/my_theme/my_colors.dart';
import 'package:my_skeleton/my_theme/my_spacing.dart';
import 'package:my_skeleton/navigation/my_routes.dart';
import 'package:my_skeleton/utils/database/auth_provider.dart';

/// This is the hamburger settings menu that appears at the top of most pages
/// throughout the app.
class MySettingsMenu extends StatelessWidget {
  /// Creates the hamburger settings menu that appears at the top of most pages
  /// throughout the app.
  const MySettingsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _MenuController menuController = _MenuController(context);

    return GestureDetector(
      onTap: () => menuController.openMenu(context),
      child: const Icon(
        Icons.menu,
        color: MyColors.background,
      ),
    );
  }
}

/// This class keeps track of and controls the settings pop-up menu.
class _MenuController {
  /// Creates a way to control the state of the settings pop-up menu.
  _MenuController(BuildContext context) {
    menu = getMenu(context);
  }

  /// The body of the settings pop-up menu.
  late OverlayEntry menu;

  /// This method displays the settings menu pop-up for the user.
  void openMenu(BuildContext context) {
    final OverlayState? overlay = Overlay.of(context);

    if (overlay == null) {
      // TODO error
    } else {
      overlay.insert(menu);
    }
  }

  /// This method closes the settings menu pop-up.
  void closeMenu() {
    menu.remove();
  }

  /// This method creates and returns the settings menu that pops up for the
  /// user.
  OverlayEntry getMenu(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;

    return OverlayEntry(
      builder: ((context) => Stack(
            children: [
              GestureDetector(
                onTap: () => closeMenu(),
                child: Container(
                  width: screen.width,
                  height: screen.height,
                  color: MyColors.primary.withAlpha(50),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  child: SizedBox(
                    width: screen.width,
                    height: screen.height * 0.8,
                    child: SingleChildScrollView(
                      child: Column(
                        children: getMenuButtons(context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  List<Widget> getMenuButtons(BuildContext context) {
    return <Widget>[
      buildButton(
        context: context,
        icon: Icons.person,
        label: "Profile",
        route: MyRoutes.profileScreen,
      ),
      buildButton(
        context: context,
        icon: Icons.settings,
        label: "Settings",
        route: MyRoutes.settingsScreen,
      ),
      buildButton(
        context: context,
        icon: Icons.help,
        label: "Help",
        route: MyRoutes.contactScreen,
      ),
      buildButton(
        context: context,
        icon: Icons.info,
        label: "About",
        route: MyRoutes.aboutScreen,
      ),
      buildButton(
        context: context,
        icon: Icons.logout,
        label: "Logout",
        function: () => AuthProvider.of(context).logOut(),
      ),
      const SizedBox(
        height: MySpacing.distanceFromEdge,
      ),
    ];
  }

  GestureDetector buildButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    void Function()? function,
    String? route,
  }) {
    return GestureDetector(
      onTap: () {
        if (function != null) {
          function();
        }
        if (route != null) {
          GoRouter.of(context).goNamed(route);
        }
        closeMenu();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: MySpacing.elementSpread,
          horizontal: MySpacing.distanceFromEdge,
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: MySpacing.elementSpread),
            Text(label),
          ],
        ),
      ),
    );
  }
}
