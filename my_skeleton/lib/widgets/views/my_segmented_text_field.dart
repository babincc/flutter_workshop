import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_skeleton/constants/theme/my_colors.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/widgets/view_models/my_segmented_text_field_controller.dart';
import 'package:my_skeleton/widgets/views/my_text.dart';

class MySegmentedTextField extends StatefulWidget {
  MySegmentedTextField({
    super.key,
    required this.numFields,
    MySegmentedTextFieldController? controller,
  }) : controller = controller ?? MySegmentedTextFieldController();

  /// The number of text fields to include.
  final int numFields;

  final MySegmentedTextFieldController controller;

  /// This method allows the error text to be set manually from outside of this
  /// widget.
  static void setErrorText({
    required GlobalKey<MySegmentedTextFieldState> key,
    String? errorText,
  }) {
    if (key.currentState != null && key.currentState!.mounted) {
      key.currentState!.setErrorText(errorText);
    }
  }

  @override
  State<MySegmentedTextField> createState() => MySegmentedTextFieldState();
}

class MySegmentedTextFieldState extends State<MySegmentedTextField> {
  /// The message that will be displayed with this text field to let the user
  /// know their input is invalid.
  String? errorText;

  @override
  void initState() {
    super.initState();

    widget.controller.init(widget.numFields);

    for (int i = 0; i < widget.numFields; i++) {
      widget.controller.focusNodes[i].addListener(
        (() => widget.controller.handleFocusChange(i)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final MyColors colors = MyThemeProvider.of(context).colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // FORM FIELDS
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.numFields, (index) {
            return _buildField(context, index);
          }),
        ),

        // ERROR TEXT
        MyText(errorText ?? '', color: colors.error),
      ],
    );
  }

  Widget _buildField(BuildContext context, int index) {
    if (index < 0 || index >= widget.controller.controllers.length) {
      throw Exception(
        '$index is out of bounds for range 0-'
        '${widget.controller.controllers.length - 1}!',
      );
    }

    final FocusNode focusNode = widget.controller.focusNodes[index];
    final TextEditingController textEditingController =
        widget.controller.controllers[index];

    final bool isLast = index == widget.controller.controllers.length - 1;

    return Container(
      width: MyMeasurements.mySegmentedTextFieldWidth,
      margin: EdgeInsets.only(
        right: isLast ? 0.0 : MyMeasurements.elementSpread,
      ),
      child: TextField(
        controller: textEditingController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 0.0,
            vertical: MyMeasurements.textPadding,
          ),
        ),
        focusNode: focusNode,
        onChanged: (value) {
          // Handle paste (multiple digits pasted)
          if (value.length > 1) {
            final pasted = value.replaceAll(RegExp(r'[^0-9]'), '');

            if (pasted.length > 2) {
              widget.controller.text = pasted;
              FocusScope.of(context).unfocus();
              return;
            }

            // User typed over an existing digit
            value = pasted[pasted.length - 1];
          }

          // Handle delete
          if (value.isEmpty) {
            if (index > 0) {
              widget.controller.focusNodes[index - 1].requestFocus();
            }
            return;
          }

          // Replace existing digit with new one
          textEditingController.text = value;

          if (index + 1 < widget.controller.controllers.length) {
            widget.controller.focusNodes[index + 1].requestFocus();
          } else {
            focusNode.unfocus();
          }
        },
      ),
    );
  }

  /// This method allows the error text to be set manually from outside of this
  /// widget.
  void setErrorText(String? errorText) {
    if (mounted) {
      setState(() {
        this.errorText = errorText;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.dispose();

    super.dispose();
  }
}
