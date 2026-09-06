import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Post body text, clamped to 6 lines with a "See more" toggle.
///
/// None of the design's posts are long enough to trigger the clamp, but the
/// API permits up to 5000 characters and an unclamped card would be
/// unusable — this is a documented assumption, not a design requirement.
///
/// Local ephemeral UI state (the toggle), so a `StatefulWidget` is correct
/// here per the M2 rules.
class PostBody extends StatefulWidget {
  const PostBody({super.key, required this.body});

  final String body;

  static const int _clampLines = 6;

  @override
  State<PostBody> createState() => _PostBodyState();
}

class _PostBodyState extends State<PostBody> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final span = TextSpan(text: widget.body, style: AppTypography.body);
          final painter = TextPainter(
            text: span,
            maxLines: PostBody._clampLines,
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
          )..layout(maxWidth: constraints.maxWidth);
          final bool isOverflowing = painter.didExceedMaxLines;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.body,
                style: AppTypography.body,
                maxLines: _expanded ? null : PostBody._clampLines,
                overflow:
                    _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              if (isOverflowing)
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      _expanded ? 'See less' : 'See more',
                      style: AppTypography.linkLabel,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
