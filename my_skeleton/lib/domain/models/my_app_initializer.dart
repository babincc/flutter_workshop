import 'package:flutter/material.dart';
import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:my_skeleton/domain/repos/my_user_repo.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_user_provider.dart';

class MyAppInitializer {
  MyAppInitializer({this.fetchUser = MyUserRepo.fetchUser});

  final Future<MyUser?> Function(String) fetchUser;
  Future<bool>? _initialization;
  String? _userId;
  int _generation = 0;

  Future<bool> initApp(BuildContext context) {
    final MyAuthProvider myAuthProvider = MyAuthProvider.of(context);
    final MyUserProvider myUserProvider = MyUserProvider.of(context);
    return initialize(myAuthProvider.user?.id, myUserProvider);
  }

  Future<bool> initialize(String? userId, MyUserProvider myUserProvider) {
    if (_initialization != null && _userId == userId) return _initialization!;

    _userId = userId;

    final int generation = ++_generation;

    _initialization = _initialize(userId, myUserProvider, generation);

    return _initialization!;
  }

  Future<bool> _initialize(
    String? userId,
    MyUserProvider myUserProvider,
    int generation,
  ) async {
    // Defer notifications until after the widget build that starts this work.
    await Future<void>.value();

    if (generation != _generation) return false;

    myUserProvider.user = MyUser.empty();

    if (userId == null) return true;

    final user = await fetchUser(userId);

    if (generation != _generation) return false;

    if (user == null) return false;

    myUserProvider.user = user;

    return true;
  }

  void retry() {
    _initialization = null;
  }

  void dispose() {
    ++_generation;
  }
}
