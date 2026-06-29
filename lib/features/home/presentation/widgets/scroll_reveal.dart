import 'dart:ui';
import 'package:flutter/material.dart';

/// Premium scroll reveal: blur(12→0) + scale(0.85→1) + 3D rotateX lean + fade.
/// All driven by viewport detection on [scrollNotifier].
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final ValueNotifier<double> scrollNotifier;
  final Duration delay;
  final Duration duration;
  final Offset fromOffset;
  final double fromScale;
  final double fromBlur;
  final double fromAngle;     // rotateX in radians (perspective lean)
  final bool useBlur;
  final bool use3d;
  final double triggerFraction; // 0..1 — how far into viewport before triggering

  const ScrollReveal({
    super.key,
    required this.child,
    required this.scrollNotifier,
    this.delay        = Duration.zero,
    this.duration     = const Duration(milliseconds: 700),
    this.fromOffset   = const Offset(0, 40),
    this.fromScale    = 0.88,
    this.fromBlur     = 10.0,
    this.fromAngle    = 0.10,
    this.useBlur      = true,
    this.use3d        = true,
    this.triggerFraction = 1.05,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _t; // 0 → 1 eased
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _t = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutQuart);
    widget.scrollNotifier.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    widget.scrollNotifier.removeListener(_check);
    _ctrl.dispose();
    super.dispose();
  }

  void _check() {
    if (_triggered || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final screenH = MediaQuery.sizeOf(context).height;
    final pos = box.localToGlobal(Offset.zero);
    if (pos.dy < screenH * widget.triggerFraction) {
      _triggered = true;
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (_, child) {
        final v = _t.value;

        Widget result = child!;

        // 1. Translate
        result = Transform.translate(
          offset: Offset(
            widget.fromOffset.dx * (1 - v),
            widget.fromOffset.dy * (1 - v),
          ),
          child: result,
        );

        // 2. Scale
        result = Transform.scale(
          scale: widget.fromScale + (1.0 - widget.fromScale) * v,
          child: result,
        );

        // 3. 3D perspective lean (rotateX)
        if (widget.use3d && widget.fromAngle != 0) {
          final angle = widget.fromAngle * (1 - v);
          result = Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0008)
              ..rotateX(angle),
            alignment: Alignment.bottomCenter,
            child: result,
          );
        }

        // 4. Blur (applied to child, not backdrop)
        if (widget.useBlur) {
          final sigma = widget.fromBlur * (1 - v);
          if (sigma > 0.2) {
            result = ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: result,
            );
          }
        }

        // 5. Fade
        result = Opacity(opacity: v.clamp(0.0, 1.0), child: result);

        return result;
      },
      child: widget.child,
    );
  }
}

/// Staggered column reveal — wraps children with incrementing delays.
class StaggeredReveal extends StatelessWidget {
  final List<Widget> children;
  final ValueNotifier<double> scrollNotifier;
  final Duration baseDelay;
  final Duration staggerDelay;
  final Offset fromOffset;
  final bool use3d;

  const StaggeredReveal({
    super.key,
    required this.children,
    required this.scrollNotifier,
    this.baseDelay     = Duration.zero,
    this.staggerDelay  = const Duration(milliseconds: 80),
    this.fromOffset    = const Offset(0, 36),
    this.use3d         = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((e) => ScrollReveal(
        scrollNotifier: scrollNotifier,
        delay: baseDelay + staggerDelay * e.key,
        fromOffset: fromOffset,
        use3d: use3d,
        child: e.value,
      )).toList(),
    );
  }
}
