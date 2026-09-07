import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../cubit/comments_cubit.dart';


class CommentInputBar extends StatefulWidget {
  const CommentInputBar({super.key, required this.sheetController});

  final DraggableScrollableController sheetController;

  static const String _currentUserAvatarUrl =
      'https://i.pravatar.cc/150?u=miracle.h';
  static const int _maxLength = 2000;
  static const int _counterThreshold = 1800;

  @override
  State<CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<CommentInputBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_onTextChanged);
    _focusNode = FocusNode()..addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTextChanged)
      ..dispose();
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      widget.sheetController.animateTo(
        0.9,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _send() {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<CommentsCubit>().send(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final String trimmed = _controller.text.trim();
    final bool canSend = trimmed.isNotEmpty;
    final int length = _controller.text.length;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenHorizontal,
        right: AppSpacing.screenHorizontal,
        top: AppSpacing.s,
        bottom: AppSpacing.s + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (length > CommentInputBar._counterThreshold)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(
                '$length / ${CommentInputBar._maxLength}',
                style: AppTypography.metaLine,
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const AppAvatar(
                size: AppSpacing.avatarCommentInput,
                url: CommentInputBar._currentUserAvatarUrl,
                name: 'Miracle H',
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.m,
                    vertical: AppSpacing.s,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.fieldBackground,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: AppTypography.body,
                    minLines: 1,
                    maxLines: 4,
                    maxLength: CommentInputBar._maxLength,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Add a comment…',
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      counterText: '',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              _SendButton(enabled: canSend, onTap: _send),
            ],
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Send comment',
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: Container(
          width: AppSpacing.sendButtonSize,
          height: AppSpacing.sendButtonSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.4),
          ),
          child: const Icon(
            Icons.arrow_upward,
            color: AppColors.overlayContent,
            size: 18,
          ),
        ),
      ),
    );
  }
}
