import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:trig_sct/src/features/trigonometry/application/trigonometry_provider.dart';
import 'package:trig_sct/src/localization/app_localizations.dart';

class TrianglePainter extends CustomPainter {
  final Color color;
  final TrigonometryState state;
  final double animationValue; // 0.0 = default triangle, 1.0 = calculated triangle
  final AppLocalizations? localizations;

  TrianglePainter({
    required this.color,
    required this.state,
    this.animationValue = 0.0,
    this.localizations,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Define a safe drawing rectangle with padding - use 95% of width
    // Ensure we're using the actual available width
    final availableWidth = size.width;
    final availableHeight = size.height;
    final Rect drawingRect = Rect.fromLTRB(
      availableWidth * 0.025, // 2.5% left padding
      availableHeight * 0.1, // 10% top padding
      availableWidth * 0.975, // 2.5% right padding (95% total width)
      availableHeight * 0.9, // 10% bottom padding
    );

    // Check if we have angle alpha and at least 2 values
    final hasAngleAlpha = state.angleA > 0 && state.angleA < 90;
    final hasTwoValues = [
      state.opposite > 0,
      state.adjacent > 0,
      state.hypotenuse > 0,
      state.angleA > 0,
      state.angleB > 0,
    ].where((v) => v).length >= 2;

    // Default aspect ratio (for initial/default triangle)
    const double defaultAspectRatio = 2.5;

    double adjacentWidth;
    double oppositeHeight;

    if (hasAngleAlpha && hasTwoValues && animationValue > 0) {
      // Calculate triangle based on angle alpha
      // Use full width available (95% of screen)
      final alphaRad = state.angleA * math.pi / 180;
      
      // Use full drawing rect width as adjacent side
      final calculatedAdjacent = drawingRect.width;
      final calculatedOpposite = calculatedAdjacent * math.tan(alphaRad);
      
      // Scale only if opposite is too tall
      final maxHeight = drawingRect.height * 0.85;
      double scale = 1.0;
      if (calculatedOpposite > maxHeight) {
        scale = maxHeight / calculatedOpposite;
      }
      
      final scaledAdjacent = calculatedAdjacent * scale;
      final scaledOpposite = calculatedOpposite * scale;
      
      // Interpolate between default and calculated triangle
      final defaultAdjacent = drawingRect.width;
      final defaultOpposite = defaultAdjacent / defaultAspectRatio;
      
      adjacentWidth = defaultAdjacent + (scaledAdjacent - defaultAdjacent) * animationValue;
      oppositeHeight = defaultOpposite + (scaledOpposite - defaultOpposite) * animationValue;
    } else {
      // Use default aspect ratio - ensure we use the full available width (95%)
      // Always use width as the limiting factor to maximize horizontal space
      adjacentWidth = drawingRect.width; // Use full 95% width
      oppositeHeight = adjacentWidth / defaultAspectRatio;
      
      // Only limit by height if triangle would be too tall
      if (oppositeHeight > drawingRect.height) {
        oppositeHeight = drawingRect.height;
        adjacentWidth = oppositeHeight * defaultAspectRatio;
      }
    }

    // Position triangle to use full width - start at left edge of drawing rect
    final double startX = drawingRect.left;
    final double startY = drawingRect.bottom;

    final p1 = Offset(startX, startY); // Bottom-left (γ)
    final p2 = Offset(startX + adjacentWidth, startY); // Bottom-right (α)
    final p3 = Offset(startX, startY - oppositeHeight); // Top-left (β)

    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    canvas.drawPath(path, paint);

    // Prepare labels with values - show only first letter when value is present
    final adjacentLabel = state.adjacent > 0 
        ? 'A${_formatValue(state.adjacent)}' 
        : (localizations?.adjacent ?? 'Adjacent');
    final oppositeLabel = state.opposite > 0 
        ? 'O${_formatValue(state.opposite)}' 
        : (localizations?.opposite ?? 'Opposite');
    final hypotenuseLabel = state.hypotenuse > 0 
        ? 'H${_formatValue(state.hypotenuse)}' 
        : (localizations?.hypotenuse ?? 'Hypotenuse');
    final angleALabel = 'α${_formatValue(state.angleA, isAngle: true)}';
    final angleBLabel = 'β${_formatValue(state.angleB, isAngle: true)}';

    // Draw labels for sides - all with 15px offset
    // Adjacent label - 15px below the adjacent line
    _drawText(adjacentLabel, (p1.dx + p2.dx) / 2, p1.dy + 15, canvas);
    // Opposite label - 15px to the left of the opposite line
    final oppositeLabelX = p1.dx - 15;
    _drawText(oppositeLabel, oppositeLabelX, (p1.dy + p3.dy) / 2, canvas, -math.pi / 2);

    // Draw hypotenuse label - 15px above the line (towards top of triangle)
    final hypotenuseMidPoint = Offset((p2.dx + p3.dx) / 2, (p2.dy + p3.dy) / 2);
    final hypotenuseAngle = math.atan2(p2.dy - p3.dy, p2.dx - p3.dx);
    // Calculate normal vector pointing "upward" (towards p3, which has smaller Y)
    // The hypotenuse vector is (p3 - p2), so the upward normal is perpendicular to it
    final dx = p3.dx - p2.dx;
    final dy = p3.dy - p2.dy;
    final length = math.sqrt(dx * dx + dy * dy);
    // Normal vector pointing upward (rotate 90 degrees counterclockwise)
    final normalX = -dy / length;
    final normalY = dx / length;
    // Offset distance above the line - 15px
    final offsetDistance = 15.0;
    final offsetX = normalX * offsetDistance;
    final offsetY = normalY * offsetDistance;
    _drawText(hypotenuseLabel, hypotenuseMidPoint.dx + offsetX, hypotenuseMidPoint.dy + offsetY, canvas, hypotenuseAngle);

    // Draw labels for angles - position to avoid overlaps
    // Gamma label - below the adjacent line, on the left side
    _drawText('γ = 90°', p1.dx + 20, p1.dy + 15, canvas);
    _drawText(angleALabel, p2.dx, p2.dy + 25, canvas); // Alpha below the corner
    // Beta label positioned above the angle, to the right, to avoid hypotenuse overlap
    _drawText(angleBLabel, p3.dx + 40, p3.dy - 25, canvas); // Beta above and to the right

    // Right angle arc
    final rect = Rect.fromCircle(center: p1, radius: 20);
    canvas.drawArc(rect, -math.pi / 2, math.pi / 2, false, paint);
  }

  String _formatValue(double value, {bool isAngle = false}) {
    if (value <= 0) return '';
    final displayValue = value.toStringAsFixed(2);
    return ': $displayValue${isAngle ? '°' : ''}';
  }

  void _drawText(String text, double x, double y, Canvas canvas, [double angle = 0]) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle);
    textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
