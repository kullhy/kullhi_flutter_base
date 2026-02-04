import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// App AppBar Widget
/// Customizable app bar with consistent styling
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? leading;
  final double? leadingWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const AppAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.leading,
    this.leadingWidth,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.flexibleSpace,
    this.bottom,
    this.systemOverlayStyle,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor ?? (isDark ? AppColors.darkSurface : AppColors.lightSurface),
      foregroundColor: foregroundColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      leading: leading ?? _buildLeading(context, isDark),
      leadingWidth: leadingWidth,
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      titleTextStyle: AppTextStyles.titleMedium.copyWith(
        color: foregroundColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: foregroundColor ?? (isDark ? AppColors.darkIcon : AppColors.lightIcon)),
      actionsIconTheme: IconThemeData(color: foregroundColor ?? (isDark ? AppColors.darkIcon : AppColors.lightIcon)),
      systemOverlayStyle: systemOverlayStyle ?? (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark),
    );
  }

  Widget? _buildLeading(BuildContext context, bool isDark) {
    if (!showBackButton) return null;

    final canPop = Navigator.of(context).canPop();
    if (!canPop) return null;

    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
    );
  }
}

/// Transparent App Bar
class AppAppBarTransparent extends AppAppBar {
  const AppAppBarTransparent({
    super.key,
    super.title,
    super.titleWidget,
    super.centerTitle,
    super.showBackButton,
    super.onBackPressed,
    super.actions,
    super.leading,
    super.leadingWidth,
    super.foregroundColor,
    super.flexibleSpace,
    super.bottom,
  }) : super(backgroundColor: Colors.transparent, elevation: 0);
}

/// Sliver App Bar
class AppSliverAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? leading;
  final double? leadingWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final bool pinned;
  final bool floating;
  final bool snap;

  const AppSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.leading,
    this.leadingWidth,
    this.backgroundColor,
    this.foregroundColor,
    this.expandedHeight,
    this.flexibleSpace,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverAppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: backgroundColor ?? (isDark ? AppColors.darkSurface : AppColors.lightSurface),
      foregroundColor: foregroundColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      leading: leading ?? _buildLeading(context, isDark),
      leadingWidth: leadingWidth,
      actions: actions,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      pinned: pinned,
      floating: floating,
      snap: snap,
      titleTextStyle: AppTextStyles.titleMedium.copyWith(
        color: foregroundColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: foregroundColor ?? (isDark ? AppColors.darkIcon : AppColors.lightIcon)),
      actionsIconTheme: IconThemeData(color: foregroundColor ?? (isDark ? AppColors.darkIcon : AppColors.lightIcon)),
    );
  }

  Widget? _buildLeading(BuildContext context, bool isDark) {
    if (!showBackButton) return null;

    final canPop = Navigator.of(context).canPop();
    if (!canPop) return null;

    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
    );
  }
}
