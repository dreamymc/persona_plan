import 'dart:math';
import 'package:flutter/material.dart';

class RandomShapesPainter extends CustomPainter {
  List<Offset> lineCoordinates = [];
  List<Rect> rectangles = [];
  List<Offset> circleCenters = [];
  List<double> circleRadii = [];

  RandomShapesPainter() {
    final random = Random();

    // Generate random lines spanning across the screen
    for (int i = 0; i < 5; i++) {
      const startX = 0.0;
      final startY = random.nextDouble() * 400; // Adjust according to your screen size
      const endX = 400.0; // Adjust according to your screen size
      final endY = random.nextDouble() * 400; // Adjust according to your screen size
      lineCoordinates.add(Offset(startX, startY));
      lineCoordinates.add(Offset(endX, endY));
    }

    // Generate random rectangles
    for (int i = 0; i < 3; i++) {
      final left = random.nextDouble() * 400; // Adjust according to your screen size
      final top = random.nextDouble() * 400; // Adjust according to your screen size
      final right = left + random.nextDouble() * 100;
      final bottom = top + random.nextDouble() * 100;
      rectangles.add(Rect.fromLTRB(left, top, right, bottom));
    }

    // Generate random circles
    for (int i = 0; i < 3; i++) {
      final centerX = random.nextDouble() * 400; // Adjust according to your screen size
      final centerY = random.nextDouble() * 400; // Adjust according to your screen size
      final radius = random.nextDouble() * 50;
      circleCenters.add(Offset(centerX, centerY));
      circleRadii.add(radius);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw lines
    for (int i = 0; i < lineCoordinates.length; i += 2) {
      canvas.drawLine(lineCoordinates[i], lineCoordinates[i + 1], paint);
    }

    // Draw rectangles
    for (final rect in rectangles) {
      canvas.drawRect(rect, paint);
    }

    // Draw circles
    for (int i = 0; i < circleCenters.length; i++) {
      canvas.drawCircle(circleCenters[i], circleRadii[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: RandomShapesPainter(),
            size: Size.infinite,
          ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                ),
                child: const Text(
                'PersonaPlan is your personal task and goal management app.',
                style: TextStyle(fontSize: 20),
                softWrap: true,
                ),
              ),
              ),
            ),
        ],
      ),
    );
  }
}
