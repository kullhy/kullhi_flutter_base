import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum AppButtonType { primary, secondary, outlined, text, danger }

enum AppButtonSize { small, medium, large }

/// App Button Widget
/// Customizable button with different types, sizes and states
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(width: width, height: height ?? _getHeight(), child: _buildButton(context, isDark));
  }

  Widget _buildButton(BuildContext context, bool isDark) {
    final disabled = isDisabled || isLoading;

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: _getPrimaryStyle(isDark),
          child: _buildChild(isDark),
        );
      case AppButtonType.secondary:
        return ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: _getSecondaryStyle(isDark),
          child: _buildChild(isDark),
        );
      case AppButtonType.outlined:
        return OutlinedButton(
          onPressed: disabled ? null : onPressed,
          style: _getOutlinedStyle(isDark),
          child: _buildChild(isDark),
        );
      case AppButtonType.text:
        return TextButton(
          onPressed: disabled ? null : onPressed,
          style: _getTextStyle(isDark),
          child: _buildChild(isDark),
        );
      case AppButtonType.danger:
        return ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: _getDangerStyle(isDark),
          child: _buildChild(isDark),
        );
    }
  }

  Widget _buildChild(bool isDark) {
    if (isLoading) {
      return SizedBox(
        width: _getLoaderSize(),
        height: _getLoaderSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getLoaderColor(isDark)),
        ),
      );
    }

    final children = <Widget>[];

    if (prefixIcon != null) {
      children.add(Icon(prefixIcon, size: _getIconSize()));
      children.add(SizedBox(width: _getIconSpacing()));
    }

    children.add(Text(text, style: textStyle ?? _getTextStyle2()));

    if (suffixIcon != null) {
      children.add(SizedBox(width: _getIconSpacing()));
      children.add(Icon(suffixIcon, size: _getIconSize()));
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: children);
  }

  // ============== Size Helpers ==============

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 44;
      case AppButtonSize.large:
        return 52;
    }
  }

  double _getLoaderSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  double _getIconSpacing() {
    switch (size) {
      case AppButtonSize.small:
        return 4;
      case AppButtonSize.medium:
        return 8;
      case AppButtonSize.large:
        return 10;
    }
  }

  TextStyle _getTextStyle2() {
    switch (size) {
      case AppButtonSize.small:
        return AppTextStyles.buttonSmall;
      case AppButtonSize.medium:
        return AppTextStyles.buttonMedium;
      case AppButtonSize.large:
        return AppTextStyles.buttonLarge;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    if (padding != null) return padding!;
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 28, vertical: 14);
    }
  }

  double _getBorderRadius() {
    return borderRadius ?? 8;
  }

  // ============== Style Helpers ==============

  Color _getLoaderColor(bool isDark) {
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.danger:
        return AppColors.white;
      case AppButtonType.secondary:
        return isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
      case AppButtonType.outlined:
      case AppButtonType.text:
        return isDark ? AppColors.primaryLight : AppColors.primary;
    }
  }

  ButtonStyle _getPrimaryStyle(bool isDark) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDark ? AppColors.primaryLight : AppColors.primary,
      foregroundColor: isDark ? AppColors.gray900 : AppColors.white,
      disabledBackgroundColor: AppColors.gray400,
      disabledForegroundColor: AppColors.gray600,
      padding: _getPadding(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_getBorderRadius())),
    );
  }

  ButtonStyle _getSecondaryStyle(bool isDark) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDark ? AppColors.gray700 : AppColors.gray200,
      foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      disabledBackgroundColor: AppColors.gray400,
      disabledForegroundColor: AppColors.gray600,
      padding: _getPadding(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_getBorderRadius())),
    );
  }

  ButtonStyle _getOutlinedStyle(bool isDark) {
    return OutlinedButton.styleFrom(
      foregroundColor: isDark ? AppColors.primaryLight : AppColors.primary,
      side: BorderSide(
        color: isDisabled
            ? AppColors.gray400
            : isDark
            ? AppColors.primaryLight
            : AppColors.primary,
      ),
      padding: _getPadding(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_getBorderRadius())),
    );
  }

  ButtonStyle _getTextStyle(bool isDark) {
    return TextButton.styleFrom(
      foregroundColor: isDark ? AppColors.primaryLight : AppColors.primary,
      padding: _getPadding(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_getBorderRadius())),
    );
  }

  ButtonStyle _getDangerStyle(bool isDark) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDark ? AppColors.errorLight : AppColors.error,
      foregroundColor: AppColors.white,
      disabledBackgroundColor: AppColors.gray400,
      disabledForegroundColor: AppColors.gray600,
      padding: _getPadding(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_getBorderRadius())),
    );
  }
}
