import 'package:flutter/material.dart';
import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:my_skeleton/domain/repos/my_user_repo.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_user_provider.dart';

class MyAppInitializer {
  /// Whether or not the init process is happening.
  static bool _lockOut = false;

  /// Whether or not the app has been initialized.
  static bool get didInit => _didInitUser && _didInitOtherCustomThing;

  /// Whether or not the user has been initialized.
  static bool _didInitUser = false;

  /// Additional inits here.
  static bool _didInitOtherCustomThing = false;

  /// All init values to print for debugging.
  static String get debugOutput =>
      '_didInitUser: $_didInitUser\n'
      '_didInitOtherCustomThing: $_didInitOtherCustomThing';

  /// Initializes the app.
  static Future<bool> initApp(BuildContext context) async {
    if (_lockOut) return false;

    _lockOut = true;

    // Skip if already initialized.
    if (didInit) {
      _lockOut = false;
      return true;
    }

    // Get providers before async.
    final MyAuthProvider myAuthProvider = MyAuthProvider.of(context);
    final MyUserProvider myUserProvider = MyUserProvider.of(context);

    // Initialize user.
    await _initUser(myAuthProvider, myUserProvider);

    // Init other things.
    await _initOtherThings();

    _lockOut = false;
    return didInit;
  }

  /// Cleans the app state.
  ///
  /// This is useful when a user logs out.
  static void clearApp(BuildContext context) {
    if (_lockOut) return;

    _lockOut = true;

    // Get providers.
    final MyUserProvider myUserProvider = MyUserProvider.of(context);

    _clearUser(myUserProvider);

    _clearOtherThings();

    _lockOut = false;
  }

  /// Initializes the user.
  static Future<void> _initUser(
    MyAuthProvider myAuthProvider,
    MyUserProvider myUserProvider,
  ) async {
    if (_didInitUser) return;

    /// The user ID of the current user.
    final String? userId = myAuthProvider.user?.id;

    // Skip if user ID is null.
    if (userId == null) return;

    // Fetch user data from Firestore.
    final MyUser? fetchedUser = await MyUserRepo.fetchUser(userId);

    // Skip if user is null.
    if (fetchedUser == null) return;

    myUserProvider.user = fetchedUser;

    _didInitUser = true;
  }

  /// Clears the user.
  static void _clearUser(MyUserProvider myUserProvider) {
    myUserProvider.user = MyUser.empty();

    _didInitUser = false;
  }

  /// Initializes other things.
  static Future<void> _initOtherThings() async {
    if (_didInitOtherCustomThing) return;

    _didInitOtherCustomThing = true;
  }

  /// Clears other things.
  static void _clearOtherThings() {
    _didInitOtherCustomThing = false;
  }
}
