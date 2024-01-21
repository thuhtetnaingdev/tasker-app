class TaskList {
  int? id;
  int? taskId;
  String description;
  bool complete;

  TaskList({
    this.id,
    this.taskId,
    required this.description,
    this.complete = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_id': taskId,
      'description': description,
      'complete': complete ? 1 : 0,
    };
  }

  static TaskList fromMap(Map<String, dynamic> map) {
    return TaskList(
      id: map['id'],
      taskId: map['task_id'],
      description: map['description'],
      complete: map['complete'] == 1,
    );
  }

  //add copy method
  TaskList copy({int? id, int? taskId, String? description, bool? complete}) {
    return TaskList(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      description: description ?? this.description,
      complete: complete ?? this.complete,
    );
  }
}
