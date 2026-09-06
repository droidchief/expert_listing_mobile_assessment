import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/comments_repository.dart';
import '../cubit/comments_cubit.dart';
import '../cubit/comments_state.dart';
import 'comment_input_bar.dart';
import 'comment_row.dart';
import 'comments_empty_view.dart';
import 'comments_skeleton.dart';

/// Opens the draggable comments sheet for [postId]. [onCommentCountChanged]
/// is called with the post's new total after a successful send, so the
/// caller can push it into `FeedCubit` — the sheet's own `CommentsCubit`
/// has no reach into the feed's provider tree (a modal sheet is a sibling
/// route on the navigator, not a descendant of the page that opened it).
Future<void> showCommentsSheet(
  BuildContext context, {
  required String postId,
  required int initialCommentCount,
  required void Function(int newCommentCount) onCommentCountChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CommentsSheet(
      postId: postId,
      initialCommentCount: initialCommentCount,
      onCommentCountChanged: onCommentCountChanged,
    ),
  );
}

class CommentsSheet extends StatefulWidget {
  const CommentsSheet({
    super.key,
    required this.postId,
    required this.initialCommentCount,
    required this.onCommentCountChanged,
  });

  final String postId;
  final int initialCommentCount;
  final void Function(int newCommentCount) onCommentCountChanged;

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  late final DraggableScrollableController _sheetController;
  late final CommentsCubit _cubit;
  late int _commentCount;

  @override
  void initState() {
    super.initState();
    _commentCount = widget.initialCommentCount;
    _sheetController = DraggableScrollableController();
    _cubit = CommentsCubit(
      postId: widget.postId,
      repository: CommentsRepository(DioClient()),
      onCommentCountChanged: (count) {
        setState(() => _commentCount = count);
        widget.onCommentCountChanged(count);
      },
    )..load();
  }

  @override
  void dispose() {
    _sheetController.dispose();
    unawaited(_cubit.close());
    super.dispose();
  }

  // A DraggableScrollableSheet clamps its own extent at minChildSize rather
  // than reporting anything below it, and — nested inside a modal bottom
  // sheet — it captures the drag gesture for its own resizing rather than
  // letting the route's drag-to-dismiss see it. So "drag below min to
  // dismiss" is driven explicitly: once the sheet has settled somewhere
  // above the floor, sliding back down to that floor pops the route. The
  // `_reachedAboveMin` guard exists so the opening animation (which grows
  // the sheet up *through* minExtent on its way to initialChildSize) never
  // gets mistaken for the user dragging back down to it.
  bool _reachedAboveMin = false;

  bool _onSheetNotification(DraggableScrollableNotification notification) {
    const double epsilon = 0.01;
    if (notification.extent > notification.minExtent + epsilon) {
      _reachedAboveMin = true;
    } else if (_reachedAboveMin &&
        notification.extent <= notification.minExtent + epsilon) {
      Navigator.of(context).maybePop();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: _onSheetNotification,
        child: DraggableScrollableSheet(
          controller: _sheetController,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          snap: true,
          snapSizes: const [0.6, 0.9],
          expand: false,
          builder: (context, scrollController) => _SheetContent(
            commentCount: _commentCount,
            listController: scrollController,
            sheetController: _sheetController,
          ),
        ),
      ),
    );
  }
}

class _SheetContent extends StatefulWidget {
  const _SheetContent({
    required this.commentCount,
    required this.listController,
    required this.sheetController,
  });

  final int commentCount;
  final ScrollController listController;
  final DraggableScrollableController sheetController;

  static const double _loadMoreLead = 400;

  @override
  State<_SheetContent> createState() => _SheetContentState();
}

class _SheetContentState extends State<_SheetContent> {
  @override
  void initState() {
    super.initState();
    widget.listController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.listController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.listController.hasClients) return;
    final position = widget.listController.position;
    if (position.pixels >= position.maxScrollExtent - _SheetContent._loadMoreLead) {
      context.read<CommentsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusSheet),
      ),
      child: Container(
        color: AppColors.surface,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.m),
              Container(
                width: AppSpacing.grabHandleWidth,
                height: AppSpacing.grabHandleHeight,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.grabHandleHeight),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: Row(
                  children: [
                    Text('Comments', style: AppTypography.displayName),
                    const SizedBox(width: AppSpacing.xs),
                    Text('· ${widget.commentCount}', style: AppTypography.metaLine),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              const _Divider(),
              Expanded(
                child: BlocBuilder<CommentsCubit, CommentsState>(
                  builder: (context, state) {
                    return switch (state.status) {
                      CommentsStatus.initial ||
                      CommentsStatus.loading =>
                        const CommentsSkeletonList(),
                      CommentsStatus.failure => _FailureView(
                          message: state.failure!.userMessage,
                          retryable: state.failure!.retryable,
                          onRetry: () => context.read<CommentsCubit>().load(),
                        ),
                      CommentsStatus.success => state.comments.isEmpty
                          ? const CommentsEmptyView()
                          : ListView.builder(
                              controller: widget.listController,
                              itemCount: state.comments.length + 1,
                              itemBuilder: (context, index) {
                                if (index < state.comments.length) {
                                  final item = state.comments[index];
                                  return CommentRow(
                                    item: item,
                                    onRetry: () => context
                                        .read<CommentsCubit>()
                                        .retry(item.clientToken!),
                                    onDiscard: () => context
                                        .read<CommentsCubit>()
                                        .removeFailed(item.clientToken!),
                                  );
                                }
                                return _Footer(state: state);
                              },
                            ),
                    };
                  },
                ),
              ),
              const _Divider(),
              CommentInputBar(sheetController: widget.sheetController),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppSpacing.cardSeparator,
      child: ColoredBox(color: AppColors.divider),
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({
    required this.message,
    required this.retryable,
    required this.onRetry,
  });

  final String message;
  final bool retryable;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: AppTypography.body, textAlign: TextAlign.center),
            if (retryable) ...[
              const SizedBox(height: AppSpacing.l),
              OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state});

  final CommentsState state;

  @override
  Widget build(BuildContext context) {
    if (state.loadMoreFailure != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          children: [
            Text(
              state.loadMoreFailure!.userMessage,
              style: AppTypography.metaLine,
              textAlign: TextAlign.center,
            ),
            if (state.loadMoreFailure!.retryable) ...[
              const SizedBox(height: AppSpacing.s),
              OutlinedButton(
                onPressed: () => context.read<CommentsCubit>().loadMore(),
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
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
