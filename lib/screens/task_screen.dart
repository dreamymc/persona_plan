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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 205, 147, 216), 
              Color.fromARGB(255, 134, 202, 245), // Blue color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
                        final isDueDateRed = DateTime.parse(task['due_date']).isBefore(
                          DateTime.now().add(Duration(days: 1)),
                        );

                        bool isCompleted = task['status'] == 'Completed';

                        return ExpansionTile(
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
                            ListTile(
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
                                      'Priority: ${task['priority'] == 0 ? 'Low Priority' : 'High Priority'}'),
                                  Text('Status: ${task['status']}'),
                                  Text('Category: ${task['category']}'),
                                ],
                              ),
                            ),
                          ],
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String newTaskName = task['task_name'];
                                      String newDescription = task['task_description'];
                                      String newDueDate = task['due_date'];
                                      int newPriority = task['priority'];
                                      String newStatus = task['status'];
                                      String newCategory = task['category'];

                                      return AlertDialog(
                                        title: Text('Edit Task'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              decoration: InputDecoration(
                                                  labelText: 'Task Name'),
                                              onChanged: (value) => newTaskName = value,
                                              controller: TextEditingController(
                                                  text: task['task_name']),
                                            ),
                                            TextField(
                                              decoration: InputDecoration(
                                                  labelText: 'Description'),
                                              onChanged: (value) =>
                                                  newDescription = value,
                                              controller: TextEditingController(
                                                  text: task['task_description']),
                                            ),
                                            TextField(
                                              decoration: InputDecoration(
                                                  labelText: 'Due Date'),
                                              controller: TextEditingController(
                                                  text: task['due_date']),
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate:
                                                      DateTime.parse(task['due_date']),
                                                  firstDate: DateTime.now(),
                                                  lastDate:
                                                      DateTime(DateTime.now().year + 5),
                                                );
                                                if (pickedDate != null) {
                                                  setState(() {
                                                    newDueDate = pickedDate.toString();
                                                  });
                                                }
                                              },
                                            ),
                                            DropdownButtonFormField<String>(
                                              value: newStatus,
                                              items: [
                                                'ToDo',
                                                'Pending',
                                                'Completed' // Include 'Completed'
                                              ] // Check this list for duplicates or mismatches with newStatus
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (value) =>
                                                  newStatus = value ?? newStatus,
                                            ),
                                            DropdownButtonFormField<String>(
                                              value: newCategory,
                                              items: [
                                                'Personal',
                                                'School',
                                                'Work',
                                                'Others'
                                              ] // Check this list for duplicates or mismatches with newCategory
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (value) =>
                                                  newCategory = value ?? newCategory,
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
                                              await dbHelper
                                                  .updateTask(task['task_id'], {
                                                'task_name': newTaskName,
                                                'task_description': newDescription,
                                                'due_date': newDueDate,
                                                'priority': newPriority,
                                                'status': newStatus,
                                                'category': newCategory,
                                              });
                                              setState(() {
                                                _tasksFuture = _getTasks();
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.white),
                                onPressed: () async {
                                  final confirmDelete = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Confirm Delete'),
                                      content: Text(
                                          'Are you sure you want to delete this task?'),
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
                                    await dbHelper.deleteTask(task['task_id']);
                                    setState(() {
                                      _tasksFuture = _getTasks();
                                    });
                                  }
                                },
                              ),
                              if (!isCompleted)
                                IconButton(
                                  icon: Icon(Icons.check_circle, color: Colors.white),
                                  onPressed: () async {
                                    final dbHelper = DatabaseHelper.instance;
                                    await dbHelper.updateTaskStatus(
                                        task['task_id'], 'Completed');
                                    setState(() {
                                      _tasksFuture = _getTasks();
                                    });
                                  },
                                ),
                            ],
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
    );
  }
}
