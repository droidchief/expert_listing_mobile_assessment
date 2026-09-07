abstract final class AppRoutes {
  static const String home = '/home';
  static const String feed = '/feed';
  static const String wishlist = '/wishlist';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  static const String storyViewer = '/stories/:groupIndex';
  static String storyViewerPath(int groupIndex) => '/stories/$groupIndex';

  static const String composer = '/composer';
}
