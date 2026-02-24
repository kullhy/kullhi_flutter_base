import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../modules/subscription/controllers/subscription_controller.dart';
import '../../shared/widgets/app_loading.dart';
import '../controllers/theme_controller.dart';
import '../network/dio_client.dart';
import '../services/analytics_service.dart';
import '../services/storage_service.dart';

Future<void> initDependencies() async {
  await GetStorage.init();

  Get.put<DioClient>(DioClient(), permanent: true);
  Get.put<AppLoadingController>(AppLoadingController(), permanent: true);
  Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);

  Get.put<StorageService>(StorageService(), permanent: true);
  Get.put<AnalyticsService>(AnalyticsService(), permanent: true);
  await Get.putAsync<IapService>(() async => await IapService().init(), permanent: true);
}
