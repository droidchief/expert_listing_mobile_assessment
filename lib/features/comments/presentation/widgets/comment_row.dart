import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/relative_time.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../data/models/comment.dart';
import '../../data/models/reply_preview.dart';
import '../cubit/comment_item.dart';

/// One root comment: avatar, name/time header, body, then its (read-only,
/// at most 2) replies indented beneath. No divider between rows —
/// whitespace separates them, matching the app's flat, hairline-only style.
class CommentRow extends StatelessWidget {
  const CommentRow({
    super.key,
    required this.item,
    required this.onRetry,
    required this.onDiscard,
  });

  final CommentItem item;
  final VoidCallback onRetry;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    final Comment comment = item.comment;
    final bool isPending = item.sendState == CommentSendState.pending;
    final bool isFailed = item.sendState == CommentSendState.failed;

    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(
                size: AppSpacing.avatarCommentRoot,
                url: comment.author.avatarUrl,
                name: comment.author.displayName,
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(
                      displayName: comment.author.displayName,
                      isVerified: comment.author.isVerified,
                      createdAt: isPending ? null : comment.createdAt,
                      isEdited: comment.isEdited,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(comment.body, style: AppTypography.body),
                    if (isFailed) ...[
                      const SizedBox(height: AppSpacing.xs),
                      _FailedRow(onRetry: onRetry, onDiscard: onDiscard),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (comment.repliesPreview.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s),
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.commentReplyIndent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final reply in comment.repliesPreview)
                    _ReplyRow(reply: reply),
                ],
              ),
            ),
          ],
        ],
      ),
    );

    if (!isPending) return content;
    return Opacity(opacity: 0.55, child: content);
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.displayName,
    required this.isVerified,
    required this.createdAt,
    required this.isEdited,
  });

  final String displayName;
  final bool isVerified;

  /// Null hides the timestamp — used for a pending (not-yet-sent) comment.
  final DateTime? createdAt;
  final bool isEdited;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: displayName, style: AppTypography.displayName),
          if (isVerified)
            const WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: AppSpacing.xs),
                child: Icon(Icons.verified, size: 14, color: AppColors.primary),
              ),
            ),
          if (createdAt != null) ...[
            TextSpan(
              text: ' · ${relativeTime(createdAt!.toLocal())}',
              style: AppTypography.metaLine,
            ),
            if (isEdited)
              TextSpan(text: ' · (edited)', style: AppTypography.metaLine),
          ],
        ],
      ),
    );
  }
}

class _FailedRow extends StatelessWidget {
  const _FailedRow({required this.onRetry, required this.onDiscard});

  final VoidCallback onRetry;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorDivider(),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Text(
              "Couldn't send",
              style: AppTypography.metaLine.copyWith(color: AppColors.error),
            ),
            const SizedBox(width: AppSpacing.m),
            GestureDetector(
              onTap: onRetry,
              child: Text('Retry', style: AppTypography.linkLabel),
            ),
            const SizedBox(width: AppSpacing.m),
            GestureDetector(
              onTap: onDiscard,
              child: Text('Discard', style: AppTypography.linkLabel),
            ),
          ],
        ),
      ],
    );
  }
}

class _ErrorDivider extends StatelessWidget {
  const _ErrorDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 32,
      height: 1,
      child: ColoredBox(color: AppColors.error),
    );
  }
}

class _ReplyRow extends StatelessWidget {
  const _ReplyRow({required this.reply});

  final ReplyPreview reply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAvatar(
            size: AppSpacing.avatarCommentReply,
            url: reply.author.avatarUrl,
            name: reply.author.displayName,
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: reply.author.displayName,
                        style: AppTypography.displayName,
                      ),
                      TextSpan(
                        text: ' · ${relativeTime(reply.createdAt.toLocal())}',
                        style: AppTypography.metaLine,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(reply.body, style: AppTypography.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
