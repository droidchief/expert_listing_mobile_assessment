import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'cubit/feed_preview_cubit.dart';
import 'cubit/feed_preview_state.dart';
import 'widgets/post_card.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedPreviewCubit()..loadDesignPosts(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/logo_with_name.svg',
                width: AppSpacing.iconAction,
                height: AppSpacing.iconAction,
              ),
              const SizedBox(width: AppSpacing.s),
            ],
          ),
          centerTitle: false,
          actions: [
            _CircularActionButton(
              assetPath: 'assets/images/envelope.svg',
              tooltip: 'Messages',
              onTap: () {},
            ),
            _CircularActionButton(
              assetPath: 'assets/images/plus.svg',
              tooltip: 'Add',
              onTap: () {},
            ),
            
              const SizedBox(width: AppSpacing.s),

          ],
        ),
        body: BlocBuilder<FeedPreviewCubit, FeedPreviewState>(
          builder: (context, state) {
            return switch (state.status) {
              FeedPreviewStatus.initial ||
              FeedPreviewStatus.loading =>
                const Center(child: CircularProgressIndicator()),
              FeedPreviewStatus.failure => Center(
                  child: Text(state.failureMessage ?? 'Failed to load posts'),
                ),
              FeedPreviewStatus.success => ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) =>
                      PostCard(post: state.posts[index]),
                ),
            };
          },
        ),
      ),
    );
  }
}

class _CircularActionButton extends StatelessWidget {
  const _CircularActionButton({
    required this.assetPath,
    required this.tooltip,
    required this.onTap,
  });

  final String assetPath;
  final String tooltip;
  final VoidCallback onTap;

  static const double _size = 46;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: _size,
            height: _size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
              color: AppColors.overlayScrim.withValues(alpha: 0.02),
            ),
            child: SvgPicture.asset(
              assetPath,
              width: AppSpacing.iconAction,
              height: AppSpacing.iconAction,
            ),
          ),
        ),
      ),
    );
  }
}
