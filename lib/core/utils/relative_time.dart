import 'package:intl/intl.dart';

String relativeTime(DateTime dateTime, {DateTime? now}) {
  final DateTime reference = now ?? DateTime.now();
  final Duration diff = reference.difference(dateTime);

  if (diff.inSeconds < 60) return 'Just Now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  if (diff.inDays < 7) return '${diff.inDays}d';
  if (diff.inDays < 35) return '${diff.inDays ~/ 7}w';

  final String formatted = DateFormat('d MMM').format(dateTime);
  if (dateTime.year != reference.year) {
    return '$formatted ${dateTime.year}';
  }
  return formatted;
}
