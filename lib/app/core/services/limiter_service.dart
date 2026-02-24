
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LimiterService extends GetxService {
  final _storage = GetStorage();
  final int maxFreeUsage = 3;

  bool canUseFeature(String featureKey) {
    int usage = _storage.read('usage_$featureKey') ?? 0;
    return usage < maxFreeUsage;
  }

  void incrementUsage(String featureKey) {
    int usage = _storage.read('usage_$featureKey') ?? 0;
    _storage.write('usage_$featureKey', usage + 1);
  }
}
