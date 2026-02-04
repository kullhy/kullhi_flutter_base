import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_button.dart';

enum DialogType { info, success, warning, error, confirm }

/// App Dialog
/// Customizable dialog with different types
class AppDialog {
  /// Show a simple dialog
  static Future<T?> show<T>({
    required String title,
    String? message,
    Widget? content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
    DialogType type = DialogType.info,
  }) async {
    return Get.dialog<T>(
      _DialogContent(
        title: title,
        message: message,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        type: type,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Show info dialog
  static Future<void> showInfo({
    required String title,
    String? message,
    Widget? content,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) async {
    return show(
      title: title,
      message: message,
      content: content,
      confirmText: confirmText,
      onConfirm: onConfirm,
      type: DialogType.info,
    );
  }

  /// Show success dialog
  static Future<void> showSuccess({
    required String title,
    String? message,
    Widget? content,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) async {
    return show(
      title: title,
      message: message,
      content: content,
      confirmText: confirmText,
      onConfirm: onConfirm,
      type: DialogType.success,
    );
  }

  /// Show warning dialog
  static Future<void> showWarning({
    required String title,
    String? message,
    Widget? content,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) async {
    return show(
      title: title,
      message: message,
      content: content,
      confirmText: confirmText,
      onConfirm: onConfirm,
      type: DialogType.warning,
    );
  }

  /// Show error dialog
  static Future<void> showError({
    required String title,
    String? message,
    Widget? content,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) async {
    return show(
      title: title,
      message: message,
      content: content,
      confirmText: confirmText,
      onConfirm: onConfirm,
      type: DialogType.error,
    );
  }

  /// Show confirm dialog
  static Future<bool?> showConfirm({
    required String title,
    String? message,
    Widget? content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) async {
    return show<bool>(
      title: title,
      message: message,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      type: DialogType.confirm,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Show loading dialog
  static Future<void> showLoading({String? message}) async {
    Get.dialog(_LoadingDialog(message: message), barrierDismissible: false);
  }

  /// Hide loading dialog
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Show custom dialog
  static Future<T?> showCustom<T>({required Widget child, bool barrierDismissible = true}) async {
    return Get.dialog<T>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: child,
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}

class _DialogContent extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final DialogType type;

  const _DialogContent({
    required this.title,
    this.message,
    this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            _buildIcon(isDark),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            // Message
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Custom content
            if (content != null) ...[const SizedBox(height: 16), content!],

            const SizedBox(height: 24),

            // Buttons
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(bool isDark) {
    IconData icon;
    Color color;

    switch (type) {
      case DialogType.info:
        icon = Icons.info_rounded;
        color = AppColors.info;
        break;
      case DialogType.success:
        icon = Icons.check_circle_rounded;
        color = AppColors.success;
        break;
      case DialogType.warning:
        icon = Icons.warning_rounded;
        color = AppColors.warning;
        break;
      case DialogType.error:
        icon = Icons.error_rounded;
        color = AppColors.error;
        break;
      case DialogType.confirm:
        icon = Icons.help_rounded;
        color = isDark ? AppColors.primaryLight : AppColors.primary;
        break;
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(color: color.withAlpha(25), shape: BoxShape.circle),
      child: Icon(icon, size: 36, color: color),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final showCancel = cancelText != null || type == DialogType.confirm;

    if (showCancel) {
      return Row(
        children: [
          Expanded(
            child: AppButton(
              text: cancelText ?? 'Cancel',
              type: AppButtonType.outlined,
              onPressed: () {
                Get.back(result: false);
                onCancel?.call();
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppButton(
              text: confirmText ?? 'OK',
              type: type == DialogType.error ? AppButtonType.danger : AppButtonType.primary,
              onPressed: () {
                Get.back(result: true);
                onConfirm?.call();
              },
            ),
          ),
        ],
      );
    }

    return AppButton(
      text: confirmText ?? 'OK',
      width: double.infinity,
      type: AppButtonType.primary,
      onPressed: () {
        Get.back();
        onConfirm?.call();
      },
    );
  }
}

class _LoadingDialog extends StatelessWidget {
  final String? message;

  const _LoadingDialog({this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(isDark ? AppColors.primaryLight : AppColors.primary),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
