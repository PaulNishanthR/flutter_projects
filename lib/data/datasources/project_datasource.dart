// ignore_for_file: override_on_non_overriding_member
import 'dart:convert';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/domain/repositories/project_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProjectDataSource implements ProjectRepository {
  final String databaseName = "proj.db";

  String users =
      "create table users (userId INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPassword TEXT)";

  String projectsD =
      "create table projectsD (projectId INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT NOT NULL, owner TEXT NOT NULL, workHours INTEGER NOT NULL, startDate TEXT, endDate TEXT, teamMembers INTEGER NOT NULL, tasks TEXT, userId INTEGER NOT NULL, FOREIGN KEY (userId) REFERENCES users (userId))";

  Future<Database> initDB() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
      await db.execute(projectsD);
    });
  }

  @override
  Future<int?> getUserId(String email) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['userId'],
      where: 'userName = ?',
      whereArgs: [email],
    );
    // print(result);
    if (result.isNotEmpty) {
      return result.first['userId'] as int?;
    } else {
      return null;
    }
  }

  @override
  Future<bool> login(String userName, String userPassword) async {
    final Database db = await initDB();

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'userName = ? AND userPassword = ?',
      whereArgs: [userName, userPassword],
    );

    return result.isNotEmpty;
  }

  @override
  Future<void> signup(String userName, String userPassword) async {
    final Database db = await initDB();

    try {
      await db.insert(
        'users',
        {'userName': userName, 'userPassword': userPassword},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // print("Signup error: $e");
    } finally {
      await db.close();
    }
  }

  @override
  Future<int> createProject(Project project, int userId) async {
    final Database db = await initDB();
    try {
      int projectId = await db.insert(
        'projectsD',
        {
          ...project.toMap(),
          'tasks': jsonEncode(project.tasks),
          'userId': userId,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // print('task added ${project.projectName} $projectId ');
      return projectId;
    } catch (e) {
      // print("Creation error: $e");
      return -1;
    }
  }

  @override
  Future<List<Project>> getAllProjects() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('projectsD');
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
    final Database db = await initDB();
    try {
      await db.update(
        'projectsD',
        editedProject.toMap(),
        where: 'projectId = ?',
        whereArgs: [editedProject.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // print('Project updated: ${editedProject.projectName}');
    } catch (e) {
      // print("Edit error: $e");
    }
  }

  @override
  Future<void> deleteProject(int projectId) async {
    final Database db = await initDB();
    try {
      await db.delete(
        'projectsD',
        where: 'projectId = ?',
        whereArgs: [projectId],
      );
      // print('Project deleted with ID: $projectId');
    } catch (e) {
      // print("Delete error: $e");
    }
  }

  @override
  Future<List<Project>> getUserProjects(int userId) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
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
