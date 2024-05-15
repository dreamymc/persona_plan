import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import this for date formatting
import 'package:persona_plan/db_helper.dart';
import 'package:persona_plan/enums.dart';

class AddTaskScreen extends StatefulWidget {
  final String username;

  AddTaskScreen({required this.username});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TaskStatus _selectedTaskStatus = TaskStatus.ToDo;
  Category _selectedTaskCategory = Category.Personal;
  TaskPriority _selectedTaskPriority = TaskPriority.Low;

  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _taskDescriptionController = TextEditingController();
  DateTime? _selectedDate; // Store selected due date

  void _submitTask() {
    final taskName = _taskNameController.text.trim();
    final taskDescription = _taskDescriptionController.text.trim();
    final dueDate = _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '';

    if (taskName.isNotEmpty && taskDescription.isNotEmpty && dueDate.isNotEmpty) {
      final newTask = {
        'task_name': taskName,
        'task_description': taskDescription,
        'due_date': dueDate,
        'priority': _selectedTaskPriority.index,
        'status': _selectedTaskStatus.toString().split('.').last,
        'category': _selectedTaskCategory.toString().split('.').last,
        'user_id': widget.username,
      };

      final dbHelper = DatabaseHelper.instance;
      dbHelper.insertTask(newTask);

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
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: _taskDescriptionController,
              decoration: InputDecoration(labelText: 'Task Description'),
            ),
            GestureDetector(
              onTap: () => _selectDate(context), // Call _selectDate on tap
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Due Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '',
                  ),
                ),
              ),
            ),
            DropdownButton<TaskStatus>(
              value: _selectedTaskStatus,
              onChanged: (newValue) {
                setState(() {
                  _selectedTaskStatus = newValue!;
                });
              },
              items: TaskStatus.values.map((status) {
                return DropdownMenuItem<TaskStatus>(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
            ),
            DropdownButton<Category>(
              value: _selectedTaskCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedTaskCategory = newValue!;
                });
              },
              items: Category.values.map((category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.toString().split('.').last),
                );
              }).toList(),
            ),
            DropdownButton<TaskPriority>(
              value: _selectedTaskPriority,
              onChanged: (newValue) {
                setState(() {
                  _selectedTaskPriority = newValue!;
                });
              },
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem<TaskPriority>(
                  value: priority,
                  child: Text(priority.toString().split('.').last),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitTask,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
