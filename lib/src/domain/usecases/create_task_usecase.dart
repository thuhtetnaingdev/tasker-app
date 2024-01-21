import 'package:flutter_1/src/data/models/task_list_model.dart';

import '../../data/repositories/task_repository.dart';
import '../../data/models/task_model.dart';

class CreateTaskUseCase {
  final TaskRepository repository;

  CreateTaskUseCase(this.repository);

  Future<TaskModel> call(TaskModel task, List<TaskList> taskLists) async {
    return repository.createTask(task, taskLists);
  }
}
