import 'package:flutter/material.dart';

import '../theme/app_typography.dart';
import '../utils/number_format.dart';

class CountText extends StatelessWidget {
  const CountText(this.count, {super.key, this.style});

  final int count;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final String formatted = formatCount(count);
    if (formatted.isEmpty) return const SizedBox.shrink();
    return Text(formatted, style: style ?? AppTypography.countLabel);
  }
}
