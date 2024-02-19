import 'package:flutter/material.dart';
import 'package:my_skeleton/domain/models/my_user.dart';
import 'package:provider/provider.dart';

class MyUserProvider extends ChangeNotifier {
  /// Creates a new [MyUserProvider].
  MyUserProvider() : _myUser = MyUser.empty();

  /// The current user.
  MyUser _myUser;

  /// The current user.
  MyUser get myUser => _myUser;
  set myUser(MyUser value) {
    _myUser = value;
    notifyListeners();
  }

  static MyUserProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<MyUserProvider>(context, listen: listen);
}
