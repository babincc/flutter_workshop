import 'package:go_router/go_router.dart';
import 'package:my_skeleton/navigation/my_router.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/providers/my_user_provider.dart';

class MyRootProvidersContainer {
  MyRootProvidersContainer() {
    _init();
  }

  void dispose() {
    myGoRouter.dispose();
    myAuthProvider.dispose();
    myUserProvider.dispose();
    myThemeProvider.dispose();
  }

  /// Initialize all the top-level providers.
  ///
  /// This must NEVER include Futures or async operations.
  void _init() {
    myAuthProvider = MyAuthProvider();
    myThemeProvider = MyThemeProvider();
    myGoRouter = MyRouter.getRoutes(myAuthProvider);
    myUserProvider = MyUserProvider();
  }

  late final MyAuthProvider myAuthProvider;

  late final MyThemeProvider myThemeProvider;

  late final GoRouter myGoRouter;

  late final MyUserProvider myUserProvider;
}
