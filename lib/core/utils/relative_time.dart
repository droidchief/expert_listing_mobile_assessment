import 'package:intl/intl.dart';

/// Formats [dateTime] relative to now, matching the design: `Just Now`,
/// `5m`, `2h`, `3d`, `2w`, or a `12 Mar` date beyond that (with the year
/// appended if it falls in a different calendar year).
///
/// The elapsed-time buckets are timezone-agnostic (they compare absolute
/// instants), but the date fallback formats [dateTime] using whatever
/// representation it carries — callers rendering to the viewer should pass
/// a value already converted with `.toLocal()`; model-stored UTC values
/// should not be passed here directly.
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
