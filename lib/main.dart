import 'package:flutter/material.dart';
import 'package:flutter_1/src/data/datasources/task_datasource.dart';
import 'package:flutter_1/src/data/repositories/task_repository.dart';
import 'package:flutter_1/src/domain/usecases/create_task_usecase.dart';
import 'package:flutter_1/src/domain/usecases/get_task_usecase.dart';
import 'package:flutter_1/src/domain/usecases/update_task_usecase.dart';
import 'package:flutter_1/src/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:flutter_1/src/presentation/screens/home_page.dart';
import 'package:flutter_1/src/presentation/screens/profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  sqfliteFfiInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final taskDataSource = TaskDataSource.instance;
    final taskRepository = TaskRepository(taskDataSource);
    final createTaskUseCase = CreateTaskUseCase(taskRepository);
    final getTasksUseCase = GetTasksUseCase(taskRepository);
    final updateTaskUseCase = UpdateTaskUseCase(taskRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                TaskBloc(createTaskUseCase, getTasksUseCase, updateTaskUseCase))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const MainPage(), // Changed to MainPage
        navigatorObservers: [routeObserver],
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MyHomePage(title: 'Home Page'),
    ProfilePage(), // Add the ProfilePage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Set the background color of Scaffold

      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Add horizontal padding

        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
