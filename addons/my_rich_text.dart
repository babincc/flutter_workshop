// @author Christian Babin
// @version 0.1.0
// https://github.com/babincc/flutter_workshop/blob/master/addons/my_rich_text.dart

import 'package:flutter/material.dart';

class MyRichText extends StatelessWidget {
  /// A widget that displays rich text with the ability to emphasize text.
  ///
  /// How to use it:
  ///
  /// ```dart
  /// MyRichText(
  ///   style: TextStyle(fontWeight: FontWeight.bold),
  ///   children: [
  ///     MyNormalText('Hello, '),
  ///     MyEmphasizedText('world'),
  ///     MyNormalText('!'),
  ///   ],
  /// )
  /// ```
  ///
  /// This will display "Hello, **world**!" with "world" being the emphasized
  /// text, thus it takes on the characteristics of the provided style (in this
  /// case, bold).
  const MyRichText({
    super.key,
    required this.children,
    this.style,
    this.textAlign,
  });

  /// Each piece of text to display.
  ///
  /// The order in which they are provided is the order in which they will be
  /// displayed.
  ///
  /// To display normal text, use [MyNormalText].
  ///
  /// To emphasize text, use [MyEmphasizedText]. The style provided to this
  /// widget will be applied to the emphasized text.
  final List<MyRichTextContent> children;

  /// The style to apply to the emphasized text.
  final TextStyle? style;

  /// The alignment of the text.
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> spans = children.map((child) {
      if (child is MyEmphasizedText) {
        return TextSpan(
          text: child.text,
          style: style,
        );
      } else {
        return TextSpan(text: child.text);
      }
    }).toList();

    return Text.rich(
      TextSpan(
        children: spans,
      ),
      textAlign: textAlign,
    );
  }
}

abstract class MyRichTextContent {
  const MyRichTextContent(this.text);

  final String text;
}

class MyNormalText extends MyRichTextContent {
  const MyNormalText(super.text);
}

class MyEmphasizedText extends MyRichTextContent {
  const MyEmphasizedText(super.text);
}
