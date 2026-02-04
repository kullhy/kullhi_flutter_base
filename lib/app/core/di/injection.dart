import 'package:get/get.dart';

import '../controllers/theme_controller.dart';
import '../network/dio_client.dart';
import '../../shared/widgets/app_loading.dart';

/// Dependency Injection
/// Initialize all app dependencies
Future<void> initDependencies() async {
  // Core
  Get.lazyPut<DioClient>(() => DioClient(), fenix: true);

  // Global Controllers
  Get.put<AppLoadingController>(AppLoadingController(), permanent: true);
  Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
}
