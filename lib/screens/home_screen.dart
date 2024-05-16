import 'package:flutter/material.dart';
import 'package:persona_plan/db_helper.dart';
import '../add_task_screen.dart';
import '../add_goal_screen.dart';
import 'task_screen.dart';
import 'goal_screen.dart';
import 'about_screen.dart';
import 'login_screen.dart'; // Import login screen to navigate back
import 'dart:math';

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions(String username) => <Widget>[
        Home(username: username),
        TaskScreen(username: username),
        GoalScreen(username: username),
        AboutScreen(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add new item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            AddTaskScreen(username: widget.username)),
                  );
                },
                child: Text('Add Task'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            AddGoalScreen(username: widget.username)),
                  );
                },
                child: Text('Add Goal'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _logout() {
    // Display a confirmation dialog before logging out
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Clear any user authentication state and navigate back to login screen
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PersonaPlan'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Call logout function when button is pressed
          ),
        ],
        flexibleSpace: Container(
            decoration: BoxDecoration(
            color: Color.fromARGB(255, 168, 106, 255),
            ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 250, 255),
            ),
          ),
          CustomPaint(
            size: Size.infinite,
            painter: RandomShapesPainter(),
          ),
          _widgetOptions(widget.username).elementAt(_selectedIndex),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.blue),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task, color: Colors.blue),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag, color: Colors.blue),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, color: Colors.blue),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        selectedIconTheme: IconThemeData(color: Colors.blue),
        unselectedIconTheme: IconThemeData(color: Colors.blue),
        selectedLabelStyle: TextStyle(color: Colors.blue),
        unselectedLabelStyle: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class Home extends StatelessWidget {
  final String username;

  Home({required this.username});

  Future<int> _getTaskCount() async {
    final dbHelper = DatabaseHelper.instance;
    return await dbHelper.getTaskCount(username);
  }

  Future<int> _getGoalCount() async {
    final dbHelper = DatabaseHelper.instance;
    return await dbHelper.getGoalCount(username);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(100.0),
              ),
              padding: EdgeInsets.all(5.0),
              child: Text(
                'Welcome, ${username.substring(0, 1).toUpperCase()}${username.substring(1)}!',
                style: TextStyle(fontSize: 24),
              ),
            ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<int>(
                future: _getTaskCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Tasks: ${snapshot.data}',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }
                },
              ),
              SizedBox(width: 20),
              FutureBuilder<int>(
                future: _getGoalCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 241, 161, 255),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Goals: ${snapshot.data}',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }
                },
              ),
            ],
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
      final startY = random.nextDouble() * 400; // Adjust according to your screen size
      final endX = 400.0; // Adjust according to your screen size
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
