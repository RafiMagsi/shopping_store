import 'package:flutter/widgets.dart';

class SectionSnapScrollPhysics extends ScrollPhysics {
  final List<double> anchors;
  final double topInset;

  const SectionSnapScrollPhysics({
    super.parent,
    required this.anchors,
    this.topInset = 0,
  });

  @override
  SectionSnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SectionSnapScrollPhysics(
      parent: buildParent(ancestor),
      anchors: anchors,
      topInset: topInset,
    );
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final parentSimulation = super.createBallisticSimulation(
      position,
      velocity,
    );
    if (anchors.length < 2) return parentSimulation;

    final tolerance = toleranceFor(position);
    final min = position.minScrollExtent;
    final max = position.maxScrollExtent;

    if ((velocity <= 0 && position.pixels <= min) ||
        (velocity >= 0 && position.pixels >= max)) {
      return parentSimulation;
    }

    final target = _getTargetPixels(position, velocity, min, max);
    if ((target - position.pixels).abs() < tolerance.distance &&
        velocity.abs() < tolerance.velocity) {
      return null;
    }

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      target,
      velocity,
      tolerance: tolerance,
    );
  }

  double _getTargetPixels(
    ScrollMetrics position,
    double velocity,
    double min,
    double max,
  ) {
    final snapAnchors =
        anchors
            .map((anchor) => (anchor - topInset).clamp(min, max).toDouble())
            .toSet()
            .toList()
          ..sort();

    if (snapAnchors.isEmpty) return position.pixels.clamp(min, max);

    final pixels = position.pixels;
    const flingThreshold = 240.0;

    double nearest() {
      return snapAnchors.reduce(
        (a, b) => (a - pixels).abs() < (b - pixels).abs() ? a : b,
      );
    }

    if (velocity.abs() < flingThreshold) return nearest();

    if (velocity > 0) {
      for (final anchor in snapAnchors) {
        if (anchor > pixels + 12) return anchor;
      }
      return snapAnchors.last;
    }

    for (final anchor in snapAnchors.reversed) {
      if (anchor < pixels - 12) return anchor;
    }
    return snapAnchors.first;
  }
}
