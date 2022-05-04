import 'package:flutter/material.dart';
import 'package:my_skeleton/my_theme/my_theme.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    this.controller,
    this.decoration,
    this.isPassword = false,
  }) : super(key: key);

  final TextEditingController? controller;

  final InputDecoration? decoration;

  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyText2,
      decoration: decoration ??
          MyTheme.myInputDecoration(
            context,
            controller ?? TextEditingController(),
          ),
      obscureText: isPassword,
    );
  }
}
