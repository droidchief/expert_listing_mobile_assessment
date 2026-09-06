import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/number_format.dart';
import '../../domain/price_range_option.dart';

/// Reuses M1's `formatCount` abbreviation (₦5M, ₦850K) prefixed with the
/// naira sign — unlike a social count, a price of exactly zero is still a
/// meaningful value to show, so zero isn't hidden here the way
/// `formatCount` normally hides it.
String formatNaira(double value) {
  if (value <= 0) return '₦0';
  return '₦${formatCount(value.round())}';
}

class PriceRangeSection extends StatelessWidget {
  const PriceRangeSection({
    super.key,
    required this.priceRange,
    required this.values,
    required this.onChanged,
  });

  final PriceRangeOption priceRange;
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RangeSlider(
          min: priceRange.min,
          max: priceRange.max,
          values: values,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.fieldBackground,
          onChanged: onChanged,
        ),
        Text(
          '${formatNaira(values.start)} – ${formatNaira(values.end)}',
          style: AppTypography.metaLine,
        ),
      ],
    );
  }
}
