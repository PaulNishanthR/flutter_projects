import 'dart:convert';
import 'package:flutter_projects/domain/model/completed_project.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/domain/model/task.dart';
import 'package:flutter_projects/domain/repositories/project_repository.dart';
import 'package:flutter_projects/utils/constants/custom_exception.dart';
import 'package:flutter_projects/utils/constants/default_value.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProjectDataSource implements ProjectRepository {
  ProjectDataSource._();

  static final ProjectDataSource _instance = ProjectDataSource._();

  static ProjectDataSource get instance => _instance;

  factory ProjectDataSource() {
    // _instance ??= ProjectDataSource._();
    return _instance;
  }

  bool _isDbInitialized = false;

  late Database _database;

  final String _databaseName = "projji.db";

  final String _users =
      "create table users (userId INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPassword TEXT)";

  // final String _projectsDd =
  //     "create table projectsDd (projectId INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT NOT NULL, owner TEXT NOT NULL, workHours INTEGER NOT NULL, startDate TEXT, endDate TEXT, teamMembers INTEGER NOT NULL, tasks TEXT, userId INTEGER NOT NULL, FOREIGN KEY (userId) REFERENCES users (userId))";

  final String _projectsDd =
      "create table projectsDd (projectId INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT NOT NULL, owner TEXT NOT NULL, workHours INTEGER NOT NULL, startDate TEXT, endDate TEXT, teamMembers INTEGER NOT NULL, tasks TEXT, userId INTEGER NOT NULL, completed INTEGER DEFAULT 0, FOREIGN KEY (userId) REFERENCES users (userId))";

  final String _preUsers =
      "create table preUsers (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT UNIQUE, password TEXT)";

  final String _completedProjects =
      "create table completedProjects (projectId INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT NOT NULL, owner TEXT NOT NULL, workHours INTEGER NOT NULL, startDate TEXT, endDate TEXT, teamMembers INTEGER NOT NULL, tasks TEXT, userId INTEGER NOT NULL, FOREIGN KEY (userId) REFERENCES users (userId))";

  Future<void> _initDB() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, _databaseName);

    _database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(_users);
      await db.execute(_projectsDd);
      await db.execute(_preUsers);
      await db.execute(_completedProjects);
    });

    _isDbInitialized = true;
  }

  Future<void> _checkAndInitDB() async {
    if (!_isDbInitialized) {
      await _initDB();
    }
  }

  @override
  Future<int?> getUserId(String email) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> result = await _database.query(
      'users',
      columns: ['userId'],
      where: 'userName = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first['userId'] as int?;
    } else {
      return null;
    }
  }

  @override
  Future<bool> login(String userName, String userPassword) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> result = await _database.query(
      'users',
      where: 'userName = ? AND userPassword = ?',
      whereArgs: [userName, userPassword],
    );

    return result.isNotEmpty;
  }

  Future<void> insertMemberCredentials() async {
    await _checkAndInitDB();
    try {
      for (var credential in memberCredentials) {
        await _database.insert(
          'preUsers',
          {
            'name': credential.elementAt(0),
            'email': credential.elementAt(1),
            'password': credential.elementAt(2),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      print("stored-------->");
    } catch (e) {
      throw CustomException("Error inserting member credentials");
    }
  }

  Future<bool> loginMembers(String email, String pass) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> result = await _database.query(
      'preUsers',
      where: 'email = ? AND password = ?',
      whereArgs: [email, pass],
    );
    print("login by stored---->");
    return result.isNotEmpty;
  }

  @override
  Future<void> signup(String userName, String userPassword) async {
    await _checkAndInitDB();
    try {
      await _database.insert(
        'users',
        {'userName': userName, 'userPassword': userPassword},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      CustomException("Error! didn't Sign Up");
    }
  }

  @override
  Future<bool> checkUserExists(String userName) async {
    await _checkAndInitDB();

    final List<Map<String, dynamic>> result = await _database.query(
      'users',
      where: 'userName = ?',
      whereArgs: [userName],
    );
    return result.isNotEmpty;
  }

  // @override
  // Future<int> createProject(Project project, int userId) async {
  //   await _checkAndInitDB();
  //   try {
  //     int projectId = await _database.insert(
  //       'projectsDd',
  //       {
  //         ...project.toMap(),
  //         'tasks': jsonEncode(project.tasks),
  //         'userId': userId,
  //       },
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //     project.id = projectId;
  //     print("Project created with ID: $projectId");
  //     return projectId;
  //   } catch (e) {
  //     CustomException("Error creating new project");
  //     return -1;
  //   }
  // }
  @override
  Future<int> createProject(Project project, int userId) async {
    await _checkAndInitDB();
    try {
      // Insert the project first
      int projectId = await _database.insert(
        'projectsDd',
        {
          ...project.toMap(),
          'tasks': jsonEncode(project.tasks.map((task) async {
            if (task.id == null) {
              // Insert the task to get its ID
              int taskId = await _database.insert(
                'tasks',
                task.toJson(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
              task.id = taskId;
            }
            return task.toJson();
          }).toList()),
          'userId': userId,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      project.id = projectId;
      print("Project created with ID: $projectId");
      return projectId;
    } catch (e) {
      throw CustomException("Error creating new project");
    }
  }

  @override
  Future<List<Project>> getAllProjects() async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps = await _database.query('projectsDd');
    return List.generate(maps.length, (i) {
      List<Task> tasks = [];
      if (maps[i]['tasks'] != null) {
        var decodedTasks = jsonDecode(maps[i]['tasks']);
        tasks = List<Task>.from(
            decodedTasks.map((taskJson) => Task.fromJson(taskJson)));
      }
      return Project(
        id: maps[i]['projectId'],
        projectName: maps[i]['name'],
        description: maps[i]['description'],
        owner: maps[i]['owner'],
        startDate: DateTime.parse(maps[i]['startDate']),
        endDate: DateTime.parse(maps[i]['endDate']),
        workHours: maps[i]['workHours'].toString(),
        teamMembers: maps[i]['teamMembers'].toString(),
        tasks: tasks,
        userId: maps[i]['userId'],
      );
    });
  }

  @override
  Future<void> editProject(int projectId, Project editedProject) async {
    await _checkAndInitDB();
    try {
      await _database.update(
        'projectsDd',
        editedProject.toMap(),
        where: 'projectId = ?',
        whereArgs: [editedProject.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      CustomException("Can't edit the project right now");
    }
  }

  @override
  Future<void> deleteProject(int projectId) async {
    await _checkAndInitDB();
    try {
      await _database.delete(
        'projectsDd',
        where: 'projectId = ?',
        whereArgs: [projectId],
      );
    } catch (e) {
      CustomException("Can't delete the project");
    }
  }

  @override
  Future<List<Project>> getUserProjects(int userId) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps = await _database.query(
      'projectsDd',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    print(maps);
    return List.generate(maps.length, (i) {
      List<Task> tasks = [];
      if (maps[i]['tasks'] != null) {
        var decodedTasks = jsonDecode(maps[i]['tasks']);
        tasks = List<Task>.from(
            decodedTasks.map((taskJson) => Task.fromJson(taskJson)));
      }
      return Project(
        id: maps[i]['projectId'],
        projectName: maps[i]['name'],
        description: maps[i]['description'],
        owner: maps[i]['owner'],
        startDate: DateTime.parse(maps[i]['startDate']),
        endDate: DateTime.parse(maps[i]['endDate']),
        workHours: maps[i]['workHours'].toString(),
        teamMembers: maps[i]['teamMembers'].toString(),
        tasks: tasks,
        userId: maps[i]['userId'],
      );
    });
  }

  @override
  Future<List<Task>> getUserTasks(int projectId) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps = await _database.query(
      'projectsDd',
      where: 'projectId = ?',
      whereArgs: [projectId],
    );
    print("maps in tasksss $maps");
    if (maps.isNotEmpty) {
      List<Task> tasks = [];
      if (maps.first['tasks'] != null) {
        var decodedTasks = jsonDecode(maps.first['tasks']);
        tasks = List<Task>.from(
            decodedTasks.map((taskJson) => Task.fromJson(taskJson)));
      }
      return tasks;
    } else {
      return [];
    }
  }

  @override
  Future<void> markProjectAsCompleted(int projectId) async {
    await _checkAndInitDB();
    try {
      await _database.update(
        'projectsDd',
        {'completed': 1},
        where: 'projectId = ?',
        whereArgs: [projectId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      CustomException("Can't mark project as completed");
    }
  }

  @override
  Future<int> insertCompletedProjects(
      CompletedProject project, int projectId) async {
    await _checkAndInitDB();
    print('db - $project ,$projectId');
    try {
      int id = await _database.insert('completedProjects', project.toMap());
      print('completed - ${project.id}');
      return id;
    } catch (e) {
      throw CustomException("Error while inserting completed projects");
    }
  }

  @override
  Future<List<CompletedProject>> getCompletedProjects() async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps =
        await _database.query('completedProjects');
    return List.generate(maps.length, (i) {
      return CompletedProject.fromMap(maps[i]);
    });
  }

  @override
  Future<void> updateTasks(int projectId, List<Task> tasks) async {
    await _checkAndInitDB();
    final updatedTasksJson =
        jsonEncode(tasks.map((task) => task.toJson()).toList());
    try {
      await _database.update(
        'projectsDd',
        {'tasks': updatedTasksJson},
        where: 'projectId = ?',
        whereArgs: [projectId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print("tasks in databaseeee-----> $tasks");
    } catch (e) {
      throw CustomException("Error updating tasks for the project");
    }
  }

  @override
  Future<void> updateTask(int projectId, Task updatedTask) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps = await _database.query(
      'projectsDd',
      where: 'projectId = ?',
      whereArgs: [projectId],
    );
    if (maps.isNotEmpty) {
      List<Task> tasks = [];
      if (maps.first['tasks'] != null) {
        var decodedTasks = jsonDecode(maps.first['tasks']);
        tasks = List<Task>.from(
            decodedTasks.map((taskJson) => Task.fromJson(taskJson)));
      }
      int taskIndex = tasks.indexWhere((task) => task.id == updatedTask.id);
      print("task ID---?${updatedTask.id}");
      if (taskIndex != -1) {
        tasks[taskIndex] = updatedTask;
        final updatedTasksJson =
            jsonEncode(tasks.map((task) => task.toJson()).toList());
        await _database.update(
          'projectsDd',
          {'tasks': updatedTasksJson},
          where: 'projectId = ?',
          whereArgs: [projectId],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print("task updated in database");
      } else {
        throw CustomException("Task not found in project");
      }
    } else {
      throw CustomException("Project not found");
    }
  }
}
