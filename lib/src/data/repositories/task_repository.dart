import 'package:flutter_1/src/data/models/task_list_model.dart';

import '../models/task_model.dart';
import '../datasources/task_datasource.dart';

class TaskRepository {
  final TaskDataSource dataSource;

  TaskRepository(this.dataSource);

  Future<TaskModel> createTask(TaskModel task, List<TaskList> taskLists) async {
    return dataSource.createTask(task, taskLists);
  }

  Future<List<TaskModel>> getTasks() async {
    return dataSource.getTasks();
  }

  Future<TaskModel> updateTask(TaskModel task, List<TaskList> taskLists) async {
    return dataSource.updateTask(task, taskLists);
  }
}
