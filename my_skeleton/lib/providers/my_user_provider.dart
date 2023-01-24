import 'package:flutter/material.dart';
import 'package:my_skeleton/models/my_user.dart';
import 'package:provider/provider.dart';

class MyUserProvider extends ChangeNotifier {
  MyUserProvider(this.myUser);

  MyUser myUser;

  static MyUserProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<MyUserProvider>(context, listen: listen);
}
