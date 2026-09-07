import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/media_draft.dart';

const double _thumbSize = AppSpacing.mediaThumb;

class MediaStrip extends StatelessWidget {
  const MediaStrip({
    super.key,
    required this.media,
    required this.canAddMore,
    required this.onAddTap,
    required this.onRemove,
    required this.onRetry,
  });

  final List<MediaDraft> media;
  final bool canAddMore;
  final VoidCallback onAddTap;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onRetry;

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty && !canAddMore) return const SizedBox.shrink();
    return SizedBox(
      height: _thumbSize,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
        ),
        children: [
          for (final draft in media) ...[
            _MediaThumb(
              draft: draft,
              onRemove: () => onRemove(draft.id),
              onRetry: () => onRetry(draft.id),
            ),
            const SizedBox(width: AppSpacing.s),
          ],
          if (canAddMore) _AddTile(onTap: onAddTap),
        ],
      ),
    );
  }
}

class _MediaThumb extends StatelessWidget {
  const _MediaThumb({
    required this.draft,
    required this.onRemove,
    required this.onRetry,
  });

  final MediaDraft draft;
  final VoidCallback onRemove;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final bool failed = draft.uploadState == MediaUploadState.failed;
    final bool uploading = draft.uploadState == MediaUploadState.uploading;

    return GestureDetector(
      onTap: failed ? onRetry : null,
      child: SizedBox(
        width: _thumbSize,
        height: _thumbSize,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.xs),
              child: Container(
                width: _thumbSize,
                height: _thumbSize,
                decoration: BoxDecoration(
                  border: failed
                      ? Border.all(color: AppColors.error, width: 1.5)
                      : null,
                ),
                child: Image.file(
                  File(draft.localPath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: AppColors.divider),
                ),
              ),
            ),
            if (uploading)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.overlayScrim.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppSpacing.xs),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: AppSpacing.iconAction,
                      height: AppSpacing.iconAction,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.overlayContent,
                        value: draft.progress > 0 ? draft.progress : null,
                      ),
                    ),
                  ),
                ),
              ),
            if (failed)
              const Positioned.fill(
                child: Center(
                  child: Icon(
                    Icons.refresh,
                    color: AppColors.error,
                  ),
                ),
              ),
            Positioned(
              top: AppSpacing.facepileOverlap,
              right: AppSpacing.facepileOverlap,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: AppSpacing.avatarFacepile,
                  height: AppSpacing.avatarFacepile,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.overlayScrim,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: AppSpacing.iconLocation,
                    color: AppColors.overlayContent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _thumbSize,
        height: _thumbSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.fieldBackground,
          borderRadius: BorderRadius.circular(AppSpacing.xs),
        ),
        child: const Icon(Icons.add, color: AppColors.textSecondary),
      ),
    );
  }
}
