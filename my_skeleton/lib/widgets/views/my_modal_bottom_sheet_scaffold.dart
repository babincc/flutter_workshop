import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/strings/strings.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/providers/my_string_provider.dart';

class MyModalBottomSheetScaffold extends StatelessWidget {
  /// Creates a custom foundation for a modal bottom sheet.
  ///
  /// This "scaffold" is a group of foundational widgets, put together to
  /// eliminate boilerplate and make the code cleaner. Since almost every modal
  /// bottom sheet in this app is built with these at their core, it has been
  /// placed in one convenient widget.
  ///
  /// [FractionallySizedBox] > [Padding]
  const MyModalBottomSheetScaffold({
    super.key,
    this.heightFactor = 0.93,
    this.isDragToDismiss = true,
    this.title,
    required this.child,
    this.isCentered = true,
    this.onRightActionBtn,
    this.rightActionBtn,
    this.onLeftActionBtn,
    this.leftActionBtn,
  })  : assert(heightFactor >= 0.0 && heightFactor <= 1.0,
            'ERROR: `heightFactor` must be between 0.0 - 1.0 (inclusive).'),
        assert(
            isDragToDismiss
                ? onRightActionBtn == null
                : onRightActionBtn != null,
            'ERROR: If `isDragToDismiss` is `true`, `onRightActionBtn` must be '
            '`null`! If `isDragToDismiss` is `false`, `onRightActionBtn` must '
            'not be `null`!'),
        assert(
            isDragToDismiss ? onLeftActionBtn == null : true,
            'ERROR: If `isDragToDismiss` is `true`, `onLeftActionBtn` must be '
            '`null`!'),
        assert(rightActionBtn != null ? onRightActionBtn != null : true,
            'ERROR: `onRightActionBtn` must not be `null`!'),
        assert(leftActionBtn != null ? onLeftActionBtn != null : true,
            'ERROR: `onLeftActionBtn` must not be `null`!');

  /// How much of the screen the modal bottom sheet covers.
  ///
  /// This is a number from 0.0 - 1.0 (inclusive).
  final double heightFactor;

  /// Whether or not the modal bottom sheet can be dismissed by swiping it
  /// closed, or if it needs a cancel button.
  final bool isDragToDismiss;

  /// Text directly at the top of the modal bottom sheet.
  final String? title;

  /// The main body of the modal bottom sheet.
  final Widget child;

  /// Whether or not the content is placed in the center of the modal bottom
  /// sheet.
  final bool isCentered;

  /// Called when the user clicks the right hand side action button.
  ///
  /// Only used when [isDragToDismiss] is `false`.
  final VoidCallback? onRightActionBtn;

  /// The contents of the action button on the right.
  ///
  /// Defaults to "Cancel".
  ///
  /// Only used when [onRightActionBtn] is not `null`.
  final Widget? rightActionBtn;

  /// Called when the user clicks the left hand side action button.
  ///
  /// Only used when [isDragToDismiss] is `false`.
  final VoidCallback? onLeftActionBtn;

  /// The contents of the action button on the left.
  ///
  /// Defaults to "< Back".
  ///
  /// Only used when [onLeftActionBtn] is not `null`.
  final Widget? leftActionBtn;

  @override
  Widget build(BuildContext context) {
    Strings strings = MyStringProvider.of(context).strings;

    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          MyMeasurements.distanceFromEdge,
          MyMeasurements.elementSpread,
          MyMeasurements.distanceFromEdge,
          MyMeasurements.distanceFromEdge,
        ),
        child: Column(
          children: [
            // RESIZE BAR
            if (isDragToDismiss)
              Container(
                height: 5.0,
                width: 60.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(999.0),
                ),
              ),

            // TOP buttons
            if (!isDragToDismiss)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (onLeftActionBtn == null) Container(),
                  if (onLeftActionBtn != null)
                    TextButton(
                      onPressed: onLeftActionBtn,
                      style: const ButtonStyle(
                        minimumSize: WidgetStatePropertyAll<Size>(Size.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding:
                            WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.zero),
                      ),
                      child: leftActionBtn ??
                          Row(children: [
                            Icon(
                              Icons.arrow_back_ios,
                              size: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.fontSize,
                            ),
                            Text(strings.back.capitalizeFirstLetter())
                          ]),
                    ),
                  if (onRightActionBtn != null)
                    TextButton(
                      onPressed: onRightActionBtn,
                      style: const ButtonStyle(
                        minimumSize: WidgetStatePropertyAll<Size>(Size.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding:
                            WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.zero),
                      ),
                      child: rightActionBtn ??
                          Text(strings.cancel.capitalizeFirstLetter()),
                    ),
                ],
              ),

            // TITLE
            if (title != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: MyMeasurements.elementSpread,
                ),
                child: Text(title!.capitalizeEachWord()),
              ),

            _buildChild(),
          ],
        ),
      ),
    );
  }

  /// Lays out the child widget based on [isCentered].
  Widget _buildChild() => isCentered ? Expanded(child: child) : child;
}
