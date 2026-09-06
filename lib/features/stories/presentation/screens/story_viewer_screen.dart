import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/story.dart';
import '../../domain/story_group.dart';
import '../cubit/stories_cubit.dart';
import '../widgets/story_header.dart';
import '../widgets/story_image.dart';
import '../widgets/story_progress_bars.dart';

/// Full-screen story viewer, opened at [initialGroupIndex]. Author-to-author
/// movement is a horizontal `PageView` (natural swipe transition); within an
/// author, stories switch in place, driven by a single `AnimationController`
/// shared by the progress bar and the auto-advance.
class StoryViewerScreen extends StatelessWidget {
  const StoryViewerScreen({super.key, required this.initialGroupIndex});

  final int initialGroupIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.overlayScrim,
      body: _StoryViewerBody(initialGroupIndex: initialGroupIndex),
    );
  }
}

class _StoryViewerBody extends StatefulWidget {
  const _StoryViewerBody({required this.initialGroupIndex});

  final int initialGroupIndex;

  @override
  State<_StoryViewerBody> createState() => _StoryViewerBodyState();
}

class _StoryViewerBodyState extends State<_StoryViewerBody>
    with SingleTickerProviderStateMixin {
  static const Duration _pageTransition = Duration(milliseconds: 260);
  static const double _dismissVelocityThreshold = 300;

  late final List<StoryGroup> _groups;
  late final PageController _pageController;
  late final AnimationController _progressController;

  late int _currentGroupIndex;
  late int _currentStoryIndex;
  bool _imageLoaded = false;

  StoryGroup get _currentGroup => _groups[_currentGroupIndex];
  Story get _currentStory => _currentGroup.stories[_currentStoryIndex];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _groups = context.read<StoriesCubit>().state.groups;
    _currentGroupIndex = widget.initialGroupIndex;
    _currentStoryIndex = _currentGroup.firstUnseenIndex;
    _pageController = PageController(initialPage: _currentGroupIndex);
    _progressController = AnimationController(vsync: this)
      ..addStatusListener(_onStatusChanged);

    // _enterStory() calls precacheImage(context), which touches MediaQuery —
    // deferred until after the first frame so the element is fully mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _enterStory();
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _goToNextStory();
    }
  }

  /// Resets the timer for whatever `_currentGroupIndex`/`_currentStoryIndex`
  /// now point to, marks it seen immediately (not on completion), and
  /// preloads the story that follows it.
  void _enterStory() {
    _progressController
      ..stop()
      ..reset()
      ..duration = _currentStory.duration;
    setState(() => _imageLoaded = false);

    context
        .read<StoriesCubit>()
        .markSeen(_currentGroup.author.id, _currentStory.id);

    final Story? next = _peekNextStory();
    if (next != null) {
      precacheImage(CachedNetworkImageProvider(next.imageUrl), context);
    }
  }

  Story? _peekNextStory() {
    if (_currentStoryIndex < _currentGroup.stories.length - 1) {
      return _currentGroup.stories[_currentStoryIndex + 1];
    }
    if (_currentGroupIndex < _groups.length - 1) {
      final StoryGroup nextGroup = _groups[_currentGroupIndex + 1];
      return nextGroup.stories[nextGroup.firstUnseenIndex];
    }
    return null;
  }

  void _onImageLoaded() {
    if (!mounted) return;
    setState(() => _imageLoaded = true);
    _progressController.forward();
  }

  // A broken URL shouldn't hang the story forever — let it play out on
  // schedule same as a loaded image.
  void _onImageError() => _onImageLoaded();

  void _goToNextStory() {
    if (_currentStoryIndex < _currentGroup.stories.length - 1) {
      setState(() => _currentStoryIndex++);
      _enterStory();
      return;
    }
    if (_currentGroupIndex < _groups.length - 1) {
      _pageController.nextPage(duration: _pageTransition, curve: Curves.easeOut);
      return;
    }
    _close();
  }

  void _goToPreviousStory() {
    if (_currentStoryIndex > 0) {
      setState(() => _currentStoryIndex--);
      _enterStory();
      return;
    }
    if (_currentGroupIndex > 0) {
      _pageController.previousPage(
        duration: _pageTransition,
        curve: Curves.easeOut,
      );
      return;
    }
    // Very first story of the very first group: restart, don't close.
    _enterStory();
  }

  /// Fires for both a physical swipe between authors and our own
  /// `nextPage`/`previousPage` calls. Forward entry resumes at the new
  /// group's first unseen story; backward entry lands on its last story —
  /// matching the tap-to-advance rules for cross-group movement.
  void _onPageChanged(int newIndex) {
    final bool goingForward = newIndex > _currentGroupIndex;
    setState(() {
      _currentGroupIndex = newIndex;
      _currentStoryIndex =
          goingForward ? _currentGroup.firstUnseenIndex : _currentGroup.stories.length - 1;
    });
    _enterStory();
  }

  void _pause() => _progressController.stop();

  void _resume() {
    if (_imageLoaded) _progressController.forward();
  }

  void _close() {
    if (!mounted) return;
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: _groups.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        final bool isActive = index == _currentGroupIndex;
        final StoryGroup group = _groups[index];
        final int storyIndex = isActive ? _currentStoryIndex : group.firstUnseenIndex;

        return _StoryPage(
          group: group,
          storyIndex: storyIndex,
          isActive: isActive,
          imageLoaded: isActive && _imageLoaded,
          progressController: isActive ? _progressController : null,
          onImageLoaded: _onImageLoaded,
          onImageError: _onImageError,
          onTapNext: _goToNextStory,
          onTapPrevious: _goToPreviousStory,
          onLongPressStart: _pause,
          onLongPressEnd: _resume,
          onClose: _close,
          dismissVelocityThreshold: _dismissVelocityThreshold,
        );
      },
    );
  }
}

