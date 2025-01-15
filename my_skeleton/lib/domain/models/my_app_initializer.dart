import 'package:flutter/material.dart';
import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:my_skeleton/domain/repos/my_user_repo.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_user_provider.dart';

class MyAppInitializer {
  /// Whether or not the app has been initialized.
  static bool get didInit => _didInitUser;

  /// Whether or not the user has been initialized.
  static bool _didInitUser = false;

  /// Initializes the app.
  static Future<bool> initApp(BuildContext context) async {
    // Skip if already initialized.
    if (didInit) return true;

    // Get providers before async.
    final MyAuthProvider myAuthProvider = MyAuthProvider.of(context);
    final MyUserProvider myUserProvider = MyUserProvider.of(context);

    // Initialize user.
    await _initUser(myAuthProvider, myUserProvider);

    return didInit;
  }

  /// Initializes the user.
  static Future<void> _initUser(
    MyAuthProvider myAuthProvider,
    MyUserProvider myUserProvider,
  ) async {
    if (_didInitUser) return;

    /// The user ID of the current user.
    final String? userId = myAuthProvider.user?.uid;

    // Skip if user ID is null.
    if (userId == null) return;

    // Fetch user data from Firestore.
    final MyUser? fetchedUser = await MyUserRepo.fetchUser(userId);

    // Skip if user is null.
    if (fetchedUser == null) return;

    myUserProvider.user = fetchedUser;

    _didInitUser = true;
  }
}
