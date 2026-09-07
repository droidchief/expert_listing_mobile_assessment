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
