import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/location_option.dart';


class ComposerLocationRow extends StatelessWidget {
  const ComposerLocationRow({
    super.key,
    required this.location,
    required this.onClear,
  });

  final LocationOption location;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.s,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: AppSpacing.iconLocation,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              location.displayLabel,
              style: AppTypography.locationLabel,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: const Icon(
              Icons.close,
              size: AppSpacing.iconLocation,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
