// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_1/src/data/models/task_model.dart';
import 'package:flutter_1/src/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:flutter_1/src/presentation/blocs/task_bloc/task_state.dart';
import 'package:flutter_1/src/presentation/screens/create_task_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class TaskDetailsPage extends StatefulWidget {
  final TaskModel task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  TaskModel? updatedTask;

  @override
  void initState() {
    super.initState();
    // updatedTask = widget.task;
  }

  void _editTask(BuildContext context, TaskModel task) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => CreateTaskPage(
                taskData: task,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskUpdated) {
          updatedTask = state.task;
        }
      },
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          final task = updatedTask ?? widget.task;
          String dueDateText = DateFormat('dd MMM').format(task.dueDate!);
          final currentDate = DateTime.now();
          final isOverdue = task.dueDate!.isBefore(currentDate);
          return Scaffold(
            appBar: AppBar(
              title: Text(task.title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editTask(context, task),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    task.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.description,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Due Date: ${task.dueDate != null ? DateFormat('dd MMM yyyy').format(task.dueDate!) : ''}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: task.dueDate != null,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: isOverdue
                                  ? const Color(0xFF491C19)
                                  : const Color(0xFF4BCE97),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        size: 22,
                                        color: isOverdue
                                            ? const Color.fromARGB(
                                                255, 203, 82, 71)
                                            : Colors.black),
                                    const Gap(4),
                                    Text(
                                      dueDateText,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: isOverdue
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            color: task.status == 'pending'
                                ? const Color(0xFFFFD700)
                                : const Color(0xFF4BCE97),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(task.status),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Lists',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ...task.taskLists!.map((taskList) {
                    return CheckboxListTile(
                      title: Text(taskList.description),
                      value: taskList.complete,
                      onChanged: (bool? newValue) {
                        setState(() {
                          taskList.complete = newValue!;
                        });
                        // Optionally, update the task list item in the database
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
