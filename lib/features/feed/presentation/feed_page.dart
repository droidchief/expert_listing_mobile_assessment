import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:go_router/go_router.dart';

import '../../../core/error/failure.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../filters/data/filters_repository.dart';
import '../../filters/domain/feed_filter.dart';
import '../../filters/presentation/cubit/feed_filter_cubit.dart';
import '../../filters/presentation/cubit/filter_options_cubit.dart';
import '../../filters/presentation/widgets/active_filters_bar.dart';
import '../../filters/presentation/widgets/filters_button.dart';
import '../../filters/presentation/widgets/filters_sheet.dart';
import '../../stories/presentation/cubit/stories_cubit.dart';
import '../../stories/presentation/widgets/stories_rail.dart';
import 'cubit/feed_cubit.dart';
import 'cubit/feed_state.dart';
import 'widgets/post_card.dart';
import 'widgets/post_card_skeleton.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FeedFilterCubit()),
        BlocProvider(
          create: (context) =>
              FilterOptionsCubit(FiltersRepository(DioClient()))..load(),
        ),
      ],
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
              onTap: () => context.push(AppRoutes.composer),
            ),
            const SizedBox(width: AppSpacing.s),
          ],
        ),
        body: const Column(
          children: [
            StoriesRail(),
            SizedBox(height: AppSpacing.s),
            Expanded(child: _FeedBody()),
          ],
        ),
      ),
    );
  }
}

class _ComposerPromptRow extends StatelessWidget {
  const _ComposerPromptRow();

  static const String _currentUserAvatarUrl =
      'https://i.pravatar.cc/150?u=miracle.h';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.composer),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: AppSpacing.m,
              ),
              decoration: BoxDecoration(
                color: AppColors.overlayScrim.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
              child: Row(
                children: [
                  const AppAvatar(
                    size: AppSpacing.avatarPost,
                    url: _currentUserAvatarUrl,
                    name: 'Miracle H',
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Expanded(
                    child: Text(
                      'Share a property, request or say something…',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.m),

            Container(
              height: 2,
              width: double.infinity,
              color: AppColors.divider,
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltersRow extends StatelessWidget {
  const _FiltersRow();

  @override
  Widget build(BuildContext context) {
    final int activeCount = context.watch<FeedFilterCubit>().state.activeCount;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.s,
            ),
            child: Row(
              children: [
                FiltersButton(
                  activeCount: activeCount,
                  onTap: () => showFiltersSheet(context),
                ),
                const SizedBox(width: AppSpacing.s),
                const _TrendingSearchesButton(),
              ],
            ),
          ),
          const ActiveFiltersBar(),
        ],
      ),
    );
  }
}

class _TrendingSearchesButton extends StatelessWidget {
  const _TrendingSearchesButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.trending_up, size: 16, color: AppColors.primaryText),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Trending Searches',
            style: AppTypography.metaLine.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondaryDarker,
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyFiltersHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _StickyFiltersHeaderDelegate({required this.hasActiveFilters});

  final bool hasActiveFilters;

  static const double _baseHeight = 58;
  static const double _activeFiltersHeight = 44;

  @override
  double get minExtent =>
      _baseHeight + (hasActiveFilters ? _activeFiltersHeight : 0);

  @override
  double get maxExtent => minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return const DecoratedBox(
      decoration: BoxDecoration(color: AppColors.surface),
      child: _FiltersRow(),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyFiltersHeaderDelegate oldDelegate) =>
      oldDelegate.hasActiveFilters != hasActiveFilters;
}

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
    return MultiBlocListener(
      listeners: [
        BlocListener<FeedCubit, FeedState>(
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
        ),

        BlocListener<FeedFilterCubit, FeedFilter>(
          listener: (context, filter) {
            context.read<FeedCubit>().applyFilter(filter);
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(0);
            }
          },
        ),

        
        BlocListener<FeedCubit, FeedState>(
          listenWhen: (previous, current) =>
              previous.status != FeedStatus.success &&
              current.status == FeedStatus.success,
          listener: (context, state) {
            context.read<StoriesCubit>().addGuestGroupsFromPosts(state.posts);
          },
        ),
      ],

      child: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) {
          final int activeFilterCount = context
              .watch<FeedFilterCubit>()
              .state
              .activeCount;
          return RefreshIndicator(
            onRefresh: () => context.read<FeedCubit>().refresh(),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyFiltersHeaderDelegate(
                    hasActiveFilters: activeFilterCount > 0,
                  ),
                ),
                const SliverToBoxAdapter(child: _ComposerPromptRow()),
                ...switch (state.status) {
                  FeedStatus.initial || FeedStatus.loading => [
                    const SliverFillRemaining(
                      hasScrollBody: true,
                      child: FeedSkeletonList(),
                    ),
                  ],
                  FeedStatus.failure => [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _FeedFailureView(
                        failure: state.failure!,
                        onRetry: () => context.read<FeedCubit>().loadInitial(),
                      ),
                    ),
                  ],

                  FeedStatus.success =>
                    state.posts.isEmpty
                        ? [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child:
                                  context
                                      .watch<FeedFilterCubit>()
                                      .state
                                      .isActive
                                  ? _FilteredEmptyView(
                                      onClear: () => context
                                          .read<FeedFilterCubit>()
                                          .clear(),
                                    )
                                  : const _EmptyFeedView(),
                            ),
                          ]
                        : [
                            SliverList.builder(
                              itemCount: state.posts.length + 1,
                              itemBuilder: (context, index) {
                                if (index < state.posts.length) {
                                  return PostCard(post: state.posts[index]);
                                }
                                return _FeedFooter(state: state);
                              },
                            ),
                          ],
                },
              ],
            ),
          );
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
    return const Center(
      child: Text('Nothing here yet', style: AppTypography.body),
    );
  }
}

class _FilteredEmptyView extends StatelessWidget {
  const _FilteredEmptyView({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No posts match these filters',
            style: AppTypography.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.l),
          OutlinedButton(
            onPressed: onClear,
            child: const Text('Clear filters'),
          ),
        ],
      ),
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
      return Container(
        color: AppColors.divider,
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: Text("You're all caught up", style: AppTypography.metaLine),
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
