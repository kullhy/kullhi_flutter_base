
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../modules/subscription/controllers/subscription_controller.dart';

class PremiumGuard extends StatelessWidget {
  final Widget child;
  final String featureName;

  const PremiumGuard({super.key, required this.child, required this.featureName});

  @override
  Widget build(BuildContext context) {
    return GetX<SubscriptionController>(
      builder: (controller) {
        if (controller.isPremium.value) {
          return child;
        }
        return Stack(
          children: [
            AbsorbPointer(child: child), // Làm mờ hoặc chặn tương tác
            Positioned.fill(
              child: Container(
                color: Colors.black12.withOpacity(0.5),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed(Routes.PAYWALL),
                    child: Text("Unlock $featureName"),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
