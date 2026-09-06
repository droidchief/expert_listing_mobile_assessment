import 'package:intl/intl.dart';

/// Formats a UTC [dateTime] relative to now, matching the design:
/// `Just Now`, `5m`, `2h`, `3d`, `2w`, or a `12 Mar` date beyond that
/// (with the year appended if it falls in a different calendar year).
String relativeTime(DateTime dateTime, {DateTime? now}) {
  final DateTime reference = now ?? DateTime.now();
  final Duration diff = reference.toUtc().difference(dateTime.toUtc());

  if (diff.inSeconds < 60) return 'Just Now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  if (diff.inDays < 7) return '${diff.inDays}d';
  if (diff.inDays < 35) return '${diff.inDays ~/ 7}w';

  final DateTime local = dateTime.toUtc();
  final String formatted = DateFormat('d MMM').format(local);
  final DateTime referenceUtc = reference.toUtc();
  if (local.year != referenceUtc.year) {
    return '$formatted ${local.year}';
  }
  return formatted;
}
