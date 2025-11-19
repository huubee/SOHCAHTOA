import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:myapp/src/features/trigonometry/application/trigonometry_provider.dart';

class TrianglePainter extends CustomPainter {
  final Color color;
  final TrigonometryState state;

  TrianglePainter({required this.color, required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Define a safe drawing rectangle with padding
    final Rect drawingRect = Rect.fromLTRB(
      size.width * 0.1, // 10% left padding
      size.height * 0.1, // 10% top padding
      size.width * 0.9, // 10% right padding
      size.height * 0.9, // 10% bottom padding
    );

    // Define the desired aspect ratio of the adjacent to opposite side
    const double aspectRatio = 2.5;

    double adjacentWidth;
    double oppositeHeight;

    // Calculate triangle dimensions to fit inside the drawingRect while maintaining aspect ratio
    if (drawingRect.width / drawingRect.height < aspectRatio) {
      // Width is the limiting factor
      adjacentWidth = drawingRect.width;
      oppositeHeight = adjacentWidth / aspectRatio;
    } else {
      // Height is the limiting factor
      oppositeHeight = drawingRect.height;
      adjacentWidth = oppositeHeight * aspectRatio;
    }

    // Center the triangle at the bottom of the drawing rect
    final double startX = drawingRect.left + (drawingRect.width - adjacentWidth) / 2;
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

    // Prepare labels with values
    final adjacentLabel = 'Adjacent${_formatValue(state.adjacent)}';
    final oppositeLabel = 'Opposite${_formatValue(state.opposite)}';
    final hypotenuseLabel = 'Hypotenuse${_formatValue(state.hypotenuse)}';
    final angleALabel = 'α${_formatValue(state.angleA, isAngle: true)}';
    final angleBLabel = 'β${_formatValue(state.angleB, isAngle: true)}';

    // Draw labels for sides
    _drawText(adjacentLabel, (p1.dx + p2.dx) / 2, p1.dy + 25, canvas);
    _drawText(oppositeLabel, p1.dx - 45, (p1.dy + p3.dy) / 2, canvas, -math.pi / 2);

    // Draw hypotenuse label
    final hypotenuseMidPoint = Offset((p2.dx + p3.dx) / 2, (p2.dy + p3.dy) / 2);
    final hypotenuseAngle = math.atan2(p2.dy - p3.dy, p2.dx - p3.dx);
    _drawText(hypotenuseLabel, hypotenuseMidPoint.dx, hypotenuseMidPoint.dy - 20, canvas, hypotenuseAngle);

    // Draw labels for angles
    _drawText('γ = 90°', p1.dx + 45, p1.dy - 45, canvas);
    _drawText(angleALabel, p2.dx, p2.dy + 25, canvas); // Alpha below the corner
    _drawText(angleBLabel, p3.dx - 30, p3.dy, canvas); // Beta to the left of the corner

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
