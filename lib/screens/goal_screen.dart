import 'package:flutter/material.dart';
import 'package:persona_plan/db_helper.dart';
import 'home_screen.dart';

class GoalScreen extends StatefulWidget {
  final String username;

  GoalScreen({required this.username});

  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  late Future<List<Map<String, dynamic>>> _goalsFuture;

  @override
  void initState() {
    super.initState();
    _goalsFuture = _getGoals();
  }

  Future<List<Map<String, dynamic>>> _getGoals() async {
    final dbHelper = DatabaseHelper.instance;
    return await dbHelper.getGoals(widget.username);
  }

  void _displayGoalInformation(
      BuildContext context, Map<String, dynamic> goal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Goal Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${goal['goal_name']}'),
              Text('Deadline: ${goal['deadline']}'),
              Text('Status: ${goal['status']}'),
              Text('Category: ${goal['category']}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _editGoal(BuildContext context, Map<String, dynamic> goal) {
  String newGoalName = goal['goal_name'];
  DateTime newDeadline = DateTime.parse(goal['deadline']);
  String newStatus = goal['status'];
  String newCategory = goal['category'];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Goal Name'),
              onChanged: (value) => newGoalName = value,
              controller: TextEditingController(text: goal['goal_name']),
            ),
            ElevatedButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: newDeadline,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    newDeadline = selectedDate;
                  });
                }
              },
              child: Text('Select New Deadline'),
            ),
            Text('Current deadline is: ${newDeadline.toString()}'),
            DropdownButtonFormField<String>(
              value: newStatus,
              items: [
                'Pending',
                'InProgress',
                'Completed'
              ] // Ensure unique values
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => newStatus = value ?? newStatus,
            ),
            DropdownButtonFormField<String>(
              value: newCategory,
              items: ['Personal', 'School', 'Work', 'Others']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => newCategory = value ?? newCategory,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final dbHelper = DatabaseHelper.instance;
              await dbHelper.updateGoal(goal['goal_id'], {
                'goal_name': newGoalName,
                'deadline': newDeadline.toString(),
                'status': newStatus,
                'category': newCategory,
              });
              setState(() {
                _goalsFuture = _getGoals();
              });
              Navigator.of(context).pop();
            },
            child: Text('Save'),
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
        title: Text('Goals'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: RandomShapesPainter(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _goalsFuture,
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
                  final goals = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white
                                  .withOpacity(0.0)), // Light border color
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _displayGoalInformation(context, goal);
                          },
                          child: ListTile(
                            title: Text(goal['goal_name']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _editGoal(context, goal);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    final confirmDelete = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Confirm Delete'),
                                        content: Text(
                                            'Are you sure you want to delete this goal?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirmDelete == true) {
                                      final dbHelper = DatabaseHelper.instance;
                                      await dbHelper
                                          .deleteGoal(goal['goal_id']);
                                      setState(() {
                                        _goalsFuture = _getGoals();
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
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
    );
  }
}
