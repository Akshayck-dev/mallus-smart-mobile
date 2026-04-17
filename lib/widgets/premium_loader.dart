import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mallu_smart/core/utils/design_system.dart';

class PremiumCuratorLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const PremiumCuratorLoader({
    super.key,
    this.size = 60.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? CuratorDesign.primaryOrange;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The Rotating Gradient Ring
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 2 * math.pi),
              duration: const Duration(seconds: 2),
              curve: Curves.linear,
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: value,
                  child: CustomPaint(
                    size: Size(size, size),
                    painter: _GradientRingPainter(color: activeColor),
                  ),
                );
              },
            ),
          ).animate(onPlay: (controller) => controller.repeat())
           .rotate(duration: 1500.ms),

          // Central Pulsating Glow
          SizedBox(
            width: size * 0.25,
            height: size * 0.25,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scale(
              begin: const Offset(0.8, 0.8), 
              end: const Offset(1.2, 1.2), 
              duration: 800.ms, 
              curve: Curves.easeInOut
            )
           .fadeIn(duration: 800.ms),
           
          // Outer subtle shimmer ring
          Container(
            width: size * 1.1,
            height: size * 1.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: activeColor.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat())
           .shimmer(duration: 2000.ms, color: Colors.white24),
        ],
      ),
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  final Color color;

  _GradientRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.1),
          color,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect.deflate(paint.strokeWidth / 2),
      0,
      math.pi * 1.7, // Keep a small gap for movement feel
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
