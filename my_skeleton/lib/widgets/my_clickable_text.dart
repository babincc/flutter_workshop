import 'package:flutter/material.dart';

class MyClickableText extends StatelessWidget {
  const MyClickableText({Key? key, this.onTap, required this.text})
      : super(key: key);

  final void Function()? onTap;

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(text,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            decoration: TextDecoration.underline,
          )),
    );
  }
}
