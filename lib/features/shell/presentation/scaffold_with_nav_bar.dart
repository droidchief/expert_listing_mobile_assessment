import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Bottom nav shell wrapping the `StatefulShellRoute`'s branch navigator,
/// so each tab keeps its own scroll position and navigation stack.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const List<_NavItemData> _items = [
    _NavItemData(
      label: 'Home',
      assetPath: 'assets/images/home_tab_icon.svg',
    ),
    _NavItemData(
      label: 'Feed',
      assetPath: 'assets/images/feed_tab_icon.svg',
      badge: 'Beta',
    ),
    _NavItemData(
      label: 'Wishlist',
      assetPath: 'assets/images/wishlist_tab_icon.svg',
    ),
    _NavItemData(
      label: 'Notification',
      assetPath: 'assets/images/notification_tab_icon.svg',
    ),
    _NavItemData(
      label: 'Profile',
      assetPath: 'assets/images/profile_tab_icon.svg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.divider)),
          ),
          // No fixed height — the nav bar must grow with the label text at
          // larger accessibility text scales rather than overflow.
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
          child: Row(
            children: [
              for (int index = 0; index < _items.length; index++)
                Expanded(
                  child: _NavItem(
                    data: _items[index],
                    selected: navigationShell.currentIndex == index,
                    onTap: () => navigationShell.goBranch(
                      index,
                      initialLocation: index == navigationShell.currentIndex,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.label,
    required this.assetPath,
    this.badge,
  });

  final String label;
  final String assetPath;

  final String? badge;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _NavItemData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color =
        selected ? AppColors.primaryText : AppColors.navIconInactive;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            data.assetPath,
            width: AppSpacing.iconNav,
            height: AppSpacing.iconNav,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(height: AppSpacing.s),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.label,
                style: AppTypography.navLabel.copyWith(color: color,
                fontSize: 13, fontWeight: FontWeight.w500),
              ),
              if (data.badge != null) ...[
                const SizedBox(width: AppSpacing.xs),
                _BetaBadge(label: data.badge!),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _BetaBadge extends StatelessWidget {
  const _BetaBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.primaryText.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(
        label,
        style: AppTypography.navLabel.copyWith(color: AppColors.primaryText),
      ),
    );
  }
}
