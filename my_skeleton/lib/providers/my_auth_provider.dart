import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:my_skeleton/constants/defaults.dart';
import 'package:my_skeleton/utils/debug_log.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyAuthProvider extends ChangeNotifier {
  /// Creates an auth service that keeps track of and controls the user's access
  /// to Supabase.
  MyAuthProvider() : lastEmailSentTime = Defaults.dateTime {
    _userId = _supabaseAuth.currentUser?.id;
    isLoggedIn = _userId != null;

    _setUpAuthSub();
  }

  /// The instance of the Supabase authentication object that controls the
  /// user's connection to Supabase.
  final GoTrueClient _supabaseAuth = Supabase.instance.client.auth;

  bool _isLoggedIn = false;
  String? _userId;

  /// Whether or not the current user is logged in.
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool value) {
    if (_isLoggedIn != value) {
      _isLoggedIn = value;
      notifyListeners();
    }
  }

  bool _didSetUpAuthSub = false;

  late StreamSubscription<AuthState> _authSubscription;

  void _setUpAuthSub() {
    if (_didSetUpAuthSub) return;

    _didSetUpAuthSub = true;

    _authSubscription = _supabaseAuth.onAuthStateChange.listen(
      (data) {
        final previousUserId = _userId;
        _userId = data.session?.user.id;
        final AuthChangeEvent event = data.event;
        // final Session? session = data.session;

        switch (event) {
          case AuthChangeEvent.initialSession:
            isLoggedIn = data.session != null;
            break;
          case AuthChangeEvent.signedIn:
            isLoggedIn = true;
            break;
          case AuthChangeEvent.signedOut:
            isLoggedIn = false;
            break;
          case AuthChangeEvent.passwordRecovery:
            // handle password recovery
            break;
          case AuthChangeEvent.tokenRefreshed:
            // handle token refreshed
            break;
          case AuthChangeEvent.userUpdated:
            // handle user updated
            break;
          case AuthChangeEvent.mfaChallengeVerified:
            // handle mfa challenge verified
            break;
          default:
          // Do nothing
        }
        if (previousUserId != _userId) notifyListeners();
      },
      onError: (Object error, StackTrace stackTrace) {
        DebugLog.out(
          'MyAuthProvider',
          '_setUpAuthSub',
          'Auth stream error: $error',
          logType: LogType.error,
          sendToDatabase: true,
        );
      },
    );
  }

  /// Ends the stream subscription to the auth events.
  void endAuthSub() {
    if (!_didSetUpAuthSub) return;

    _didSetUpAuthSub = false;
    _authSubscription.cancel();
  }

  /// The currently logged in user.
  User? get user => _supabaseAuth.currentUser;

  /// This is the last email which an OTP was sent to.
  String? lastEmailSentAddress;

  /// The is the timestamp for the last time an email was sent to
  /// [lastEmailSentAddress].
  DateTime lastEmailSentTime;

  /// Sends the given `email` an OTP.
  ///
  /// Returns `null` if there are no errors; otherwise, it returns the error
  /// message.
  Future<String?> sendOtp(String email) async {
    try {
      await _supabaseAuth.signInWithOtp(email: email, shouldCreateUser: true);
      lastEmailSentAddress = email;
      lastEmailSentTime = DateTime.now();
    } catch (e) {
      return e.toString();
    }

    return null;
  }

  /// Logs the user in with the given `email` by verifying the OTP.
  ///
  /// Returns `null` if there are no errors; otherwise, it returns the error
  /// message.
  Future<String?> logIn({required String email, required String otp}) async {
    try {
      await _supabaseAuth.verifyOTP(
        type: OtpType.email,
        email: email,
        token: otp,
      );
    } catch (e) {
      return e.toString();
    }

    return null;
  }

  /// Logs the user out of their Supabase account.
  Future<void> logOut(BuildContext context) async {
    await _supabaseAuth.signOut();
  }

  /// Changes the credentials of the user to the new ones provided.
  Future<bool> changeCredentials({
    String? email,
    String? phone,
    String? nonce,
    Object? data,
  }) async {
    try {
      await _supabaseAuth.updateUser(
        UserAttributes(email: email, phone: phone, nonce: nonce, data: data),
      );
    } catch (e) {
      DebugLog.out(
        'MyAuthProvider',
        'changeCredentials',
        'Unexpected error $e',
        logType: LogType.error,
        sendToDatabase: true,
      );
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  static MyAuthProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<MyAuthProvider>(context, listen: listen);
}
