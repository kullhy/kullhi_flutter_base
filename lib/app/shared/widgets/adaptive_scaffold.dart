
import 'package:flutter/material.dart';

class AdaptiveScaffold extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;

  const AdaptiveScaffold({super.key, required this.mobile, this.tablet});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return tablet ?? mobile; // Nếu là iPad/Tablet
        }
        return mobile; // Nếu là Phone
      },
    );
  }
}
