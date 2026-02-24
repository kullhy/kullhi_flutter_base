
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

class FirebaseService extends GetxService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.fetchAndActivate();
  }

  // Helper để lấy config nhanh
  bool get showPaywallFirst => _remoteConfig.getBool('show_paywall_first');

  // Tracking chuẩn cho App Tool
  void logPaywallView(String source) => 
      _analytics.logEvent(name: 'paywall_viewed', parameters: {'source': source});
      
  void logPurchaseSuccess(String plan) => 
      _analytics.logEvent(name: 'purchase_success', parameters: {'plan': plan});
}
