import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Circular avatar image. Falls back to initials when [url] is null, and
/// can render a coloured ring (for stories) and a small badge overlay (for
/// business accounts).
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.size,
    this.url,
    this.name,
    this.ringColor,
    this.badge,
  });

  final double size;
  final String? url;
  final String? name;
  final Color? ringColor;
  final Widget? badge;

  static const double _ringWidth = 2;
  static const double _ringGap = 2;

  @override
  Widget build(BuildContext context) {
    Widget image = ClipOval(
      child: url != null
          ? CachedNetworkImage(
              imageUrl: url!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              placeholder: (context, _) => Container(color: AppColors.divider),
              errorWidget: (context, url, error) => _InitialsFallback(
                size: size,
                name: name,
              ),
            )
          : _InitialsFallback(size: size, name: name),
    );

    if (ringColor != null) {
      final double outerSize = size + 2 * (_ringWidth + _ringGap);
      image = Container(
        width: outerSize,
        height: outerSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ringColor!, width: _ringWidth),
        ),
        child: Container(
          padding: const EdgeInsets.all(_ringGap),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
          ),
          child: image,
        ),
      );
    }

    if (badge == null) return image;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        image,
        Positioned(
          right: -2,
          bottom: -2,
          child: badge!,
        ),
      ],
    );
  }
}

class _InitialsFallback extends StatelessWidget {
  const _InitialsFallback({required this.size, required this.name});

  final double size;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final String initials = _initialsFor(name);
    return Container(
      width: size,
      height: size,
      color: AppColors.divider,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTypography.displayName.copyWith(
          fontSize: size * 0.4,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  String _initialsFor(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    final String first = parts.first.substring(0, 1);
    final String second = parts.length > 1 ? parts[1].substring(0, 1) : '';
    return (first + second).toUpperCase();
  }
}
