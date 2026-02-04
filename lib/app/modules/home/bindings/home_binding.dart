import 'package:get/get.dart';

import '../controllers/home_controller.dart';

/// Home Binding
/// Inject dependencies for Home module
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
