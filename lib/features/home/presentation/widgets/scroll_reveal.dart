import 'dart:ui';
import 'package:flutter/material.dart';

/// Refined scroll reveal for light UIs: soft slide, layered parallax, and fade.
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final ValueNotifier<double> scrollNotifier;
  final Duration delay;
  final Duration duration;
  final Offset fromOffset;
  final double fromScale;
  final double fromBlur;
  final double fromAngle; // rotateX in radians (perspective lean)
  final bool useBlur;
  final bool use3d;
  final bool useViewportOffset;
  final bool useParallax;
  final double parallaxExtent;
  final double parallaxScale;
  final double minVisibleOpacity;
  final double exitDriftFactor;
  final double
  triggerFraction; // 0..1 — how far into viewport before triggering

  const ScrollReveal({
    super.key,
    required this.child,
    required this.scrollNotifier,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 720),
    this.fromOffset = const Offset(0, 20),
    this.fromScale = 0.978,
    this.fromBlur = 0.0,
    this.fromAngle = 0.0,
    this.useBlur = false,
    this.use3d = false,
    this.useViewportOffset = false,
    this.useParallax = true,
    this.parallaxExtent = 16,
    this.parallaxScale = 0.014,
    this.minVisibleOpacity = 0.58,
    this.exitDriftFactor = 0.42,
    this.triggerFraction = 0.96,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _t; // 0 → 1 eased
  bool _triggered = false;
  double _centerRatio = 0.5;
  double _visibility = 1.0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _t = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutQuart);
    widget.scrollNotifier.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    widget.scrollNotifier.removeListener(_handleScroll);
    _ctrl.dispose();
    super.dispose();
  }

  void _check() {
    if (_triggered || !mounted) return;
    _updateViewportMetrics();
    if (_visibility <= 0) return;
    if (_centerRatio < widget.triggerFraction) {
      _triggered = true;
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  void _updateViewportMetrics() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final screenH = MediaQuery.sizeOf(context).height;
    final pos = box.localToGlobal(Offset.zero);
    final centerY = pos.dy + box.size.height / 2;
    _centerRatio = centerY / screenH;

    final topFade = ((centerY - screenH * 0.02) / (screenH * 0.20)).clamp(
      0.0,
      1.0,
    );
    final bottomFade = ((screenH * 0.99 - centerY) / (screenH * 0.28)).clamp(
      0.0,
      1.0,
    );
    _visibility = topFade < bottomFade ? topFade : bottomFade;
  }

  void _handleScroll() {
    if (!mounted) return;
    final oldCenter = _centerRatio;
    final oldVisibility = _visibility;
    _updateViewportMetrics();
    if (!_triggered) {
      _check();
      return;
    }
    if ((oldCenter - _centerRatio).abs() > 0.006 ||
        (oldVisibility - _visibility).abs() > 0.012) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (_, child) {
        final v = _t.value;
        final size = MediaQuery.sizeOf(context);
        _updateViewportMetrics();
        final dx = widget.useViewportOffset
            ? widget.fromOffset.dx * size.width
            : widget.fromOffset.dx;
        final dy = widget.useViewportOffset
            ? widget.fromOffset.dy * size.height
            : widget.fromOffset.dy;
        final depth = (0.52 - _centerRatio).clamp(-1.0, 1.0);
        final edgeFade = (1 - _visibility).clamp(0.0, 1.0);
        final exitDirection = _centerRatio < 0.5 ? -1.0 : 1.0;
        final parallaxY = widget.useParallax
            ? depth * widget.parallaxExtent * 0.82 +
                  exitDirection *
                      edgeFade *
                      widget.parallaxExtent *
                      widget.exitDriftFactor
            : 0.0;
        final parallaxX = widget.useParallax
            ? (dx == 0 ? 0.0 : dx.sign * edgeFade * 14)
            : 0.0;
        final settleOpacity = widget.useParallax
            ? (widget.minVisibleOpacity +
                      (1 - widget.minVisibleOpacity) * _visibility)
                  .clamp(widget.minVisibleOpacity, 1.0)
            : 1.0;
        final settleScale = widget.useParallax
            ? (1 - (1 - _visibility) * widget.parallaxScale).clamp(0.965, 1.0)
            : 1.0;

        Widget result = child!;

        // 1. Translate
        result = Transform.translate(
          offset: Offset(dx * (1 - v) + parallaxX, dy * (1 - v) + parallaxY),
          child: result,
        );

        // 2. Scale
        result = Transform.scale(
          scale:
              (widget.fromScale + (1.0 - widget.fromScale) * v) * settleScale,
          child: result,
        );

        // 3. Blur (applied to child, not backdrop)
        if (widget.useBlur) {
          final sigma = widget.fromBlur * (1 - v);
          if (sigma > 0.2) {
            result = ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: result,
            );
          }
        }

        // 4. Fade
        final opacityFloor = _triggered ? widget.minVisibleOpacity : 0.0;
        result = Opacity(
          opacity: (v.clamp(0.0, 1.0) * settleOpacity).clamp(opacityFloor, 1.0),
          child: result,
        );

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
    this.baseDelay = Duration.zero,
    this.staggerDelay = const Duration(milliseconds: 80),
    this.fromOffset = const Offset(0, 36),
    this.use3d = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .asMap()
          .entries
          .map(
            (e) => ScrollReveal(
              scrollNotifier: scrollNotifier,
              delay: baseDelay + staggerDelay * e.key,
              fromOffset: fromOffset,
              use3d: use3d,
              child: e.value,
            ),
          )
          .toList(),
    );
  }
}
