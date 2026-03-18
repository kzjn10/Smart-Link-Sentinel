import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatDateTime({String pattern = 'HH:mm:ss MMM dd, yyyy'}) {
    try {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch,
      );
      return DateFormat(pattern).format(dateTime);
    } catch (_) {
      return '';
    }
  }
}
