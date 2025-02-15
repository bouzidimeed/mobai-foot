import 'package:flutter/material.dart';

class StadiumPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Set the background color to dark green
    final Paint backgroundPaint = Paint()..color = Colors.green[900]!;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Define paint for white lines
    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw the center circle
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.1;
    canvas.drawCircle(center, radius, whitePaint);

    // Draw the center line (vertical)
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      whitePaint,
    );

    // Draw the penalty areas (vertical orientation)
    final penaltyAreaWidth = size.width * 0.3;
    final penaltyAreaHeight = size.height * 0.2;

    // Top penalty area
    canvas.drawRect(
      Rect.fromLTWH(
        size.width / 2 - penaltyAreaWidth / 2,
        0,
        penaltyAreaWidth,
        penaltyAreaHeight,
      ),
      whitePaint,
    );

    // Bottom penalty area
    canvas.drawRect(
      Rect.fromLTWH(
        size.width / 2 - penaltyAreaWidth / 2,
        size.height - penaltyAreaHeight,
        penaltyAreaWidth,
        penaltyAreaHeight,
      ),
      whitePaint,
    );

    // Draw the goal areas (vertical orientation)
    final goalAreaWidth = size.width * 0.15;
    final goalAreaHeight = size.height * 0.1;

    // Top goal area
    canvas.drawRect(
      Rect.fromLTWH(
        size.width / 2 - goalAreaWidth / 2,
        0,
        goalAreaWidth,
        goalAreaHeight,
      ),
      whitePaint,
    );

    // Bottom goal area
    canvas.drawRect(
      Rect.fromLTWH(
        size.width / 2 - goalAreaWidth / 2,
        size.height - goalAreaHeight,
        goalAreaWidth,
        goalAreaHeight,
      ),
      whitePaint,
    );

    // Draw the penalty spots
    final penaltySpotRadius = 4.0;

    // Top penalty spot
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.15),
      penaltySpotRadius,
      whitePaint,
    );

    // Bottom penalty spot
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.85),
      penaltySpotRadius,
      whitePaint,
    );

    // Draw the arcs at the top and bottom of the penalty areas
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    // Top arc
    canvas.drawArc(
      arcRect,
      -3.14, // Start angle (in radians)
      6.28, // Sweep angle (full circle)
      false,
      whitePaint,
    );

    // Bottom arc
    canvas.drawArc(
      arcRect,
      0, // Start angle (in radians)
      3.14, // Sweep angle (half circle)
      false,
      whitePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
