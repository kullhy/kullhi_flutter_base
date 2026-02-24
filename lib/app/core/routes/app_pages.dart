import 'package:get/get.dart';

import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/subscription/bindings/subscription_binding.dart';
import '../../modules/subscription/views/paywall_view.dart';
import 'app_routes.dart';

/// App Pages
/// Define all GetPage routes
abstract class AppPages {
  static String get initial => Routes.HOME;

  static final List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.PAYWALL,
      page: () => const PaywallView(),
      binding: SubscriptionBinding(),
    ),
  ];
}
