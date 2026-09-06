import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/stories/presentation/cubit/stories_cubit.dart';

class ExpertListingApp extends StatelessWidget {
  const ExpertListingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Provided above the router so seen state survives navigation between
      // the feed's rail and the full-screen story viewer route.
      create: (context) => StoriesCubit()..load(),
      child: MaterialApp.router(
        title: 'Expert Listing',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: appRouter,
      ),
    );
  }
}
