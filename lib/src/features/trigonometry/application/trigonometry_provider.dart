import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import 'package:flutter/foundation.dart';

@immutable
class TrigonometryState {
  final double opposite;
  final double adjacent;
  final double hypotenuse;
  final double angleA;
  final double angleB;

  const TrigonometryState({
    this.opposite = 0,
    this.adjacent = 0,
    this.hypotenuse = 0,
    this.angleA = 0,
    this.angleB = 0,
  });

  TrigonometryState copyWith({
    double? opposite,
    double? adjacent,
    double? hypotenuse,
    double? angleA,
    double? angleB,
  }) {
    return TrigonometryState(
      opposite: opposite ?? this.opposite,
      adjacent: adjacent ?? this.adjacent,
      hypotenuse: hypotenuse ?? this.hypotenuse,
      angleA: angleA ?? this.angleA,
      angleB: angleB ?? this.angleB,
    );
  }
}

class TrigonometryNotifier extends Notifier<TrigonometryState> {
  @override
  TrigonometryState build() {
    return const TrigonometryState();
  }

  void updateOpposite(double value) {
    state = state.copyWith(opposite: value);
    _calculate();
  }

  void updateAdjacent(double value) {
    state = state.copyWith(adjacent: value);
    _calculate();
  }

  void updateHypotenuse(double value) {
    state = state.copyWith(hypotenuse: value);
    _calculate();
  }

  void updateAngleA(double value) {
    state = state.copyWith(angleA: value);
    _calculate();
  }

  void updateAngleB(double value) {
    state = state.copyWith(angleB: value);
    _calculate();
  }

  void reset() {
    state = const TrigonometryState();
  }

  void _calculate() {
    var s = state;
    int providedValues = [s.opposite, s.adjacent, s.hypotenuse, s.angleA, s.angleB].where((v) => v > 0).length;
    if (providedValues < 2) return;

    var o = s.opposite, a = s.adjacent, h = s.hypotenuse, alpha = s.angleA, beta = s.angleB;

    // Loop until no new values can be calculated in a full pass
    while (true) {
      int calculatedCountBeforePass = [o, a, h, alpha, beta].where((v) => v > 0).length;

      // Pythagorean theorem
      if (h <= 0 && o > 0 && a > 0) h = sqrt(pow(o, 2) + pow(a, 2));
      if (a <= 0 && o > 0 && h > 0) a = sqrt(pow(h, 2) - pow(o, 2));
      if (o <= 0 && a > 0 && h > 0) o = sqrt(pow(h, 2) - pow(a, 2));

      // Angle sum
      if (beta <= 0 && alpha > 0) beta = 90 - alpha;
      if (alpha <= 0 && beta > 0) alpha = 90 - beta;

      // SOH CAH TOA
      if (alpha > 0) {
        final alphaRad = alpha * pi / 180;
        if (o <= 0 && h > 0) o = h * sin(alphaRad);
        if (a <= 0 && h > 0) a = h * cos(alphaRad);
        if (o <= 0 && a > 0) o = a * tan(alphaRad);
        if (a <= 0 && o > 0) a = o / tan(alphaRad);
        if (h <= 0 && o > 0) h = o / sin(alphaRad);
        if (h <= 0 && a > 0) h = a / cos(alphaRad);
      }
      
      if (alpha <= 0) {
        if (o > 0 && h > 0) alpha = asin(o / h) * 180 / pi;
        else if (a > 0 && h > 0) alpha = acos(a / h) * 180 / pi;
        else if (o > 0 && a > 0) alpha = atan(o / a) * 180 / pi;
      }

      int calculatedCountAfterPass = [o, a, h, alpha, beta].where((v) => v > 0).length;

      if (calculatedCountAfterPass == calculatedCountBeforePass) {
        break; // Exit loop if no new values were calculated
      }
    }

    state = state.copyWith(
      opposite: o > 0 ? o : 0,
      adjacent: a > 0 ? a : 0,
      hypotenuse: h > 0 ? h : 0,
      angleA: alpha > 0 ? alpha : 0,
      angleB: beta > 0 ? beta : 0,
    );
  }
}

final trigonometryProvider = NotifierProvider<TrigonometryNotifier, TrigonometryState>(TrigonometryNotifier.new);
