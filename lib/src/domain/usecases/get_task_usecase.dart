import 'package:flutter_1/src/data/models/task_model.dart';
import 'package:flutter_1/src/data/repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<TaskModel>> call() async {
    return repository.getTasks();
  }
}
