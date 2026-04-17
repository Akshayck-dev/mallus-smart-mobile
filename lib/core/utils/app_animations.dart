import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppAnimations {
  // Durations as per premium rules
  static const Duration durationFast = Duration(milliseconds: 300);
  static const Duration durationStandard = Duration(milliseconds: 500);
  static const Duration durationSlow = Duration(milliseconds: 800);
  static const Duration durationLanguid = Duration(milliseconds: 1200);

  // Curves (Premium ease)
  static const Curve standardCurve = Curves.easeOutQuart;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.easeOutBack;

  // Animation values
  static const double scaleDownFactor = 0.92;
  static const double scaleUpFactor = 1.08;

  // Stagger helper
  static const Duration staggerDelay = Duration(milliseconds: 80);

  // Reusable Effect lists
  static List<Effect> premiumFadeIn = [
    FadeEffect(duration: durationStandard, curve: standardCurve),
    SlideEffect(begin: const Offset(0, 0.05), end: Offset.zero, duration: durationSlow, curve: standardCurve),
    ScaleEffect(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: durationSlow, curve: standardCurve),
  ];

  static List<Effect> staggerEntry(int index) => [
    FadeEffect(delay: staggerDelay * index, duration: durationStandard),
    SlideEffect(
      begin: const Offset(0, 0.1), 
      end: Offset.zero, 
      delay: staggerDelay * index, 
      duration: durationSlow, 
      curve: standardCurve,
    ),
    ScaleEffect(
      begin: const Offset(0.9, 0.9), 
      end: const Offset(1, 1), 
      delay: staggerDelay * index, 
      duration: durationSlow, 
      curve: standardCurve,
    ),
  ];

  static List<Effect> hoverEffect = [
    ScaleEffect(begin: const Offset(1, 1), end: const Offset(1.03, 1.03), duration: durationFast, curve: standardCurve),
  ];

  static List<Effect> pressEffect = [
    ScaleEffect(begin: const Offset(1, 1), end: Offset(scaleDownFactor, scaleDownFactor), duration: 150.ms, curve: standardCurve),
  ];
}
