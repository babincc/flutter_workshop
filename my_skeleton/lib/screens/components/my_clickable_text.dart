import 'package:flutter/material.dart';
import 'package:my_skeleton/my_theme/my_colors.dart';

class MyClickableText extends StatelessWidget {
  const MyClickableText({
    Key? key,
    this.onTap,
    required this.text,
  }) : super(key: key);

  final void Function()? onTap;

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: (Theme.of(context).textTheme.bodyText2 ?? const TextStyle())
            .copyWith(
          color: MyColors.tertiary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
