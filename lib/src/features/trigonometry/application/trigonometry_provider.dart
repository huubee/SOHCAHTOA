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
  // Track which fields are user-provided (not calculated)
  final Set<String> _userProvidedFields = {};
  // Track the order of first two fields entered
  final List<String> _firstTwoFields = [];

  @override
  TrigonometryState build() {
    return const TrigonometryState();
  }

  // Check if a field is editable (must be one of the first two entered)
  bool isFieldEditable(String fieldName) {
    // If we have less than 2 fields, all fields are editable
    if (_firstTwoFields.length < 2) {
      return true;
    }
    // Otherwise, only the first two fields are editable
    return _firstTwoFields.contains(fieldName);
  }

  void _addFieldIfNew(String fieldName, double value) {
    if (value > 0 && !_userProvidedFields.contains(fieldName)) {
      _userProvidedFields.add(fieldName);
      // Track as one of the first two if we don't have two yet
      if (_firstTwoFields.length < 2 && !_firstTwoFields.contains(fieldName)) {
        _firstTwoFields.add(fieldName);
      }
    } else if (value <= 0) {
      _userProvidedFields.remove(fieldName);
      _firstTwoFields.remove(fieldName);
    }
  }

  void updateOpposite(double value) {
    if (!isFieldEditable('opposite') && value > 0) {
      return; // Don't allow updates to non-editable fields
    }
    _addFieldIfNew('opposite', value);
    state = state.copyWith(opposite: value > 0 ? value : 0);
    _calculate();
  }

  void updateAdjacent(double value) {
    if (!isFieldEditable('adjacent') && value > 0) {
      return; // Don't allow updates to non-editable fields
    }
    _addFieldIfNew('adjacent', value);
    state = state.copyWith(adjacent: value > 0 ? value : 0);
    _calculate();
  }

  void updateHypotenuse(double value) {
    if (!isFieldEditable('hypotenuse') && value > 0) {
      return; // Don't allow updates to non-editable fields
    }
    _addFieldIfNew('hypotenuse', value);
    state = state.copyWith(hypotenuse: value > 0 ? value : 0);
    _calculate();
  }

  void updateAngleA(double value) {
    if (!isFieldEditable('angleA') && value > 0) {
      return; // Don't allow updates to non-editable fields
    }
    if (value > 0 && value < 90) {
      _addFieldIfNew('angleA', value);
    } else {
      _userProvidedFields.remove('angleA');
      _firstTwoFields.remove('angleA');
    }
    state = state.copyWith(angleA: value > 0 && value < 90 ? value : 0);
    _calculate();
  }

  void updateAngleB(double value) {
    if (!isFieldEditable('angleB') && value > 0) {
      return; // Don't allow updates to non-editable fields
    }
    if (value > 0 && value < 90) {
      _addFieldIfNew('angleB', value);
    } else {
      _userProvidedFields.remove('angleB');
      _firstTwoFields.remove('angleB');
    }
    state = state.copyWith(angleB: value > 0 && value < 90 ? value : 0);
    _calculate();
  }

  void reset() {
    _userProvidedFields.clear();
    _firstTwoFields.clear();
    state = const TrigonometryState();
  }

  void _calculate() {
    var s = state;
    
    // Get user-provided values (only these should be preserved)
    final userProvidedO = _userProvidedFields.contains('opposite');
    final userProvidedA = _userProvidedFields.contains('adjacent');
    final userProvidedH = _userProvidedFields.contains('hypotenuse');
    final userProvidedAlpha = _userProvidedFields.contains('angleA');
    final userProvidedBeta = _userProvidedFields.contains('angleB');
    
    // Count how many user-provided values we have
    int providedValues = [userProvidedO, userProvidedA, userProvidedH, userProvidedAlpha, userProvidedBeta].where((v) => v).length;
    
    if (providedValues < 2) {
      // Clear all non-user-provided values before returning
      state = state.copyWith(
        opposite: userProvidedO ? s.opposite : 0,
        adjacent: userProvidedA ? s.adjacent : 0,
        hypotenuse: userProvidedH ? s.hypotenuse : 0,
        angleA: userProvidedAlpha ? s.angleA : 0,
        angleB: userProvidedBeta ? s.angleB : 0,
      );
      return;
    }

    // First, clear state of all non-user-provided values to ensure clean calculation
    state = state.copyWith(
      opposite: userProvidedO ? s.opposite : 0,
      adjacent: userProvidedA ? s.adjacent : 0,
      hypotenuse: userProvidedH ? s.hypotenuse : 0,
      angleA: userProvidedAlpha ? s.angleA : 0,
      angleB: userProvidedBeta ? s.angleB : 0,
    );

    // Start fresh - only use user-provided values, reset calculated ones
    double o = userProvidedO ? s.opposite : 0.0;
    double a = userProvidedA ? s.adjacent : 0.0;
    double h = userProvidedH ? s.hypotenuse : 0.0;
    double alpha = userProvidedAlpha ? s.angleA : 0.0;
    double beta = userProvidedBeta ? s.angleB : 0.0;

    // Loop until no new values can be calculated in a full pass
    int maxIterations = 10; // Prevent infinite loops
    int iteration = 0;
    while (iteration < maxIterations) {
      iteration++;
      int calculatedCountBeforePass = [o, a, h, alpha, beta].where((v) => v > 0).length;

      // Angle sum (do this first as it's simple and helps with other calculations)
      if (!userProvidedBeta && alpha > 0 && alpha < 90) {
        beta = 90 - alpha;
      }
      if (!userProvidedAlpha && beta > 0 && beta < 90) {
        alpha = 90 - beta;
      }

      // Track which values we've calculated in this iteration to avoid overwriting
      bool calculatedO = false;
      bool calculatedA = false;
      bool calculatedH = false;

      // SOH CAH TOA using angle alpha (prioritize if user provided alpha)
      // For angle α: adjacent = a, opposite = o, hypotenuse = h
      if (alpha > 0 && alpha < 90) {
        final alphaRad = alpha * pi / 180;
        final sinAlpha = sin(alphaRad);
        final cosAlpha = cos(alphaRad);
        final tanAlpha = tan(alphaRad);
        
        // cos(α) = adjacent / hypotenuse → hypotenuse = adjacent / cos(α)
        // Do this first as it's often needed
        if (!userProvidedH && a > 0 && cosAlpha.abs() > 1e-10) {
          h = a / cosAlpha;
          calculatedH = true;
        }
        // sin(α) = opposite / hypotenuse → hypotenuse = opposite / sin(α)
        if (!userProvidedH && !calculatedH && o > 0 && sinAlpha.abs() > 1e-10) {
          h = o / sinAlpha;
          calculatedH = true;
        }
        // tan(α) = opposite / adjacent → opposite = adjacent * tan(α)
        if (!userProvidedO && a > 0 && tanAlpha.abs() > 1e-10) {
          o = a * tanAlpha;
          calculatedO = true;
        }
        // sin(α) = opposite / hypotenuse → opposite = hypotenuse * sin(α)
        if (!userProvidedO && !calculatedO && h > 0 && sinAlpha.abs() > 1e-10) {
          o = h * sinAlpha;
          calculatedO = true;
        }
        // cos(α) = adjacent / hypotenuse → adjacent = hypotenuse * cos(α)
        if (!userProvidedA && h > 0 && cosAlpha.abs() > 1e-10) {
          a = h * cosAlpha;
          calculatedA = true;
        }
        // tan(α) = opposite / adjacent → adjacent = opposite / tan(α)
        if (!userProvidedA && !calculatedA && o > 0 && tanAlpha.abs() > 1e-10) {
          a = o / tanAlpha;
          calculatedA = true;
        }
      }

      // SOH CAH TOA using angle beta (only if user provided beta, or if alpha calculations couldn't help)
      // For angle β: adjacent = o (opposite to α), opposite = a (adjacent to α), hypotenuse = h
      // Only use beta if user provided beta, or if we still need to calculate something that alpha couldn't
      if (beta > 0 && beta < 90 && userProvidedBeta) {
        final betaRad = beta * pi / 180;
        final sinBeta = sin(betaRad);
        final cosBeta = cos(betaRad);
        final tanBeta = tan(betaRad);
        
        // cos(β) = adjacent / hypotenuse → for β, adjacent is o, so h = o / cos(β)
        if (!userProvidedH && !calculatedH && o > 0 && cosBeta.abs() > 1e-10) {
          h = o / cosBeta;
          calculatedH = true;
        }
        // sin(β) = opposite / hypotenuse → for β, opposite is a, so h = a / sin(β)
        if (!userProvidedH && !calculatedH && a > 0 && sinBeta.abs() > 1e-10) {
          h = a / sinBeta;
          calculatedH = true;
        }
        // tan(β) = opposite / adjacent → for β, opposite is a, adjacent is o, so o = a / tan(β)
        if (!userProvidedO && !calculatedO && a > 0 && tanBeta.abs() > 1e-10) {
          o = a / tanBeta;
          calculatedO = true;
        }
        // cos(β) = adjacent / hypotenuse → for β, adjacent is o, so o = h * cos(β)
        if (!userProvidedO && !calculatedO && h > 0 && cosBeta.abs() > 1e-10) {
          o = h * cosBeta;
          calculatedO = true;
        }
        // tan(β) = opposite / adjacent → for β, opposite is a, adjacent is o, so a = o * tan(β)
        if (!userProvidedA && !calculatedA && o > 0 && tanBeta.abs() > 1e-10) {
          a = o * tanBeta;
          calculatedA = true;
        }
        // sin(β) = opposite / hypotenuse → for β, opposite is a, so a = h * sin(β)
        if (!userProvidedA && !calculatedA && h > 0 && sinBeta.abs() > 1e-10) {
          a = h * sinBeta;
          calculatedA = true;
        }
      }

      // Pythagorean theorem (with validation) - only use if not provided by user
      if (!userProvidedH && o > 0 && a > 0) {
        h = sqrt(pow(o, 2) + pow(a, 2));
      }
      if (!userProvidedA && o > 0 && h > 0 && h > o) {
        final aSquared = (pow(h, 2) - pow(o, 2)).toDouble();
        if (aSquared >= 0) {
          a = sqrt(aSquared);
        }
      }
      if (!userProvidedO && a > 0 && h > 0 && h > a) {
        final oSquared = (pow(h, 2) - pow(a, 2)).toDouble();
        if (oSquared >= 0) {
          o = sqrt(oSquared);
        }
      }
      
      // Calculate angle alpha from sides (with validation)
      // Only calculate if we don't have alpha yet and can't get it from beta
      if (!userProvidedAlpha && alpha <= 0) {
        if (o > 0 && h > 0 && h > o) {
          final ratio = o / h;
          if (ratio >= -1 && ratio <= 1) {
            alpha = asin(ratio) * 180 / pi;
          }
        } else if (a > 0 && h > 0 && h > a) {
          final ratio = a / h;
          if (ratio >= -1 && ratio <= 1) {
            alpha = acos(ratio) * 180 / pi;
          }
        } else if (o > 0 && a > 0) {
          alpha = atan(o / a) * 180 / pi;
        }
      }

      // Calculate angle beta from sides (with validation)
      // Only calculate if we don't have beta yet and can't get it from alpha
      if (!userProvidedBeta && beta <= 0) {
        // For β: opposite is a, adjacent is o
        if (a > 0 && h > 0 && h > a) {
          final ratio = a / h;
          if (ratio >= -1 && ratio <= 1) {
            beta = asin(ratio) * 180 / pi;
          }
        } else if (o > 0 && h > 0 && h > o) {
          final ratio = o / h;
          if (ratio >= -1 && ratio <= 1) {
            beta = acos(ratio) * 180 / pi;
          }
        } else if (a > 0 && o > 0) {
          beta = atan(a / o) * 180 / pi;
        }
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
      angleA: alpha > 0 && alpha < 90 ? alpha : 0,
      angleB: beta > 0 && beta < 90 ? beta : 0,
    );
  }
}

final trigonometryProvider = NotifierProvider<TrigonometryNotifier, TrigonometryState>(TrigonometryNotifier.new);
