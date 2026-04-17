import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mallu_smart/core/utils/app_animations.dart';

class Bounceable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final ValueChanged<TapDownDetails>? onTapDown;
  final ValueChanged<TapUpDetails>? onTapUp;
  final VoidCallback? onTapCancel;
  final double scaleDown;
  final bool useHaptic;

  const Bounceable({
    super.key,
    required this.child,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.scaleDown = AppAnimations.scaleDownFactor,
    this.useHaptic = true,
  });

  @override
  State<Bounceable> createState() => _BounceableState();
}

class _BounceableState extends State<Bounceable> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.durationFast,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null || widget.onTapDown != null) {
      setState(() => _isPressed = true);
      _controller.forward();
      if (widget.useHaptic) HapticFeedback.lightImpact();
      widget.onTapDown?.call(details);
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null || widget.onTapUp != null) {
      setState(() => _isPressed = false);
      _controller.reverse();
      widget.onTapUp?.call(details);
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null || widget.onTapCancel != null) {
      setState(() => _isPressed = false);
      _controller.reverse();
      widget.onTapCancel?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null || widget.onTapDown != null ? _onTapDown : null,
      onTapUp: widget.onTap != null || widget.onTapUp != null ? _onTapUp : null,
      onTapCancel: widget.onTap != null || widget.onTapCancel != null ? _onTapCancel : null,
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: widget.child
          .animate(
            target: _isPressed ? 1 : 0,
            autoPlay: false,
          )
          .scale(
            begin: const Offset(1, 1),
            end: Offset(widget.scaleDown, widget.scaleDown),
            duration: AppAnimations.durationFast,
            curve: Curves.easeOutQuart,
          ),
    );
  }
}
