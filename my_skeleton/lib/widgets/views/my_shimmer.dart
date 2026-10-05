import 'package:flutter/material.dart';
import 'package:material_ui/material_ui.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:shimmer/shimmer.dart';

class MyShimmer extends StatelessWidget {
  const MyShimmer({
    super.key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  /// The width of the shimmer effect.
  final double width;

  /// The height of the shimmer effect.
  final double height;

  /// The border radius of the shimmer effect.
  final BorderRadiusGeometry? borderRadius;

  /// The background color of the shimmer effect.
  final Color? baseColor;

  /// The highlight color of the shimmer effect.
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    /// The background color of the shimmer effect.
    Color actualBaseColor =
        baseColor ?? MyThemeProvider.of(context).colors.container;

    return Shimmer.fromColors(
      baseColor: actualBaseColor,
      highlightColor:
          highlightColor ??
          MyThemeProvider.of(context).colors.onContainer.withValues(alpha: 0.1),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: actualBaseColor,
          borderRadius:
              borderRadius ??
              BorderRadius.circular(MyMeasurements.borderRadius),
        ),
      ),
    );
  }
}
