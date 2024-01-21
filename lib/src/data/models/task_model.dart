import 'package:flutter_1/src/data/models/task_list_model.dart';

class TaskModel {
  int? id;
  String title;
  String description;
  DateTime? dueDate;
  DateTime? createdAt;
  String status;
  List<TaskList>? taskLists = [];

  TaskModel(
      {this.id,
      required this.title,
      required this.description,
      this.dueDate,
      this.createdAt,
      this.taskLists,
      required this.status});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate?.toIso8601String(), // Convert DateTime to string
      'created_at': createdAt?.toIso8601String(),
      "status": status,
    };
  }

  static TaskModel fromMap(Map<String, dynamic> map) {
    return TaskModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        dueDate:
            map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
        createdAt: map['created_at'] != null
            ? DateTime.parse(map['created_at'])
            : null,
        status: map["status"]);
  }

  // Add a copy method
  TaskModel copy({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? createdAt,
    String? status,
    List<TaskList>? taskLists,
  }) {
    return TaskModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        createdAt: createdAt ?? this.createdAt,
        taskLists: taskLists ?? this.taskLists,
        status: status ?? this.status);
  }
}
