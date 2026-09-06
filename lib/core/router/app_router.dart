import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/feed/presentation/feed_page.dart';
import '../../features/shell/presentation/placeholder_tab_page.dart';
import '../../features/shell/presentation/scaffold_with_nav_bar.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.feed,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.feed,
              builder: (context, state) => const FeedPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.search,
              builder: (context, state) => const PlaceholderTabPage(
                title: 'Search',
                icon: Icons.search,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.list,
              builder: (context, state) => const PlaceholderTabPage(
                title: 'List',
                icon: Icons.add_box_outlined,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.notifications,
              builder: (context, state) => const PlaceholderTabPage(
                title: 'Notification',
                icon: Icons.notifications_none,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const PlaceholderTabPage(
                title: 'Profile',
                icon: Icons.person_outline,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
