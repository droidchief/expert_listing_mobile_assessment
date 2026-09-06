import 'package:flutter/material.dart';

import '../../../core/widgets/empty_view.dart';

/// Placeholder for a tab that isn't part of this build yet. Explains
/// itself rather than leaving a dead tap.
class PlaceholderTabPage extends StatelessWidget {
  const PlaceholderTabPage({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: EmptyView(
        icon: icon,
        title: '$title is coming soon',
        message: 'This section is not part of the current build.',
      ),
    );
  }
}
