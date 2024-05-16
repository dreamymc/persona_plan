import 'dart:math';
import 'package:flutter/material.dart';

import 'home_screen.dart';


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
                child: const Text(
                'PersonaPlan is an intuitive task and goal management app designed for individuals with ADHD. It aids in organizing tasks, setting reminders, and prioritizing activities. With its user-friendly features, PersonaPlan assists users in staying focused and productive. \n\nFuture updates include notifications, and scheduled alarm!',
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
