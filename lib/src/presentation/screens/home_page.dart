import 'package:flutter/material.dart';
import 'package:flutter_1/main.dart';
import 'package:flutter_1/src/data/datasources/task_datasource.dart';
import 'package:flutter_1/src/data/repositories/task_repository.dart';
import 'package:flutter_1/src/domain/usecases/create_task_usecase.dart';
import 'package:flutter_1/src/domain/usecases/get_task_usecase.dart';
import 'package:flutter_1/src/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:flutter_1/src/presentation/blocs/task_bloc/task_event.dart';
import 'package:flutter_1/src/presentation/screens/create_task_page.dart';
import 'package:flutter_1/src/presentation/widgets/home_widgets/task_with_status.dart';
import 'package:flutter_1/src/presentation/widgets/home_widgets/task_hero.dart';
import 'package:flutter_1/src/presentation/widgets/home_widgets/user_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with RouteAware {
  final taskDataSource = TaskDataSource.instance;
  late final taskRepository = TaskRepository(taskDataSource);
  late final createTaskUseCase = CreateTaskUseCase(taskRepository);
  late final getTasksUseCase = GetTasksUseCase(taskRepository);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    // Called when the top route has been popped off, and the current route shows up.
    BlocProvider.of<TaskBloc>(context).add(GetTasksEvent());
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _showAddTaskPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CreateTaskPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UserBar(),
              const TaskHero(),
              Divider(
                color: Colors.grey[300], // Set the color of the line
                height: 16.0, // Set the height of the line
                thickness: 1.0, // Set the thickness of the line
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    label: const Text("Create new task"),
                    onPressed: () {
                      _showAddTaskPage(context);
                    },
                    icon: const Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                    ),
                  ),
                ],
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Pending'),
                  Tab(text: 'In Progress'),
                  Tab(text: 'Complete'),
                ],
              ),
              const Expanded(
                // Use Expanded here
                child: TabBarView(
                  children: [
                    TasksWithStatusList(
                      type: "pending",
                    ),
                    TasksWithStatusList(
                      type: "in_progress",
                    ),
                    TasksWithStatusList(
                      type: "complete",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
