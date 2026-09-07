import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';


class CommentsEmptyView extends StatelessWidget {
  const CommentsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.l),
            Text('No comments yet', style: AppTypography.displayName),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Be the first to share your thoughts.',
              style: AppTypography.metaLine,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
