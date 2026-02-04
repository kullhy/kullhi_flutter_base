import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/theme_controller.dart';
import '../../../shared/widgets/widgets.dart';
import '../controllers/home_controller.dart';

/// Home View
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Home', showBackButton: false, actions: [_ThemeToggleButton()]),
      body: const Center(child: Text('Home Screen')),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) {
        return IconButton(
          icon: Icon(controller.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
          onPressed: () => controller.toggleTheme(),
          tooltip: controller.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
        );
      },
    );
  }
}
