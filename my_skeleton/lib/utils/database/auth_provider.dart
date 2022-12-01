import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  /// Creates an auth service that keeps track of and controls the user's access
  /// to Firebase.
  AuthProvider(this._firebaseAuth) {
    isLoggedIn = _firebaseAuth.currentUser != null;
  }

  /// The instance of the Firebase authentication object that controls the
  /// user's connection to Firebase.
  final FirebaseAuth _firebaseAuth;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool value) {
    if (_isLoggedIn != value) {
      _isLoggedIn = value;
      notifyListeners();
    }
  }

  /// Creates a Firebase account using the given `email` and `password`.
  ///
  /// Returns `null` if there are no errors; otherwise, it returns the error
  /// message.
  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      return e.message;
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
          .then((UserCredential value) => isLoggedIn = value.user != null);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }

    return null;
  }

  /// Logs the user out of their Firebase account.
  Future<void> logOut() async {
    await _firebaseAuth.signOut().then((value) => isLoggedIn = false);
  }

  static AuthProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<AuthProvider>(context, listen: listen);
}
