import 'dart:math' as math;
import 'package:flutter/material.dart';

class ProgressPainter extends CustomPainter {
  late double startAngle;
  late double sweepAngle;
  final AnimationController controller;

  ProgressPainter(this.controller) {
    startAngle = Tween(begin: math.pi * 1.5, end: math.pi * 3.5)
        .chain(CurveTween(curve: const Interval(0.5, 1.0)))
        .evaluate(controller);
    sweepAngle = math.sin(controller.value * math.pi) * math.pi;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double side = math.min(size.width, size.height);
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Offset.zero & Size(side, side),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(ProgressPainter other) {
    return startAngle != other.startAngle || sweepAngle != other.sweepAngle;
  }
}
