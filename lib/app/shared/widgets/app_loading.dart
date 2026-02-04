import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// App Loading Controller
/// Global loading overlay controller
class AppLoadingController extends GetxController {
  static AppLoadingController get to => Get.find<AppLoadingController>();

  final RxBool _isLoading = false.obs;
  final RxString _message = ''.obs;

  bool get isLoading => _isLoading.value;
  String get message => _message.value;

  /// Show loading overlay
  void show({String? message}) {
    _message.value = message ?? '';
    _isLoading.value = true;
  }

  /// Hide loading overlay
  void hide() {
    _isLoading.value = false;
    _message.value = '';
  }

  /// Execute async task with loading
  Future<T?> wrap<T>(Future<T> Function() task, {String? message}) async {
    try {
      show(message: message);
      final result = await task();
      return result;
    } finally {
      hide();
    }
  }
}

/// App Loading Widget
/// Global loading overlay widget - wrap your app with this
class AppLoading extends StatelessWidget {
  final Widget child;

  const AppLoading({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Obx(() {
          final controller = AppLoadingController.to;
          if (!controller.isLoading) {
            return const SizedBox.shrink();
          }
          return const _LoadingOverlay();
        }),
      ],
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: isDark ? Colors.black.withAlpha(180) : Colors.black.withAlpha(128),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 20, offset: const Offset(0, 4))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(isDark ? AppColors.primaryLight : AppColors.primary),
                  strokeWidth: 3,
                ),
                Obx(() {
                  final message = AppLoadingController.to.message;
                  if (message.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension for easy access
extension AppLoadingExtension on GetInterface {
  /// Show global loading
  void showLoading({String? message}) {
    AppLoadingController.to.show(message: message);
  }

  /// Hide global loading
  void hideLoading() {
    AppLoadingController.to.hide();
  }

  /// Wrap async task with loading
  Future<T?> wrapLoading<T>(Future<T> Function() task, {String? message}) {
    return AppLoadingController.to.wrap(task, message: message);
  }
}
