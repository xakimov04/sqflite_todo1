class Task {
  int? id;
  String title;
  String description;
  String priority;
  String status;
  String date;
  String category;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'date': date,
      'category': category,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: map['priority'],
      status: map['status'],
      date: map['date'],
      category: map['category'],
    );
  }
}
