import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CuratorDesign.surfaceColor(context),
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CuratorDesign.primary.withValues(alpha: 0.08),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 2.seconds),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Icon with Ring
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: CuratorDesign.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: CuratorDesign.primary.withValues(alpha: 0.4),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ).animate().scale(
                  duration: 800.ms,
                  curve: Curves.elasticOut,
                ),

                const SizedBox(height: 48),

                Text(
                  "Order Placed\nSuccessfully!",
                  textAlign: TextAlign.center,
                  style: CuratorDesign.title(color: CuratorDesign.textPrimary(context)).copyWith(fontSize: 32),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 20),

                Text(
                  "Your selection is being prepared for shipment. You will receive tracking details via WhatsApp soon.",
                  textAlign: TextAlign.center,
                  style: CuratorDesign.subtitle(color: CuratorDesign.textSecondary(context)).copyWith(height: 1.6),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 60),

                // Primary Button
                Bounceable(
                  onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: CuratorDesign.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: CuratorDesign.primary.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "CONTINUE SHOPPING",
                        style: CuratorDesign.label(16, color: Colors.white, weight: FontWeight.w700),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 16),

                // Secondary Button
                Bounceable(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      color: CuratorDesign.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: CuratorDesign.primary.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share_rounded, size: 18, color: CuratorDesign.primary),
                        const SizedBox(width: 12),
                        Text(
                          "SHARE PURCHASE",
                          style: CuratorDesign.label(14, color: CuratorDesign.primary, weight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
          
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "MALLU SMART KERALA",
                style: CuratorDesign.label(10, color: CuratorDesign.textSecondary(context).withValues(alpha: 0.3)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
