import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                'assets/images/logo_green.svg',
                width: AppSpacing.iconNav,
                height: AppSpacing.iconNav,
              ),
              const SizedBox(width: AppSpacing.s),
              Text('Expert Listing', style: AppTypography.appTitle),
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/images/envelope.svg',
                width: AppSpacing.iconAction,
                height: AppSpacing.iconAction,
              ),
              onPressed: () {},
              tooltip: 'Messages',
            ),

             IconButton(
              icon: SvgPicture.asset(
                'assets/images/plus.svg',
                width: AppSpacing.iconAction,
                height: AppSpacing.iconAction,
              ),
              onPressed: () {},
              tooltip: 'Messages',
            ),
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
