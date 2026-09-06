import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/error/failure.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../stories/presentation/widgets/stories_rail.dart';
import '../data/feed_repository.dart';
import 'cubit/feed_cubit.dart';
import 'cubit/feed_state.dart';
import 'widgets/post_card.dart';
import 'widgets/post_card_skeleton.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FeedCubit(FeedRepository(DioClient()))..loadInitial(),
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
        body: const Column(
          children: [
            StoriesRail(),
            StoriesRailDivider(),
            Expanded(child: _FeedBody()),
          ],
        ),
      ),
    );
  }
}

/// Owns the scroll controller that drives lazy pagination — purely
/// ephemeral UI wiring, not feed state, so a `StatefulWidget` is correct
/// here per the project's Cubit-for-state rule.
class _FeedBody extends StatefulWidget {
  const _FeedBody();

  @override
  State<_FeedBody> createState() => _FeedBodyState();
}

class _FeedBodyState extends State<_FeedBody> {
  static const double _loadMoreLead = 600;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreLead) {
      context.read<FeedCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedCubit, FeedState>(
      listenWhen: (previous, current) => current.actionFailure != null,
      listener: (context, state) {
        final failure = state.actionFailure!;
        final postId = state.actionFailurePostId;
        final cubit = context.read<FeedCubit>();
        cubit.clearActionFailure();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.userMessage),
            action: (failure.retryable && postId != null)
                ? SnackBarAction(
                    label: 'Retry',
                    onPressed: () => cubit.toggleLike(postId),
                  )
                : null,
          ),
        );
      },
      child: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) {
          return switch (state.status) {
            FeedStatus.initial ||
            FeedStatus.loading =>
              const FeedSkeletonList(),
            FeedStatus.failure => _FeedFailureView(
                failure: state.failure!,
                onRetry: () => context.read<FeedCubit>().loadInitial(),
              ),
            FeedStatus.success => RefreshIndicator(
                onRefresh: () => context.read<FeedCubit>().refresh(),
                child: state.posts.isEmpty
                    ? const _EmptyFeedView()
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: state.posts.length + 1,
                        itemBuilder: (context, index) {
                          if (index < state.posts.length) {
                            return PostCard(post: state.posts[index]);
                          }
                          return _FeedFooter(state: state);
                        },
                      ),
              ),
          };
        },
      ),
    );
  }
}

class _FeedFailureView extends StatelessWidget {
  const _FeedFailureView({required this.failure, required this.onRetry});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              failure.userMessage,
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
            if (failure.retryable) ...[
              const SizedBox(height: AppSpacing.l),
              OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyFeedView extends StatelessWidget {
  const _EmptyFeedView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: AppSpacing.xxl),
        Center(
          child: Text('Nothing here yet', style: AppTypography.body),
        ),
      ],
    );
  }
}

class _FeedFooter extends StatelessWidget {
  const _FeedFooter({required this.state});

  final FeedState state;

  @override
  Widget build(BuildContext context) {
    if (state.loadMoreFailure != null) {
      final failure = state.loadMoreFailure!;
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          children: [
            Text(
              failure.userMessage,
              style: AppTypography.metaLine,
              textAlign: TextAlign.center,
            ),
            if (failure.retryable) ...[
              const SizedBox(height: AppSpacing.s),
              OutlinedButton(
                onPressed: () => context.read<FeedCubit>().retryLoadMore(),
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      );
    }

    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.l),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (!state.hasMore && state.posts.isNotEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.l),
        child: Center(
          child: Text(
            "You're all caught up",
            style: AppTypography.metaLine,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
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
