class Goal {
  final int? id;
  final String name;
  final String deadline;
  final String status;
  final String category;
  final int userId;

  Goal({
    this.id,
    required this.name,
    required this.deadline,
    required this.status,
    required this.category,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'goal_id': id,
      'goal_name': name,
      'deadline': deadline,
      'status': status,
      'category': category,
      'user_id': userId,
    };
  }

  static Goal fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['goal_id'],
      name: map['goal_name'],
      deadline: map['deadline'],
      status: map['status'],
      category: map['category'],
      userId: map['user_id'],
    );
  }
}
  