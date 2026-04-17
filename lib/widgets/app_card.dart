import 'package:flutter/material.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? radius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget card = Container(
      decoration: CuratorDesign.cardDecoration(isDark).copyWith(
        borderRadius: radius != null ? BorderRadius.circular(radius!) : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(CuratorDesign.m),
        child: child,
      ),
    );

    if (onTap != null) {
      return Bounceable(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
