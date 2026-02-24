import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

class AnalyticsService extends GetxService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logPaywallView(String source) {
    return _analytics.logEvent(name: 'paywall_viewed', parameters: {'source': source});
  }

  Future<void> logPurchaseSuccess(String plan) {
    return _analytics.logEvent(name: 'purchase_success', parameters: {'plan': plan});
  }
}
