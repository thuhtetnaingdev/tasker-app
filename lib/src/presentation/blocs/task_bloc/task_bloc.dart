// task_bloc.dart
import 'package:flutter_1/src/data/datasources/task_datasource.dart';
import 'package:flutter_1/src/data/repositories/task_repository.dart';
import 'package:flutter_1/src/domain/usecases/create_task_usecase.dart';
import 'package:flutter_1/src/domain/usecases/get_task_usecase.dart';
import 'package:flutter_1/src/domain/usecases/update_task_usecase.dart';
import 'package:flutter_1/src/presentation/blocs/task_bloc/task_event.dart';
import 'package:flutter_1/src/presentation/blocs/task_bloc/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final CreateTaskUseCase createTaskUseCase;
  final GetTasksUseCase getTasksUseCase;
  final UpdateTaskUseCase updateTaskUseCase;

  TaskBloc(this.createTaskUseCase, this.getTasksUseCase, this.updateTaskUseCase)
      : super(TaskInitial(null, List.empty())) {
    on<CreateTaskEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        await createTaskUseCase(event.task, event.taskLists);
        final tasks = await getTasksUseCase(); // Refresh the list of tasks
        emit(TasksLoaded(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<GetTasksEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasksData = await getTasksUseCase();
        emit(TasksLoaded(tasksData));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<UpdateTaskEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        final updatedTask =
            await updateTaskUseCase(event.task, event.taskLists);
        emit(TaskUpdated(updatedTask)); // Emit an updated task
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });
  }
}
