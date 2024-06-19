## 3.2.0 - June 19, 2024

- Added option for spacing in vertical lists.
- Added option for horizontal alignment in vertical lists.
- Added option for vertical spacing in horizontal lists.
- Added option for wrap alignment in horizontal lists.
- Breaking change: Upgraded from `MaterialState` to `WidgetState` with properties and colors.
- Behavior change: If a value is changed programmatically, the `onChanged` function is called (if one was provided).

## 3.1.1 - May 5, 2024

- Added `selectedIndex` getter so you can get the index of the currently selected item.

## 3.1.0 - February 20, 2024

- Fixed issue of `MultipleRadioGroupException` being thrown when parent rebuilds.
  - For best results, include `key` or `controller` when creating a new `RadioGroup`.

## 3.0.1 - February 9, 2024

- Fixed issue tracker link

## 3.0.0 - January 23, 2024

- Reorganized file structure
- Added `labelBuilder`
- Breaking change: Added generic typing. This will break radio groups that have multiple data types in one value list.

## 2.1.3 - September 27, 2023

- Documentation updates

## 2.1.2 - April 7, 2023

- Documentation updates

## 2.1.1 - February 27, 2023

- Fixed bug that caused issue with parent state changes

## 2.1.0 - February 24, 2023

- Lowered Dart SDK requirement
- Lowered Flutter SDK requirement

## 2.0.0 - February 23, 2023

- Major update fixing lots of bugs

## 1.0.2 - October 12, 2021

- Minor dart doc edits

## 1.0.1 - September 25, 2021

- Minor formatting adjustment

## 1.0.0 - September 24, 2021

- Initial release
