import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/widgets/view_models/my_segmented_text_field_controller.dart';
import 'package:my_skeleton/widgets/views/my_text.dart';

class MySegmentedTextField extends StatefulWidget {
  const MySegmentedTextField({
    super.key,
    required this.numFields,
    this.controller,
  }) : assert(numFields > 0);

  /// The number of text fields to include.
  final int numFields;

  final MySegmentedTextFieldController? controller;

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

  late MySegmentedTextFieldController _controller;
  final Map<FocusNode, VoidCallback> _focusListeners = {};

  void _removeFocusListeners() {
    for (final entry in _focusListeners.entries) {
      entry.key.removeListener(entry.value);
    }
    _focusListeners.clear();
  }

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? MySegmentedTextFieldController();
    _initController();
  }

  void _initController() {
    _removeFocusListeners();
    _controller.init(widget.numFields);

    for (int i = 0; i < widget.numFields; i++) {
      void listener() => _controller.handleFocusChange(i);
      _focusListeners[_controller.focusNodes[i]] = listener;
      _controller.focusNodes[i].addListener(listener);
    }
  }

  @override
  void didUpdateWidget(covariant MySegmentedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _removeFocusListeners();
      if (oldWidget.controller == null) _controller.dispose();
      _controller = widget.controller ?? MySegmentedTextFieldController();
      _initController();
    } else if (oldWidget.numFields != widget.numFields) {
      _initController();
    }
  }

  @override
  Widget build(BuildContext context) {
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
        MyText(
          errorText ?? '',
          color: MyThemeProvider.of(context).colors.error,
        ),
      ],
    );
  }

  Widget _buildField(BuildContext context, int index) {
    if (index < 0 || index >= _controller.controllers.length) {
      throw Exception(
        '$index is out of bounds for range 0-'
        '${_controller.controllers.length - 1}!',
      );
    }

    final FocusNode focusNode = _controller.focusNodes[index];
    final TextEditingController textEditingController =
        _controller.controllers[index];

    final bool isLast = index == _controller.controllers.length - 1;

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
              _controller.text = pasted;
              FocusScope.of(context).unfocus();
              return;
            }

            // User typed over an existing digit
            value = pasted[pasted.length - 1];
          }

          // Handle delete
          if (value.isEmpty) {
            if (index > 0) {
              _controller.focusNodes[index - 1].requestFocus();
            }
            return;
          }

          // Replace existing digit with new one
          textEditingController.text = value;

          if (index + 1 < _controller.controllers.length) {
            _controller.focusNodes[index + 1].requestFocus();
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
    _removeFocusListeners();
    if (widget.controller == null) _controller.dispose();

    super.dispose();
  }
}
