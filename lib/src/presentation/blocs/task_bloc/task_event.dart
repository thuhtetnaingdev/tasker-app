// task_event.dart
import 'package:flutter_1/src/data/models/task_list_model.dart';
import 'package:flutter_1/src/data/models/task_model.dart';

abstract class TaskEvent {}

class CreateTaskEvent extends TaskEvent {
  final TaskModel task;
  final List<TaskList> taskLists;

  CreateTaskEvent(this.task, this.taskLists);
}

class GetTasksEvent extends TaskEvent {}

class UpdateTaskEvent extends TaskEvent {
  final TaskModel task;
  final List<TaskList> taskLists;

  UpdateTaskEvent(this.task, this.taskLists);
}

