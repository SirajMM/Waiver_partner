import 'package:intl/intl.dart';

extension StringExtension on String {
  String changeDateFormat({String? fromFormat, String? toFormat}) {
    try {
      if (this.isEmpty) {
        throw FormatException("Empty date string");
      }
      return DateFormat(toFormat ?? "yyyy-MM-dd")
          .format(DateFormat(fromFormat ?? "dd / MMM / yyyy").parse(this));
    } catch (e) {
      print("Error in changeDateFormat: $e");
      return this; // Or return a default value or message
    }
  }
}

extension DateTimeExtensions on DateTime {
  String changeDateFormat({String? format}) =>
      DateFormat(format ?? "yyyy-MM-dd").format(this);
}
