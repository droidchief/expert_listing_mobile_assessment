import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
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
      label: 'Feed',
      outlinedIcon: Icons.home_outlined,
      filledIcon: Icons.home,
    ),
    _NavItemData(
      label: 'Search',
      outlinedIcon: Icons.search,
      filledIcon: Icons.search,
    ),
    _NavItemData(
      label: 'List',
      outlinedIcon: Icons.add,
      filledIcon: Icons.add,
      isCenter: true,
    ),
    _NavItemData(
      label: 'Notification',
      outlinedIcon: Icons.notifications_none,
      filledIcon: Icons.notifications,
    ),
    _NavItemData(
      label: 'Profile',
      outlinedIcon: Icons.person_outline,
      filledIcon: Icons.person,
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
                    onTap: _items[index].isCenter
                        ? () => context.push(AppRoutes.composer)
                        : () => navigationShell.goBranch(
                              index,
                              initialLocation:
                                  index == navigationShell.currentIndex,
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
    required this.outlinedIcon,
    required this.filledIcon,
    this.isCenter = false,
  });

  final String label;
  final IconData outlinedIcon;
  final IconData filledIcon;
  final bool isCenter;
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
    final Color color = selected ? AppColors.primary : AppColors.textTertiary;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (data.isCenter)
            Container(
              width: AppSpacing.iconNav + 10,
              height: AppSpacing.iconNav + 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.xs),
                border: Border.all(color: AppColors.iconDefault, width: 1.5),
              ),
              child: Icon(
                data.outlinedIcon,
                size: AppSpacing.iconNav,
                color: AppColors.iconDefault,
              ),
            )
          else
            Icon(
              selected ? data.filledIcon : data.outlinedIcon,
              size: AppSpacing.iconNav,
              color: color,
            ),
          if (!data.isCenter) ...[
            const SizedBox(height: AppSpacing.xs / 2),
            Text(
              data.label,
              style: AppTypography.navLabel.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }
}
