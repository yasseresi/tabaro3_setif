import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../resources/app_strings.dart';

/// Native desktop notifications (Windows toasts / macOS banners) for
/// newly-eligible donors. Safe no-op when the platform init fails.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  static Future<void> init() async {
    if (_ready) return;
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          windows: WindowsInitializationSettings(
            appName: 'CWTS_Setif',
            appUserModelId: 'com.cwtssetif.tabaro3Setif',
            guid: '9B4F2C81-6E1A-4D3B-9C12-BETA00CWTS19',
          ),
          macOS: DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: (_) {},
      );
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  static Future<void> showDonorEligible(String donorName, String lang) async {
    if (!_ready) return;
    try {
      await _plugin.show(
        id: 0,
        title: '${tr(lang, 'notifTitle')} — $donorName',
        body: tr(lang, 'notifBody'),
        notificationDetails: const NotificationDetails(
          windows: WindowsNotificationDetails(),
          macOS: DarwinNotificationDetails(),
        ),
      );
    } catch (_) {
      // notifications are best-effort
    }
  }
}
