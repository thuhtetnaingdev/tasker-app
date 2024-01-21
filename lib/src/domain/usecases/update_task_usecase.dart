import 'package:flutter_1/src/data/models/task_list_model.dart';
import 'package:flutter_1/src/data/models/task_model.dart';
import 'package:flutter_1/src/data/repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository taskRepository;
  UpdateTaskUseCase(this.taskRepository);

  Future<TaskModel> call(TaskModel task, List<TaskList> taskLists) async {
    return taskRepository.updateTask(task, taskLists);
  }
}
