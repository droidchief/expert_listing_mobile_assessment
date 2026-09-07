import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class StoryProgressBars extends StatelessWidget {
  const StoryProgressBars({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.progress,
  });

  final int count;
  final int currentIndex;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.xs),
              child: SizedBox(
                height: AppSpacing.xs / 2,
                child: LinearProgressIndicator(
                  value: i < currentIndex
                      ? 1
                      : i == currentIndex
                          ? progress
                          : 0,
                  backgroundColor: AppColors.overlayScrim.withValues(
                    alpha: 0.3,
                  ),
                  valueColor: AlwaysStoppedAnimation(
                    AppColors.overlayContent.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
