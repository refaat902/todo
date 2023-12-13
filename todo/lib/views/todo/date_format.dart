import 'package:intl/intl.dart';

extension DateTimeFormat on DateTime {
  static nowDate() {
    return DateFormat.yMMMMd('en_us').format(
      DateTime.now(),
    );
  }
}
