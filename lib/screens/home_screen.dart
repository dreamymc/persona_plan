import 'package:flutter/material.dart';
import 'package:persona_plan/db_helper.dart';
import '../add_task_screen.dart';
import '../add_goal_screen.dart';
import 'task_screen.dart';
import 'goal_screen.dart';
import 'about_screen.dart';
import 'login_screen.dart'; // Import login screen to navigate back

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
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue, const Color.fromARGB(255, 205, 147, 216)],
        ),
          ),
        ),
      ),
      body: _widgetOptions(widget.username).elementAt(_selectedIndex),
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
        backgroundColor: Color.fromARGB(255, 212, 157, 255),
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
  String username;

  Home({required this.username});

  Future<int> _getTaskCount() async {
    final dbHelper = DatabaseHelper.instance;
    print("task user:" + username);
    return await dbHelper.getTaskCount(username);
  }

  Future<int> _getGoalCount() async {
    final dbHelper = DatabaseHelper.instance;
    print("goal user:" + username);
    return await dbHelper.getGoalCount(username);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purple[200]!, Colors.lightBlue[200]!],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text('Welcome, $username!', style: TextStyle(fontSize: 24)),
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
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [const Color.fromARGB(255, 226, 168, 236), Color.fromARGB(255, 8, 144, 255)], // Change gradient colors for task count
                        ),
                        border: Border.all(color: Colors.black),
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
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [const Color.fromARGB(255, 77, 148, 207), const Color.fromARGB(255, 241, 161, 255)], // Change gradient colors for goal count
                        ),
                        border: Border.all(color: Colors.black),
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
