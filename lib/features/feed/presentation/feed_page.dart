import 'package:flutter/material.dart';

import '../../../core/theme/app_typography.dart';

/// Bare Feed tab: app bar only for now. The feed list and stories rail
/// arrive in M2/M3.
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expert Listing', style: AppTypography.appTitle),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.mail_outline),
            onPressed: () {},
            tooltip: 'Messages',
          ),
        ],
      ),
      body: const SizedBox.shrink(),
    );
  }
}
