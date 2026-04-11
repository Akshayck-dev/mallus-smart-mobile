import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MagneticWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;
  final double scaleUp;

  const MagneticWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.96,
    this.scaleUp = 1.04,
  });

  @override
  State<MagneticWrapper> createState() => _MagneticWrapperState();
}

class _MagneticWrapperState extends State<MagneticWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: widget.scaleDown).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    HapticFeedback.selectionClick();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse().then((_) {
      _controller.animateTo(1.0, duration: const Duration(milliseconds: 200), curve: Curves.elasticOut);
    });
    if (widget.onTap != null) widget.onTap!();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
