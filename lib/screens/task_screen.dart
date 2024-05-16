import 'dart:math';

import 'package:flutter/material.dart';
import 'package:persona_plan/db_helper.dart';

class TaskScreen extends StatefulWidget {
  final String username;

  TaskScreen({required this.username});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late Future<List<Map<String, dynamic>>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _getTasks();
  }

  Future<List<Map<String, dynamic>>> _getTasks() async {
    final dbHelper = DatabaseHelper.instance;
    return await dbHelper.getTasks(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          CustomPaint(
            size: Size.infinite,
            painter: RandomShapesPainter(),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              children: [
                AppBar(
                  title: Text('Tasks'),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _tasksFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        final tasks = snapshot.data ?? [];
                        return ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            final isDueDateRed =
                                DateTime.parse(task['due_date']).isBefore(
                              DateTime.now().add(Duration(days: 1)),
                            );

                            bool isCompleted = task['status'] == 'Completed';

                            return Container(
                              color: Colors.white,
                              child: ExpansionTile(
                                title: Text(
                                  task['task_name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isCompleted
                                        ? Colors.green
                                        : (isDueDateRed ? Colors.red : Colors.black45),
                                  ),
                                ),
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: ListTile(
                                      title: Text('Description: ${task['task_description']}'),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Due Date: ${task['due_date']}',
                                            style: TextStyle(
                                              color: isDueDateRed ? Colors.red : Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Priority: ${task['priority'] == 0 ? 'Low Priority' : 'High Priority'}',
                                          ),
                                          Text('Status: ${task['status']}'),
                                          Text('Category: ${task['category']}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Color.fromARGB(255, 98, 0, 255)),
                                      onPressed: () {
                                        // Edit task logic
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: const Color.fromARGB(255, 255, 0, 0)),
                                      onPressed: () {
                                        // Delete task logic
                                      },
                                    ),
                                    if (!isCompleted)
                                      IconButton(
                                        icon: Icon(Icons.check_circle, color: Colors.green),
                                        onPressed: () {
                                          // Mark task as completed logic
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RandomShapesPainter extends CustomPainter {
  List<Offset> lineCoordinates = [];
  List<Rect> rectangles = [];
  List<Offset> circleCenters = [];
  List<double> circleRadii = [];

  RandomShapesPainter() {
    final random = Random();

    // Generate random lines spanning across the screen
    for (int i = 0; i < 5; i++) {
      final startX = 0.0;
      final startY =
          random.nextDouble() * 400; // Adjust according to your screen size
      final endX = 400.0; // Adjust according to your screen size
      final endY =
          random.nextDouble() * 400; // Adjust according to your screen size
      lineCoordinates.add(Offset(startX, startY));
      lineCoordinates.add(Offset(endX, endY));
    }

    // Generate random rectangles
    for (int i = 0; i < 3; i++) {
      final left =
          random.nextDouble() * 400; // Adjust according to your screen size
      final top =
          random.nextDouble() * 400; // Adjust according to your screen size
      final right = left + random.nextDouble() * 100;
      final bottom = top + random.nextDouble() * 100;
      rectangles.add(Rect.fromLTRB(left, top, right, bottom));
    }

    // Generate random circles
    for (int i = 0; i < 3; i++) {
      final centerX =
          random.nextDouble() * 400; // Adjust according to your screen size
      final centerY =
          random.nextDouble() * 400; // Adjust according to your screen size
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
