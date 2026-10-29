import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime formatDate({String pattern = 'dd-MM-yyyy'}) {
    return DateFormat(pattern).parse(DateFormat(pattern).format(this));
  }
}

String formatDate(DateTime date, {String pattern = 'dd-MM-yyyy hh:mm a'}) {
  return DateFormat(pattern).format(date);
}
