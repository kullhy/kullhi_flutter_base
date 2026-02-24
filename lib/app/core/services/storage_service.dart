import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static const String _premiumKey = 'is_premium';

  final GetStorage _box = GetStorage();

  bool get isPremium => _box.read<bool>(_premiumKey) ?? false;

  Future<void> setPremium(bool value) async {
    await _box.write(_premiumKey, value);
  }
}
