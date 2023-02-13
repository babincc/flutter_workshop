import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText(
    this.data, {
    super.key,
    this.myTextStyle = MyTextStyle.body,
    this.color,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  }) : assert(myTextStyle == MyTextStyle.body || style == null,
            "ERROR: Either `myTextStyle` needs to be [MyTextStyle.body] OR `style` needs to be `null`!");

  /// [Text.data]
  final String data;

  /// A quick way to use preset text styles.
  final MyTextStyle myTextStyle;

  /// The color of the text.
  final Color? color;

  /// [Text.style]
  final TextStyle? style;

  /// [Text.strutStyle]
  final StrutStyle? strutStyle;

  /// [Text.textAlign]
  final TextAlign? textAlign;

  /// [Text.textDirection]
  final TextDirection? textDirection;

  /// [Text.locale]
  final Locale? locale;

  /// [Text.softWrap]
  final bool? softWrap;

  /// [Text.overflow]
  final TextOverflow? overflow;

  /// [Text.textScaleFactor]
  final double? textScaleFactor;

  /// [Text.maxLines]
  final int? maxLines;

  /// [Text.semanticsLabel]
  final String? semanticsLabel;

  /// [Text.textWidthBasis]
  final TextWidthBasis? textWidthBasis;

  /// [Text.textHeightBehavior]
  final TextHeightBehavior? textHeightBehavior;

  /// [Text.selectionColor]
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: (style ?? _getStyle(context))?.copyWith(color: color),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  TextStyle? _getStyle(BuildContext context) {
    switch (myTextStyle) {
      case MyTextStyle.title:
        return Theme.of(context).textTheme.headlineSmall;
      case MyTextStyle.header:
        return Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            );
      case MyTextStyle.caption:
        return Theme.of(context).textTheme.caption;
      case MyTextStyle.body:
      default:
        return Theme.of(context).textTheme.bodyText2;
    }
  }
}

/// Describes the style of this text object.
enum MyTextStyle {
  /// Normal text seen all throughout the app.
  body,

  /// The most bold and obvious text to denote a new topic.
  title,

  /// Bold and obvious text to denote a new sub-topic.
  header,

  /// The smallest text like fine print.
  caption,
}
