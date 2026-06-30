import 'dart:math' as math;
import 'package:flutter/material.dart';

class SparkleLayer extends StatefulWidget {
  final Color color;
  final int seed;
  final int count;
  final double maxSize;
  final double minOpacity;
  final double maxOpacity;

  const SparkleLayer({
    super.key,
    required this.color,
    required this.seed,
    this.count = 7,
    this.maxSize = 10,
    this.minOpacity = 0.04,
    this.maxOpacity = 0.14,
  });

  @override
  State<SparkleLayer> createState() => _SparkleLayerState();
}

class _SparkleLayerState extends State<SparkleLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_SparkleSpec> _specs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3600 + widget.seed * 90),
    )..repeat();

    final random = math.Random(widget.seed);
    _specs = List.generate(widget.count, (index) {
      return _SparkleSpec(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 3 + random.nextDouble() * (widget.maxSize - 3),
        phase: random.nextDouble() * math.pi * 2,
        drift: 3 + random.nextDouble() * 8,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value * math.pi * 2;
          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: _specs.map((spec) {
                  final shimmer = (math.sin(t + spec.phase) + 1) / 2;
                  final opacity =
                      widget.minOpacity +
                      (widget.maxOpacity - widget.minOpacity) * shimmer;
                  final dx = math.cos(t + spec.phase) * spec.drift;
                  final dy = math.sin(t * 0.82 + spec.phase) * spec.drift;

                  return Positioned(
                    left: spec.x * constraints.maxWidth + dx,
                    top: spec.y * constraints.maxHeight + dy,
                    child: Opacity(
                      opacity: opacity,
                      child: Transform.scale(
                        scale: 0.8 + shimmer * 0.45,
                        child: Container(
                          width: spec.size,
                          height: spec.size,
                          decoration: BoxDecoration(
                            color: widget.color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: widget.color.withValues(alpha: opacity),
                                blurRadius: spec.size * 1.8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}

class _SparkleSpec {
  final double x;
  final double y;
  final double size;
  final double phase;
  final double drift;

  const _SparkleSpec({
    required this.x,
    required this.y,
    required this.size,
    required this.phase,
    required this.drift,
  });
}
