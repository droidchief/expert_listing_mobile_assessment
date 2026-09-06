/// Compile-time API configuration, overridable per build without a code
/// change: `flutter run --dart-define=API_BASE_URL=... --dart-define=MOCK_USER_ID=...`
abstract final class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://expert-listing-backend.vercel.app/api/v1',
  );

  // miracle.h, the seeded current user. Auth is mocked via this header until
  // it becomes a real JWT — this constant is that seam.
  static const String mockUserId = String.fromEnvironment(
    'MOCK_USER_ID',
    defaultValue: '00000000-0000-0000-0000-000000000001',
  );
}
