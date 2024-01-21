// task_state.dart
import 'package:flutter_1/src/data/models/task_model.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {
  final TaskModel? task;
  final List<TaskModel> tasks;

  TaskInitial(this.task, this.tasks);
}

class TaskLoading extends TaskState {}

class TaskCreationSuccess extends TaskState {}

class TasksLoaded extends TaskState {
  final List<TaskModel> tasks;

  TasksLoaded(this.tasks);
}

class TasksSuccess extends TaskState {
  final String status;
  TasksSuccess(this.status);
}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);
}

class TaskUpdated extends TaskState {
  final TaskModel task;

  TaskUpdated(this.task);
}
