/// Compile-time channel/version info passed via --dart-define from CI.
class AppEnv {
  static const String channel = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'stable',
  );
  static const String version = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0-dev',
  );

  static bool get isBeta => channel == 'stable' ? false : true;

  /// Separate AppData subfolder so Beta never touches Stable SQLite DB or photos.
  static String get appDataFolderName =>
      isBeta ? 'tabaro3_setif_beta' : 'tabaro3_setif';

  /// Window title & header badge.
  static String appTitle(String baseTitle) =>
      isBeta ? '$baseTitle [BETA $version]' : baseTitle;
}
