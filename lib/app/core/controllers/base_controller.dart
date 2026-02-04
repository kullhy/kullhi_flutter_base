import 'package:get/get.dart';
import 'package:logger/logger.dart';

/// Base Controller
/// All controllers should extend this class
abstract class BaseController extends GetxController {
  final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  // ============== Loading State ==============
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  void setLoading(bool value) {
    _isLoading.value = value;
  }

  // ============== Error State ==============
  final RxnString _errorMessage = RxnString();
  String? get errorMessage => _errorMessage.value;

  void setError(String? message) {
    _errorMessage.value = message;
  }

  void clearError() {
    _errorMessage.value = null;
  }

  // ============== Success State ==============
  final RxnString _successMessage = RxnString();
  String? get successMessage => _successMessage.value;

  void setSuccess(String? message) {
    _successMessage.value = message;
  }

  void clearSuccess() {
    _successMessage.value = null;
  }

  // ============== Lifecycle ==============
  @override
  void onInit() {
    super.onInit();
    logger.d('${runtimeType.toString()} initialized');
  }

  @override
  void onReady() {
    super.onReady();
    logger.d('${runtimeType.toString()} ready');
  }

  @override
  void onClose() {
    logger.d('${runtimeType.toString()} closed');
    super.onClose();
  }

  // ============== Helper Methods ==============
  /// Execute async operation with loading state
  Future<T?> executeWithLoading<T>(Future<T> Function() action) async {
    try {
      setLoading(true);
      clearError();
      final result = await action();
      return result;
    } catch (e, stackTrace) {
      logger.e('Error in ${runtimeType.toString()}', error: e, stackTrace: stackTrace);
      setError(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Execute async operation without loading state
  Future<T?> execute<T>(Future<T> Function() action) async {
    try {
      clearError();
      final result = await action();
      return result;
    } catch (e, stackTrace) {
      logger.e('Error in ${runtimeType.toString()}', error: e, stackTrace: stackTrace);
      setError(e.toString());
      return null;
    }
  }
}
