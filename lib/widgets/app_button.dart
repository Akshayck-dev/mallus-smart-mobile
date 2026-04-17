import 'package:flutter/material.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Widget? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final List<Color>? colors;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 52,
        decoration: colors != null 
          ? BoxDecoration(
              color: colors!.length == 1 ? colors![0] : null,
              gradient: colors!.length > 1 ? LinearGradient(colors: colors!) : null,
              borderRadius: BorderRadius.circular(16),
            )
          : CuratorDesign.premiumButtonDecoration(
              colors: [
                CuratorDesign.primary,
                CuratorDesign.secondaryIndigo,
              ],
            ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      const SizedBox(width: CuratorDesign.s),
                    ],
                    Text(
                      text.toUpperCase(),
                      style: CuratorDesign.label(
                        14,
                        color: Colors.white,
                        weight: FontWeight.w800,
                      ).copyWith(letterSpacing: 2),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
