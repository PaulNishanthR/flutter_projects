import 'dart:convert';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/domain/model/task.dart';
import 'package:flutter_projects/domain/repositories/project_repository.dart';
import 'package:flutter_projects/utils/constants/custom_exception.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProjectDataSource implements ProjectRepository {
  ProjectDataSource._();

  static final ProjectDataSource _instance = ProjectDataSource._();

  static ProjectDataSource get instance => _instance;

  bool _isDbInitialized = false;

  late Database _database;

  final String _databaseName = "proj.db";

  final String _users =
      "create table users (userId INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPassword TEXT)";

  final String _projectsD =
      "create table projectsD (projectId INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT NOT NULL, owner TEXT NOT NULL, workHours INTEGER NOT NULL, startDate TEXT, endDate TEXT, teamMembers INTEGER NOT NULL, tasks TEXT, userId INTEGER NOT NULL, FOREIGN KEY (userId) REFERENCES users (userId))";

  Future<void> _initDB() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, _databaseName);

    _database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(_users);
      await db.execute(_projectsD);
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
  Future<int> createProject(Project project, int userId) async {
    await _checkAndInitDB();
    try {
      int projectId = await _database.insert(
        'projectsD',
        {
          ...project.toMap(),
          'tasks': jsonEncode(project.tasks),
          'userId': userId,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return projectId;
    } catch (e) {
      CustomException("Error creating new project");
      return -1;
    }
  }

  @override
  Future<List<Project>> getAllProjects() async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps = await _database.query('projectsD');
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
        'projectsD',
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
        'projectsD',
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
      'projectsD',
      where: 'userId = ?',
      whereArgs: [userId],
    );
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
}
