import 'package:intl/intl.dart';

class MyDatePickerViewModel {
  MyDatePickerViewModel({
    DateTime? initialDate,
  }) : selectedDate = initialDate ?? DateTime.now();

  DateTime selectedDate;
}

extension DateFormatter on DateTime {
  String toFormattedString() {
    return DateFormat('MMMM dd, y').format(this);
  }
}
