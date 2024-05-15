import 'package:flutter/material.dart';
import 'package:persona_plan/db_helper.dart';
import 'package:persona_plan/enums.dart';
import 'package:intl/intl.dart';

class AddGoalScreen extends StatefulWidget {
  final String username;

  AddGoalScreen({required this.username});

  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  GoalStatus _selectedGoalStatus = GoalStatus.Pending;
  Category _selectedGoalCategory = Category.Personal;

  TextEditingController _goalNameController = TextEditingController();
  DateTime? _selectedDate; // Store selected deadline

  void _submitGoal() {
    final goalName = _goalNameController.text.trim();
    final deadline = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : '';

    if (goalName.isNotEmpty && deadline.isNotEmpty) {
      final newGoal = {
        'goal_name': goalName,
        'deadline': deadline,
        'status': _selectedGoalStatus.toString().split('.').last,
        'category': _selectedGoalCategory.toString().split('.').last,
        'user_id': widget.username,
      };

      final dbHelper = DatabaseHelper.instance;
      dbHelper.insertGoal(newGoal);

      Navigator.pop(context); // Close the screen
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Goal'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _goalNameController,
              decoration: InputDecoration(labelText: 'Goal Name'),
            ),
            GestureDetector(
              onTap: () => _selectDate(context), // Call _selectDate on tap
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Deadline',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: _selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                        : '',
                  ),
                ),
              ),
            ),
            DropdownButton<Category>(
              value: _selectedGoalCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedGoalCategory = newValue!;
                });
              },
              items: Category.values.map((category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.toString().split('.').last),
                );
              }).toList(),
            ),
            DropdownButton<GoalStatus>(
              value: _selectedGoalStatus,
              onChanged: (newValue) {
                setState(() {
                  _selectedGoalStatus = newValue!;
                });
              },
              items: GoalStatus.values.map((status) {
                return DropdownMenuItem<GoalStatus>(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitGoal,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
