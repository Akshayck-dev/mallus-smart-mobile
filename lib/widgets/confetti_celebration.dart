import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
        child: Lottie.network(
          'https://lottie.host/808b26a1-0f46-4cb8-8c10-09b2e0f4f46c/2eU12Q6Xo3.json',
          width: 400,
          height: 400,
          repeat: false,
        ),
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