class _StoryPage extends StatelessWidget {
  const _StoryPage({
    required this.group,
    required this.storyIndex,
    required this.isActive,
    required this.imageLoaded,
    required this.progressController,
    required this.onImageLoaded,
    required this.onImageError,
    required this.onTapNext,
    required this.onTapPrevious,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.onClose,
    required this.dismissVelocityThreshold,
  });

  final StoryGroup group;
  final int storyIndex;
  final bool isActive;
  final bool imageLoaded;
  final AnimationController? progressController;
  final VoidCallback onImageLoaded;
  final VoidCallback onImageError;
  final VoidCallback onTapNext;
  final VoidCallback onTapPrevious;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;
  final VoidCallback onClose;
  final double dismissVelocityThreshold;

  @override
  Widget build(BuildContext context) {
    final Story story = group.stories[storyIndex];
    final Listenable progressListenable =
        progressController ?? const AlwaysStoppedAnimation(0);

    return IgnorePointer(
      ignoring: !isActive,
      child: ColoredBox(
        color: AppColors.overlayScrim,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isActive)
              StoryImage(
                url: story.imageUrl,
                onLoaded: onImageLoaded,
                onError: onImageError,
              ),
            if (isActive && !imageLoaded)
              const Center(
                child: CircularProgressIndicator(
                  color: AppColors.overlayContent,
                ),
              ),
            // Tap zones sit *below* the header in the stack (added before
            // it here) so the header's own controls — the close button in
            // particular — are hit-tested first and don't get swallowed by
            // this full-screen gesture layer.
            if (isActive)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTapUp: (details) {
                  final double width = MediaQuery.sizeOf(context).width;
                  if (details.localPosition.dx < width / 3) {
                    onTapPrevious();
                  } else {
                    onTapNext();
                  }
                },
                onLongPressStart: (_) => onLongPressStart(),
                onLongPressEnd: (_) => onLongPressEnd(),
                onVerticalDragEnd: (details) {
                  if ((details.primaryVelocity ?? 0) > dismissVelocityThreshold) {
                    onClose();
                  }
                },
              ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontal,
                        vertical: AppSpacing.s,
                      ),
                      child: AnimatedBuilder(
                        animation: progressListenable,
                        builder: (context, _) => StoryProgressBars(
                          count: group.stories.length,
                          currentIndex: storyIndex,
                          progress: progressController?.value ?? 0,
                        ),
                      ),
                    ),
                    StoryHeader(
                      author: group.author,
                      createdAt: story.createdAt,
                      onClose: onClose,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
