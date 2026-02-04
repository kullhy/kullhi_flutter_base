import 'package:get/get.dart';

import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_view.dart';

/// App Pages
/// Define all GetPage routes
abstract class AppPages {
  static String get initial => HomeView.routeName;

  static final List<GetPage> routes = [
    GetPage(
      name: HomeView.routeName,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
