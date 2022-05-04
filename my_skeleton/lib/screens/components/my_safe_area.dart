import 'package:flutter/material.dart';
import 'package:my_skeleton/my_theme/my_spacing.dart';

class MySafeArea extends StatelessWidget {
  const MySafeArea({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(MySpacing.distanceFromEdge),
        child: child,
      ),
    );
  }
}
