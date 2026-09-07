abstract final class AppRoutes {
  static const String feed = '/feed';
  static const String search = '/search';
  static const String list = '/list';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  static const String storyViewer = '/stories/:groupIndex';
  static String storyViewerPath(int groupIndex) => '/stories/$groupIndex';

  static const String composer = '/composer';
}
