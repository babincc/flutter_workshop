import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:my_skeleton/navigation/my_router.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_string_provider.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/providers/my_user_provider.dart';

class MyRootProvidersContainer {
  MyRootProvidersContainer._() {
    _init();
  }

  factory MyRootProvidersContainer() => _instance;

  /// The single instance of this class.
  static final MyRootProvidersContainer _instance =
      MyRootProvidersContainer._();

  /// Initialize all the top-level providers.
  ///
  /// This must NEVER include Futures or async operations.
  void _init() {
    myAuthProvider = MyAuthProvider(FirebaseAuth.instance);

    myUserProvider = MyUserProvider();

    myThemeProvider = MyThemeProvider();

    myStringProvider = MyStringProvider();

    myGoRouter = MyRouter.getRoutes(myAuthProvider);
  }

  late final MyAuthProvider myAuthProvider;

  late final MyUserProvider myUserProvider;

  late final MyThemeProvider myThemeProvider;

  late final MyStringProvider myStringProvider;

  late final GoRouter myGoRouter;
}
