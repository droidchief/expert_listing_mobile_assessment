String formatCount(int value) {
  if (value <= 0) return '';
  if (value < 1000) return value.toString();

  final double thousands = value / 1000;
  if (thousands < 1000) return '${_trimmed(thousands)}K';

  final double millions = value / 1000000;
  return '${_trimmed(millions)}M';
}

String _trimmed(double value) {
  final String rounded = value.toStringAsFixed(1);
  return rounded.endsWith('.0')
      ? rounded.substring(0, rounded.length - 2)
      : rounded;
}
