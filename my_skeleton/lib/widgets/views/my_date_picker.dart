import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/widgets/view_models/my_date_picker_view_model.dart';

class MyDatePicker extends StatefulWidget {
  const MyDatePicker(this.viewModel, {super.key});

  final MyDatePickerViewModel viewModel;

  /// This method allows the error text to be set manually from outside of this
  /// widget.
  static void setErrorText({
    required GlobalKey<MyDatePickerState> key,
    String? errorText,
  }) {
    if (key.currentState != null && key.currentState!.mounted) {
      key.currentState!.setErrorText(errorText);
    }
  }

  @override
  State<MyDatePicker> createState() => MyDatePickerState();
}

class MyDatePickerState extends State<MyDatePicker> {
  /// The message that will be displayed with this field to let the user know
  /// their input is invalid.
  String? errorText;

  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(MyMeasurements.borderRadius),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              mouseCursor: WidgetStateMouseCursor.clickable,
              onHover: (value) => setState(() => isHovering = value),
              onTap: () async {
                final DateTime? issueDate = await showDatePicker(
                  context: context,
                  initialDate: widget.viewModel.selectedDate,
                  firstDate: DateTime(0, 1, 1),
                  lastDate: DateTime(99999, 12, 31),
                );

                if (issueDate == null) return;

                setState(() {
                  widget.viewModel.selectedDate = issueDate;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    MyMeasurements.borderRadius,
                  ),
                  color: isHovering
                      ? MyThemeProvider.of(context).colors.textFieldHover
                      : MyThemeProvider.of(context).colors.textField,
                ),
                padding: const EdgeInsets.all(MyMeasurements.elementSpread),
                child: Row(
                  children: [
                    Text(widget.viewModel.selectedDate.toFormattedString()),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ERROR MESSAGE
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(
              top: MyMeasurements.textPadding,
              left: MyMeasurements.elementSpread,
            ),
            child: Text(
              errorText!,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: MyThemeProvider.of(context).colors.error),
            ),
          ),
      ],
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
}
