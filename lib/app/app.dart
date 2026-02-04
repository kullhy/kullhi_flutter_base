import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_pages.dart';
import 'core/controllers/theme_controller.dart';
import 'shared/widgets/app_loading.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: ThemeController(),
      builder: (themeController) {
        return GetMaterialApp(
          title: 'Kullhi Flutter Base',
          debugShowCheckedModeBanner: false,

          // Localization
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          // Theme
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,

          // Routes
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,

          // Default Transition
          defaultTransition: Transition.fadeIn,

          // Wrap with AppLoading for global loading overlay
          builder: (context, child) {
            return AppLoading(child: child ?? const SizedBox.shrink());
          },
        );
      },
    );
  }
}
