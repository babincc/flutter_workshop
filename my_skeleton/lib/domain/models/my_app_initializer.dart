import 'package:flutter/material.dart';
import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:my_skeleton/domain/repos/my_user_repo.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_user_provider.dart';
import 'package:my_skeleton/utils/my_file_explorer/my_file_explorer_provider.dart';

class MyAppInitializer {
  /// Whether or not the app has been initialized.
  static bool get didInit => _didInitFileExplorer && _didInitUser;

  /// Whether or not the file explorer has been initialized.
  static bool _didInitFileExplorer = false;

  /// Whether or not the user has been initialized.
  static bool _didInitUser = false;

  /// Initializes the app.
  static Future<bool> initApp(BuildContext context) async {
    // Skip if already initialized.
    if (didInit) return true;

    // Get providers before async.
    final MyFileExplorerProvider myFileExplorerProvider =
        MyFileExplorerProvider.of(context);
    final MyAuthProvider myAuthProvider = MyAuthProvider.of(context);
    final MyUserProvider myUserProvider = MyUserProvider.of(context);

    // Initialize basic elements.
    await _initFileExplorer(myFileExplorerProvider);

    // Initialize user.
    await _initUser(myAuthProvider, myUserProvider);

    return didInit;
  }

  /// Initializes the basic elements of the app.
  static Future<void> _initFileExplorer(
    MyFileExplorerProvider myFileExplorerProvider,
  ) async {
    if (_didInitFileExplorer) return;

    await myFileExplorerProvider.ensureInitialized();

    _didInitFileExplorer = true;
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
