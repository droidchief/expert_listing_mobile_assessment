import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';

const int _counterThreshold = 4500;

/// Matches the feed's composer prompt: an avatar beside a multiline field.
class ComposerBodyField extends StatelessWidget {
  const ComposerBodyField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.bodyLength,
    required this.maxLength,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final int bodyLength;
  final int maxLength;

  static const String _currentUserAvatarUrl =
      'https://i.pravatar.cc/150?u=miracle.h';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppAvatar(
            size: AppSpacing.avatarPost,
            url: _currentUserAvatarUrl,
            name: 'Miracle H',
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: true,
                  minLines: 3,
                  maxLines: 12,
                  maxLength: maxLength,
                  style: AppTypography.body,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText:
                        'Share a property, make a request or say something…',
                    hintStyle: AppTypography.body
                        .copyWith(color: AppColors.textSecondary),
                    border: InputBorder.none,
                    isDense: true,
                    counterText: '',
                  ),
                  onChanged: onChanged,
                ),
                if (bodyLength > _counterThreshold)
                  Text(
                    '$bodyLength / $maxLength',
                    style: AppTypography.metaLine,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
