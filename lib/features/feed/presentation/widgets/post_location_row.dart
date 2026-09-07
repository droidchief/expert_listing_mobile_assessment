import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/post.dart';

/// Location pin + label. Rendered inside `PostHeader`'s name/meta column, so
/// it lines up under the post type/time line rather than the avatar.
/// Hidden entirely when the post has no `locationLabel`. The transaction
/// type (e.g. "For Sale") is shown as a badge on the media instead — see
/// `PostMediaView`.
class PostLocationRow extends StatelessWidget {
  const PostLocationRow({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final String? locationLabel = post.locationLabel;
    if (locationLabel == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: AppSpacing.iconLocation,
            color: AppColors.navIconInactive,
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              locationLabel,
              style: AppTypography.locationLabel,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
