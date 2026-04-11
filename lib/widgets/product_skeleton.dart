import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/design_system.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color baseColor = isDark ? Colors.white10 : Colors.black.withOpacity(0.05);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: CuratorDesign.cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Skeleton
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(color: baseColor),
            ),
          ).animate(onPlay: (c) => c.repeat())
           .shimmer(duration: 1200.ms, color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.7)),
          
          const SizedBox(height: 14),
          
          // Title Skeleton
          Container(
            height: 14,
            width: 100,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ).animate(onPlay: (c) => c.repeat())
           .shimmer(duration: 1200.ms, delay: 100.ms),
          
          const SizedBox(height: 8),
          
          // Category Skeleton
          Container(
            height: 10,
            width: 60,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ).animate(onPlay: (c) => c.repeat())
           .shimmer(duration: 1200.ms, delay: 200.ms),
          
          const Spacer(),
          
          // Bottom Row Skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 20,
                width: 40,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 30,
                width: 60,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ).animate(onPlay: (c) => c.repeat())
           .shimmer(duration: 1200.ms, delay: 300.ms),
        ],
      ),
    );
  }
}
