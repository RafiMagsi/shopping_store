import 'package:flutter/material.dart';

/// Wraps [child] with a real-time 3D tilt that reacts to its position in
/// the viewport as the user scrolls.
///
/// Cards in the upper viewport lean forward (positive rotateX) giving the
/// illusion they are "falling toward" the user. Cards below center lean back.
/// The effect creates a cinematic curved-plane feel like premium product sites.
class ScrollTilt3D extends StatefulWidget {
  final Widget child;
  final ValueNotifier<double> scrollNotifier;

  /// How strong the tilt is. 1.0 = ±0.14 rad at extremes.
  final double intensity;

  /// Whether to also apply a subtle Y-axis rotation (horizontal tilt).
  final bool rotateY;

  const ScrollTilt3D({
    super.key,
    required this.child,
    required this.scrollNotifier,
    this.intensity = 1.0,
    this.rotateY   = false,
  });

  @override
  State<ScrollTilt3D> createState() => _ScrollTilt3DState();
}

class _ScrollTilt3DState extends State<ScrollTilt3D>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lerp;
  double _targetTilt = 0.0;
  double _currentTilt = 0.0;

  @override
  void initState() {
    super.initState();
    // Smooth lerp controller (120fps-compatible)
    _lerp = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addListener(_smoothUpdate)
      ..repeat();
    widget.scrollNotifier.addListener(_measure);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void dispose() {
    _lerp.dispose();
    widget.scrollNotifier.removeListener(_measure);
    super.dispose();
  }

  void _measure() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final screenH = MediaQuery.sizeOf(context).height;
    final pos = box.localToGlobal(Offset.zero);
    final centerY = pos.dy + box.size.height / 2;
    // Map: screen top → +max, screen center → 0, screen bottom → -max
    _targetTilt = ((centerY - screenH / 2) / screenH * 0.28 * widget.intensity)
        .clamp(-0.18, 0.18);
  }

  void _smoothUpdate() {
    if (!mounted) return;
    final next = _currentTilt + (_targetTilt - _currentTilt) * 0.12;
    if ((next - _currentTilt).abs() > 0.0003) {
      setState(() => _currentTilt = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0008) // perspective
        ..rotateX(-_currentTilt),
      alignment: Alignment.center,
      child: widget.child,
    );
  }
}

/// Horizontal tilt — for items in a horizontal ListView.
/// Cards lean left/right based on their position relative to screen center X.
class HorizontalTilt3D extends StatefulWidget {
  final Widget child;
  final ValueNotifier<double> scrollNotifier; // the HORIZONTAL scroll notifier

  const HorizontalTilt3D({
    super.key,
    required this.child,
    required this.scrollNotifier,
  });

  @override
  State<HorizontalTilt3D> createState() => _HorizontalTilt3DState();
}

class _HorizontalTilt3DState extends State<HorizontalTilt3D>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loop;
  double _tilt = 0.0;
  double _target = 0.0;

  @override
  void initState() {
    super.initState();
    _loop = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addListener(_smooth)
      ..repeat();
    widget.scrollNotifier.addListener(_measure);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void dispose() {
    _loop.dispose();
    widget.scrollNotifier.removeListener(_measure);
    super.dispose();
  }

  void _measure() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final screenW = MediaQuery.sizeOf(context).width;
    final pos = box.localToGlobal(Offset.zero);
    final centerX = pos.dx + box.size.width / 2;
    _target = ((centerX - screenW / 2) / screenW * 0.22).clamp(-0.18, 0.18);
  }

  void _smooth() {
    if (!mounted) return;
    final next = _tilt + (_target - _tilt) * 0.14;
    if ((next - _tilt).abs() > 0.0003) {
      setState(() => _tilt = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0008)
        ..rotateY(-_tilt),
      alignment: Alignment.center,
      child: widget.child,
    );
  }
}
