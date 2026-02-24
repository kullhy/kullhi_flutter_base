import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dialog/dialog_content.dart';
import 'dialog/dialog_type.dart';
import 'dialog/loading_dialog.dart';

export 'dialog/dialog_type.dart';

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
      DialogContent(
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
    Get.dialog(LoadingDialog(message: message), barrierDismissible: false);
  }

  /// Hide loading dialog
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Show custom dialog
  static Future<T?> showCustom<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) async {
    return Get.dialog<T>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: child,
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}
