import 'package:flutter/material.dart';
import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:provider/provider.dart';

class MyUserProvider extends ChangeNotifier {
  /// Creates a new [MyUserProvider].
  MyUserProvider() : _user = MyUser.empty();

  /// The current user.
  MyUser _user;

  /// The current user.
  MyUser get user => _user;
  set user(MyUser value) {
    _user = value;
    notifyListeners();
  }

  static MyUserProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<MyUserProvider>(context, listen: listen);
}
