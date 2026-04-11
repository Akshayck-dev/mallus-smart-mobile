import 'package:flutter/material.dart';
import '../utils/design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DeepHeatButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;

  const DeepHeatButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
  });

  @override
  State<DeepHeatButton> createState() => _DeepHeatButtonState();
}

class _DeepHeatButtonState extends State<DeepHeatButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    // Using a spring-like curve for a more "physical" snap-back feel
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          onTap: () {
            HapticFeedback.mediumImpact();
            widget.onTap();
          },
          child: Transform.scale(
            scale: _scale.value,
            child: Container(
              width: widget.width ?? double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: CuratorDesign.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15), // Inner highlight
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    // Shadow shrinks and lightens as button is pressed (dynamic depth)
                    color: CuratorDesign.accent.withValues(alpha: 0.2 + (0.1 * (_scale.value - 0.96) / 0.04)),
                    blurRadius: 10 + (10 * (_scale.value - 0.96) / 0.04),
                    offset: Offset(0, 4 + (4 * (_scale.value - 0.96) / 0.04)),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Subtle top glow for a 3D effect
                  Positioned(
                    top: -12,
                    child: Container(
                      width: 120,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Text(
                    widget.text,
                    style: CuratorDesign.label(14).copyWith(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .shimmer(delay: 3.seconds, duration: 2500.ms, color: Colors.white24);
  }
}
