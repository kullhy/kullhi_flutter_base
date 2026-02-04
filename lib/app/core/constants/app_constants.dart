/// App Constants
abstract class AppConstants {
  /// App Name
  static const String appName = 'Kullhi Flutter Base';

  /// App Version
  static const String appVersion = '1.0.0';

  /// Default Animation Duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  /// Default Page Size
  static const int defaultPageSize = 20;

  /// Date Format
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  /// SharedPreferences Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUser = 'user';
  static const String keyLanguage = 'language';
  static const String keyTheme = 'theme_mode';
  static const String keyFirstLaunch = 'first_launch';
}
