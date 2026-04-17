import 'package:flutter/material.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ConfettiCelebration extends StatefulWidget {
  final VoidCallback onComplete;
  const ConfettiCelebration({super.key, required this.onComplete});

  @override
  State<ConfettiCelebration> createState() => _ConfettiCelebrationState();
}

class _ConfettiCelebrationState extends State<ConfettiCelebration> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      widget.onComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: CuratorDesign.primary.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: CuratorDesign.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'ORDER PLACED!',
                style: CuratorDesign.label(12, weight: FontWeight.w900, color: Colors.white)
                    .copyWith(letterSpacing: 2),
              ),
            ],
          ),
        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).fadeIn().then(delay: 2000.ms).fadeOut(),
      ),
    );
  }
}

/// Dynamic helper to show confetti anywhere in the app
void showConfetti(BuildContext context) {
  OverlayState? overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => ConfettiCelebration(
      onComplete: () {
        overlayEntry.remove();
      },
    ),
  );

  overlayState.insert(overlayEntry);
}
