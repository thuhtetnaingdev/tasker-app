// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_1/src/data/models/task_list_model.dart';
import 'package:flutter_1/src/data/models/task_model.dart';
import 'package:flutter_1/src/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:flutter_1/src/presentation/blocs/task_bloc/task_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class CreateTaskPage extends StatefulWidget {
  final TaskModel? taskData;

  const CreateTaskPage({super.key, this.taskData});

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  DateTime? dueDate;
  List<TextEditingController> taskItemControllers = [];

  void _saveEditTask() {
    final task = TaskModel(
        id: widget.taskData?.id,
        title: titleController.text,
        description: descriptionController.text,
        dueDate: dueDate,
        taskLists: taskItemControllers
            .map((controller) => TaskList(description: controller.text))
            .toList(),
        status: "pending");
    if (widget.taskData == null) {
      BlocProvider.of<TaskBloc>(context)
          .add(CreateTaskEvent(task, task.taskLists!));
    } else {
      BlocProvider.of<TaskBloc>(context)
          .add(UpdateTaskEvent(task, task.taskLists!));
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    if (widget.taskData != null) {
      // If editing, populate the fields with existing data
      titleController = TextEditingController(text: widget.taskData!.title);
      descriptionController =
          TextEditingController(text: widget.taskData!.description);
      dueDate = widget.taskData!.dueDate;

      taskItemControllers = widget.taskData!.taskLists!
          .map((taskList) => TextEditingController(text: taskList.description))
          .toList();
    } else {
      // If creating, initialize with empty controllers
      titleController = TextEditingController();
      descriptionController = TextEditingController();
    }
  }

  void _addNewTaskItemField() {
    setState(() {
      taskItemControllers.add(TextEditingController());
    });
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  void _removeTaskItemField(int index) {
    setState(() {
      taskItemControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.taskData != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Task' : 'Create New Task'),
        actions: [
          IconButton(onPressed: _saveEditTask, icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: "Task Title"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration:
                      const InputDecoration(hintText: "Task Description"),
                ),
                const Gap(20),
                const Text(
                  "Due Date",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                ElevatedButton(
                  onPressed: () => _selectDueDate(context),
                  child: Text(dueDate != null
                      ? DateFormat('dd MMM yyyy').format(dueDate!)
                      : 'Not Set'),
                ),
                ...taskItemControllers.asMap().entries.map((entry) {
                  int idx = entry.key;
                  TextEditingController controller = entry.value;
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration:
                              const InputDecoration(hintText: "Task Item"),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeTaskItemField(idx),
                      ),
                    ],
                  );
                }),
                Gap(10),
                Center(
                  child: ElevatedButton(
                    onPressed: _addNewTaskItemField,
                    child: const Icon(Icons.add),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
