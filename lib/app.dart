import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/dio_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/feed/data/feed_repository.dart';
import 'features/feed/presentation/cubit/feed_cubit.dart';
import 'features/stories/presentation/cubit/stories_cubit.dart';

class ExpertListingApp extends StatelessWidget {
  const ExpertListingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Provided above the router so state survives navigation — the
      // feed's rail and the story viewer route both need `StoriesCubit`,
      // and the composer (a full-screen route, and reachable from the
      // bottom nav's "+" tab, not just from inside the feed screen) needs
      // to be able to call `FeedCubit.refresh()` after a successful post.
      providers: [
        BlocProvider(create: (context) => StoriesCubit()..load()),
        BlocProvider(
          create: (context) =>
              FeedCubit(FeedRepository(DioClient()))..loadInitial(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Expert Listing',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: appRouter,
      ),
    );
  }
}
