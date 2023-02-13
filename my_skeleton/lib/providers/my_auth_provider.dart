import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_skeleton/domain/repos/my_user_repo.dart';
import 'package:provider/provider.dart';

class MyAuthProvider extends ChangeNotifier {
  /// Creates an auth service that keeps track of and controls the user's access
  /// to Firebase.
  MyAuthProvider(this._firebaseAuth) {
    isLoggedIn = _firebaseAuth.currentUser != null;
  }

  /// The instance of the Firebase authentication object that controls the
  /// user's connection to Firebase.
  final FirebaseAuth _firebaseAuth;

  bool _isLoggedIn = false;

  /// Whether or not the current user is logged in.
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool value) {
    if (_isLoggedIn != value) {
      _isLoggedIn = value;
      notifyListeners();
    }
  }

  /// The currently logged in user.
  User? get user => _firebaseAuth.currentUser;

  /// Creates a Firebase account using the given `email` and `password`.
  ///
  /// Returns `null` if there are no errors; otherwise, it returns the error
  /// message.
  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) async {
          if (value.user == null) {
            isLoggedIn = false;
            return;
          }

          await MyUserRepo.createUserDoc(value.user!.uid);

          isLoggedIn = true;
        },
      );
    } on FirebaseAuthException catch (e) {
      return e.code;
    }

    return null;
  }

  /// Logs the user into their Firebase account using the given `email` and
  /// `password`.
  ///
  /// Returns `null` if there are no errors; otherwise, it returns the error
  /// message.
  Future<String?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => isLoggedIn = value.user != null);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }

    return null;
  }

  /// Logs the user out of their Firebase account.
  Future<void> logOut() async {
    await _firebaseAuth.signOut().then((_) => isLoggedIn = false);
  }

  /// Sends a password reset link to the user's `email`.
  ///
  /// Returns `null` if there are no errors; otherwise, it returns the error
  /// message.
  Future<String?> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }

    return null;
  }

  static MyAuthProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<MyAuthProvider>(context, listen: listen);
}
