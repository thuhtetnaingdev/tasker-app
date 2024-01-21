import 'package:flutter_1/src/data/models/task_list_model.dart';
import 'package:flutter_1/src/data/models/task_model.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class TaskDataSource {
  static final TaskDataSource instance = TaskDataSource._init();
  static Database? _database;

  TaskDataSource._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks6.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      due_date TEXT, 
      created_at TEXT,
      status TEXT NOT NULL DEFAULT 'pending'
    )
  ''');
    await db.execute('''
    CREATE TABLE task_list (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      task_id INTEGER,
      description TEXT NOT NULL,
      complete INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (task_id) REFERENCES tasks(id)
    )
  ''');
  }

  Future<TaskModel> createTask(TaskModel task, List<TaskList> taskLists) async {
    final db = await database;

    final id = await db.transaction((txn) async {
      final taskId = await txn.insert('tasks', task.toMap());

      for (var taskList in taskLists) {
        await txn.insert('task_list', {...taskList.toMap(), "task_id": taskId});
      }

      return taskId;
    });

    return task.copy(id: id);
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final taskMaps = await db.query('tasks');

    List<TaskModel> tasks = [];
    for (var taskMap in taskMaps) {
      // Convert the task
      var task = TaskModel.fromMap(taskMap);

      // Query the task list items
      final taskListMaps = await db.query(
        'task_list',
        where: 'task_id = ?',
        whereArgs: [task.id],
      );

      // Convert task list items
      List<TaskList> taskLists = taskListMaps
          .map((taskListMap) => TaskList.fromMap(taskListMap))
          .toList();

      // Add task list items to the task
      tasks.add(task.copy(taskLists: taskLists));
    }

    return tasks;
  }

  Future<TaskModel> updateTask(TaskModel task, List<TaskList> taskLists) async {
    final db = await database;

    return await db.transaction((txn) async {
      // Update the task
      await txn.update(
        'tasks',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );

      // Delete existing task list items related to this task
      await txn.delete(
        'task_list',
        where: 'task_id = ?',
        whereArgs: [task.id],
      );

      // Insert new task list items
      for (var taskList in taskLists) {
        await txn.insert('task_list', {
          'task_id': task.id,
          'description': taskList.description,
          'complete': taskList.complete ? 1 : 0,
        });
      }

      return task;
    });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
