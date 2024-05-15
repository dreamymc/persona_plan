class Task {
  final int? id;
  final String name;
  final String description;
  final String dueDate;
  final int priority;
  final String status;
  final String category;
  final int userId;

  Task({
    this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.category,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'task_id': id,
      'task_name': name,
      'task_description': description,
      'due_date': dueDate,
      'priority': priority,
      'status': status,
      'category': category,
      'user_id': userId,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['task_id'],
      name: map['task_name'],
      description: map['task_description'],
      dueDate: map['due_date'],
      priority: map['priority'],
      status: map['status'],
      category: map['category'],
      userId: map['user_id'],
    );
  }
}