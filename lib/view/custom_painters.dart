import 'package:flutter/material.dart';
import 'dart:math';

class StarsPainter extends CustomPainter {
  final List<Offset> stars;
  final double opacity;

  StarsPainter(this.stars, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity * 0.8)
      ..strokeWidth = 2;

    for (int i = 0; i < stars.length; i++) {
      final star = stars[i];
      final x = star.dx * size.width;
      final y = star.dy * size.height;
      
 
      final twinkle = sin(DateTime.now().millisecondsSinceEpoch * 0.01 + i) * 0.5 + 0.5;
      final radius = (2 + twinkle * 2);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
      

      if (twinkle > 0.7) {
        canvas.drawLine(
          Offset(x - 4, y), 
          Offset(x + 4, y), 
          paint..strokeWidth = 1,
        );
        canvas.drawLine(
          Offset(x, y - 4), 
          Offset(x, y + 4), 
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WavesPainter extends CustomPainter {
  final double progress;

  WavesPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final time = DateTime.now().millisecondsSinceEpoch * 0.002;

    for (int i = 0; i < 3; i++) {
      final radius = 80 + i * 30 + sin(time + i * 1.5) * 10;
      canvas.drawCircle(center, radius, paint);
    }

 
    final breathRadius = 60 + sin(time * 0.5) * 20;
    paint.color = Colors.white.withOpacity(0.05);
    canvas.drawCircle(center, breathRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}