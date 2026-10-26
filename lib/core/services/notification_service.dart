import 'package:local_notifier/local_notifier.dart';

import '../resources/app_strings.dart';

/// Native Windows toast notifications for newly-eligible donors.
/// No-op-safe on macOS dev machines when init fails.
class NotificationService {
  static bool _ready = false;

  static Future<void> init() async {
    if (_ready) return;
    try {
      await localNotifier.setup(appName: 'CWTS_Setif');
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  static Future<void> showDonorEligible(String donorName, String lang) async {
    if (!_ready) return;
    LocalNotification(
      title: '${tr(lang, 'notifTitle')} — $donorName',
      body: tr(lang, 'notifBody'),
    ).show();
  }
}
