import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum SnackBarType { info, success, warning, error }

/// App SnackBar
/// Customizable snackbar with different types
class AppSnackBar {
  /// Show a snackbar
  static void show({
    required String message,
    String? title,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
    bool isDismissible = true,
    Widget? icon,
    VoidCallback? onTap,
    String? actionText,
    VoidCallback? onAction,
  }) {
    Get.snackbar(
      title ?? _getDefaultTitle(type),
      message,
      snackPosition: position,
      duration: duration,
      isDismissible: isDismissible,
      backgroundColor: _getBackgroundColor(type),
      colorText: AppColors.white,
      icon: icon ?? _getIcon(type),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      snackStyle: SnackStyle.FLOATING,
      titleText: title != null
          ? Text(
              title,
              style: AppTextStyles.titleSmall.copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
            )
          : null,
      messageText: Text(message, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
      onTap: onTap != null ? (_) => onTap() : null,
      mainButton: actionText != null
          ? TextButton(
              onPressed: () {
                Get.closeCurrentSnackbar();
                onAction?.call();
              },
              child: Text(
                actionText,
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
              ),
            )
          : null,
    );
  }

  /// Show info snackbar
  static void showInfo({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    show(message: message, title: title, type: SnackBarType.info, duration: duration, position: position);
  }

  /// Show success snackbar
  static void showSuccess({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    show(message: message, title: title, type: SnackBarType.success, duration: duration, position: position);
  }

  /// Show warning snackbar
  static void showWarning({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    show(message: message, title: title, type: SnackBarType.warning, duration: duration, position: position);
  }

  /// Show error snackbar
  static void showError({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    show(message: message, title: title, type: SnackBarType.error, duration: duration, position: position);
  }

  /// Show snackbar at top
  static void showTop({
    required String message,
    String? title,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(message: message, title: title, type: type, duration: duration, position: SnackPosition.TOP);
  }

  /// Close current snackbar
  static void close() {
    Get.closeCurrentSnackbar();
  }

  /// Close all snackbars
  static void closeAll() {
    Get.closeAllSnackbars();
  }

  // ============== Helpers ==============

  static String _getDefaultTitle(SnackBarType type) {
    switch (type) {
      case SnackBarType.info:
        return 'Info';
      case SnackBarType.success:
        return 'Success';
      case SnackBarType.warning:
        return 'Warning';
      case SnackBarType.error:
        return 'Error';
    }
  }

  static Color _getBackgroundColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.info:
        return AppColors.info;
      case SnackBarType.success:
        return AppColors.success;
      case SnackBarType.warning:
        return AppColors.warning;
      case SnackBarType.error:
        return AppColors.error;
    }
  }

  static Widget _getIcon(SnackBarType type) {
    IconData icon;
    switch (type) {
      case SnackBarType.info:
        icon = Icons.info_rounded;
        break;
      case SnackBarType.success:
        icon = Icons.check_circle_rounded;
        break;
      case SnackBarType.warning:
        icon = Icons.warning_rounded;
        break;
      case SnackBarType.error:
        icon = Icons.error_rounded;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Icon(icon, color: AppColors.white, size: 28),
    );
  }
}
