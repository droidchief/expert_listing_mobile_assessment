import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/chip_styles.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../data/models/post.dart';
import '../../domain/enums.dart';

/// Location pin + label, with an optional transaction chip trailing it.
/// Hidden entirely when the post has no `locationLabel`.
class PostLocationRow extends StatelessWidget {
  const PostLocationRow({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final String? locationLabel = post.locationLabel;
    if (locationLabel == null) return const SizedBox.shrink();

    final TransactionType? transactionType = post.transactionType;
    final ChipStyle? chipStyle =
        transactionType == null ? null : kChipStyles[transactionType.apiValue];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.xs,
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
              locationLabel,
              style: AppTypography.locationLabel,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (chipStyle != null && post.transactionLabel != null) ...[
            const SizedBox(width: AppSpacing.s),
            AppChip(
              label: post.transactionLabel!,
              style: chipStyle,
              icon: chipStyle.icon,
            ),
          ],
        ],
      ),
    );
  }
}
