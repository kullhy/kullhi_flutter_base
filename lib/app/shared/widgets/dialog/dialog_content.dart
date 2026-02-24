import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../app_button.dart';
import 'dialog_type.dart';

class DialogContent extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final DialogType type;

  const DialogContent({
    super.key,
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
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            // Message
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
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
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        shape: BoxShape.circle,
      ),
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
              type: type == DialogType.error
                  ? AppButtonType.danger
                  : AppButtonType.primary,
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
