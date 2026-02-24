import 'package:flutter/material.dart';

class AdaptiveScaffold extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? secondary;
  final double breakpoint;
  final double primaryFlex;
  final double secondaryFlex;

  const AdaptiveScaffold({
    super.key,
    required this.mobile,
    this.tablet,
    this.secondary,
    this.breakpoint = 700,
    this.primaryFlex = 1,
    this.secondaryFlex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return mobile;
        }

        final left = tablet ?? mobile;
        final right = secondary;

        if (right == null) {
          return left;
        }

        return Row(
          children: [
            Expanded(flex: (primaryFlex * 100).toInt(), child: left),
            const VerticalDivider(width: 1),
            Expanded(flex: (secondaryFlex * 100).toInt(), child: right),
          ],
        );
      },
    );
  }
}
