/// Defaults to the Android emulator's alias for the host computer.
/// For Chrome, use --dart-define=API_BASE_URL=http://localhost:8000.
const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);
