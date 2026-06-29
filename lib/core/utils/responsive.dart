import 'package:flutter/material.dart';

class R {
  final double _w;
  final double _h;
  final double _ss;

  R(BuildContext context)
      : _w  = MediaQuery.sizeOf(context).width,
        _h  = MediaQuery.sizeOf(context).height,
        _ss = MediaQuery.sizeOf(context).shortestSide;

  double get screenW => _w;
  double get screenH => _h;

  /// Width scale (design base: 390px)
  double w(double v) => v * _w / 390;
  /// Height scale (design base: 844px)
  double h(double v) => v * _h / 844;
  /// Font / radius scale
  double sp(double v) => v * _ss / 390;
  double r(double v)  => v * _ss / 390;

  bool get isSmall  => _w < 360;
  bool get isMedium => _w >= 360 && _w < 600;
  bool get isLarge  => _w >= 600;
}

extension RContext on BuildContext {
  R get r => R(this);
}
