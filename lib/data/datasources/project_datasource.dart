import 'dart:convert';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/domain/model/task.dart';
import 'package:flutter_projects/utils/constants/custom_exception.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProjectDataSource {
  ProjectDataSource._();

  static final ProjectDataSource _instance = ProjectDataSource._();

  static ProjectDataSource get instance => _instance;

  factory ProjectDataSource() {
    return _instance;
  }

  bool _isDbInitialized = false;

  late Database _database;

  final String _databaseName = "projjii.db";

  final String _users =
      "create table users (userId INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPassword TEXT)";

  final String _projectsDdd =
      "create table projectsDdd (projectId INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT NOT NULL, owner TEXT NOT NULL, workHours INTEGER NOT NULL, startDate TEXT, endDate TEXT, teamMembers INTEGER NOT NULL, tasks TEXT, userId INTEGER NOT NULL, assignedTeamMembers TEXT, completed INTEGER DEFAULT 0, FOREIGN KEY (userId) REFERENCES users (userId))";

  Future<void> _initDB() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, _databaseName);

    _database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(_users);
      await db.execute(_projectsDdd);
    });

    _isDbInitialized = true;
  }

  Future<void> _checkAndInitDB() async {
    if (!_isDbInitialized) {
      await _initDB();
    }
  }

  //Method to get User ID from Table
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

  //Method for Login
  Future<bool> login(String userName, String userPassword) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> result = await _database.query(
      'users',
      where: 'userName = ? AND userPassword = ?',
      whereArgs: [userName, userPassword],
    );

    return result.isNotEmpty;
  }

  //Method for SignUp
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

  //Method to Check the Email was already exists or not
  Future<bool> checkUserExists(String userName) async {
    await _checkAndInitDB();

    final List<Map<String, dynamic>> result = await _database.query(
      'users',
      where: 'userName = ?',
      whereArgs: [userName],
    );
    return result.isNotEmpty;
  }

  //Method for Create New Project
  Future<int> createProject(Project project, int userId) async {
    await _checkAndInitDB();

    try {
      int projectId = await _database.insert(
        'projectsDdd',
        {
          ...project.toMap(),
          'tasks': jsonEncode(project.tasks.map((task) async {
            if (task.id == null) {
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
      // print("Project created with ID: $projectId");
      return projectId;
    } catch (e) {
      throw CustomException("Error creating new project");
    }
  }

  //Method to get All Projects from DB
  Future<List<Project>> getAllProjects() async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps =
        await _database.query('projectsDdd');
    return List.generate(maps.length, (i) {
      List<Task> tasks = [];
      if (maps[i]['tasks'] != null) {
        var decodedTasks = jsonDecode(maps[i]['tasks']);
        tasks = List<Task>.from(
            decodedTasks.map((taskJson) => Task.fromJson(taskJson)));
      }
      List<String> assignedTeamMembers = [];
      if (maps[i]['assignedTeamMembers'] != null &&
          maps[i]['assignedTeamMembers'].isNotEmpty) {
        var decodedAssignedTeamMembers =
            jsonDecode(maps[i]['assignedTeamMembers']);
        assignedTeamMembers = List<String>.from(decodedAssignedTeamMembers);
      }
      return Project(
        id: maps[i]['projectId'],
        projectName: maps[i]['name'],
        description: maps[i]['description'],
        owner: maps[i]['owner'],
        startDate: DateTime.parse(maps[i]['startDate']),
        endDate: DateTime.parse(maps[i]['endDate']),
        workHours: maps[i]['workHours'].toString(),
        teamMembers: maps[i]['teamMembers'],
        tasks: tasks,
        userId: maps[i]['userId'],
        assignedTeamMembers: assignedTeamMembers,
      );
    });
  }

  //Method for Edit Project
  Future<void> editProject(int projectId, Project editedProject) async {
    await _checkAndInitDB();
    try {
      await _database.update(
        'projectsDdd',
        editedProject.toMap(),
        where: 'projectId = ?',
        whereArgs: [editedProject.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      CustomException("Can't edit the project right now");
    }
  }

  //Method to Delete the Project
  Future<void> deleteProject(int projectId) async {
    await _checkAndInitDB();
    try {
      await _database.delete(
        'projectsDdd',
        where: 'projectId = ?',
        whereArgs: [projectId],
      );
    } catch (e) {
      CustomException("Can't delete the project");
    }
  }

  //Method to get projects based on user ID
  Future<List<Project>> getUserProjects(int userId) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps = await _database.query(
      'projectsDdd',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    // print("Fetched projects for userID $userId from DB: $maps");
    return List.generate(maps.length, (i) {
      List<Task> tasks = [];
      if (maps[i]['tasks'] != null) {
        var decodedTasks = jsonDecode(maps[i]['tasks']);
        tasks = List<Task>.from(
            decodedTasks.map((taskJson) => Task.fromJson(taskJson)));
      }

      List<String> assignedTeamMembers = [];
      if (maps[i]['assignedTeamMembers'] != null &&
          maps[i]['assignedTeamMembers'].isNotEmpty) {
        var decodedAssignedTeamMembers =
            jsonDecode(maps[i]['assignedTeamMembers']);
        assignedTeamMembers = List<String>.from(decodedAssignedTeamMembers);
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
        assignedTeamMembers: assignedTeamMembers,
      );
    });
  }

  //Method to get Tasks for the Project
  Future<List<Task>> getUserTasks(int projectId) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps = await _database.query(
      'projectsDdd',
      where: 'projectId = ?',
      whereArgs: [projectId],
    );
    // print("maps in tasksss $maps");
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

  //Method for Mark As Completed
  Future<void> markProjectAsCompleted(int projectId) async {
    await _checkAndInitDB();
    try {
      await _database.update(
        'projectsDdd',
        {'completed': 1},
        where: 'projectId = ?',
        whereArgs: [projectId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      CustomException("Can't mark project as completed");
    }
  }

  //Method for Create New Tasks for the Project
  Future<void> updateTasks(int projectId, List<Task> tasks) async {
    await _checkAndInitDB();

    final List<Map<String, dynamic>> projectMaps = await _database.query(
      'projectsDdd',
      where: 'projectId = ?',
      whereArgs: [projectId],
    );

    if (projectMaps.isNotEmpty) {
      final projectData = projectMaps.first;

      final int maxTeamMembers = projectData['teamMembers'] as int;

      final assignedTeamMembers = tasks
          .where((task) => task.teamMembers != null)
          .expand((task) => task.teamMembers!)
          .toSet()
          .toList();

      if (assignedTeamMembers.length > maxTeamMembers) {
        throw CustomException(
            "Number of assigned team members exceeds the maximum allowed");
      }

      for (var teamMember in assignedTeamMembers) {
        bool isAssigned =
            await isTeamMemberAssignedToOtherProject(teamMember, projectId);
        if (isAssigned) {
          throw CustomException(
              "Team member $teamMember is already assigned to another project");
        }
      }

      final updatedTasksJson =
          jsonEncode(tasks.map((task) => task.toJson()).toList());
      final assignedTeamMembersJson = jsonEncode(assignedTeamMembers);
      try {
        await _database.update(
          'projectsDdd',
          {
            'tasks': updatedTasksJson,
            'assignedTeamMembers': assignedTeamMembersJson
          },
          where: 'projectId = ?',
          whereArgs: [projectId],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        // print("Tasks updated in database for project $projectId");
      } catch (e) {
        throw CustomException("Error updating tasks for the project");
      }
    } else {
      throw CustomException("Project not found");
    }
  }

  //Edit the Tasks
  Future<void> updateTask(int projectId, Task updatedTask) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps = await _database.query(
      'projectsDdd',
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
      // print("task ID---?${updatedTask.id}");
      if (taskIndex != -1) {
        tasks[taskIndex] = updatedTask;
        final updatedTasksJson =
            jsonEncode(tasks.map((task) => task.toJson()).toList());
        await _database.update(
          'projectsDdd',
          {'tasks': updatedTasksJson},
          where: 'projectId = ?',
          whereArgs: [projectId],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        // print("task updated in database");
      } else {
        throw CustomException("Task not found in project");
      }
    } else {
      throw CustomException("Project not found");
    }
  }

  //Method for Assigned Team Members
  Future<bool> isTeamMemberAssigned(String teamMember) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps = await _database.query(
      'projectsDdd',
      where: 'assignedTeamMembers LIKE ?',
      whereArgs: ['%"$teamMember"%'],
    );
    return maps.isNotEmpty;
  }

  //Method for Assigned Team Members
  Future<bool> isTeamMemberAssignedToOtherProject(
      String teamMember, int currentProjectId) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps = await _database.query(
      'projectsDdd',
      where: 'assignedTeamMembers LIKE ? AND projectId != ?',
      whereArgs: ['%"$teamMember"%', currentProjectId],
    );
    return maps.isNotEmpty;
  }

  //Method for Get Completed Projects from projects table
  Future<Project> getCompletedProjectsFromTable(
      int userId, int projectId, bool completed) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps = await _database.query(
      'projectsDdd',
      where: 'userId = ? AND projectId = ? AND completed = 1',
      whereArgs: [userId, projectId],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      List<Task> tasks = [];
      if (map['tasks'] != null) {
        var decodedTasks = jsonDecode(map['tasks']);
        tasks = List<Task>.from(
            decodedTasks.map((taskJson) => Task.fromJson(taskJson)));
      }

      List<String> assignedTeamMembers = [];
      if (map['assignedTeamMembers'] != null &&
          map['assignedTeamMembers'].isNotEmpty) {
        var decodedAssignedTeamMembers = jsonDecode(map['assignedTeamMembers']);
        assignedTeamMembers = List<String>.from(decodedAssignedTeamMembers);
      }
      // print('Get Completed Tasks form dbbbb---->>>$map');
      return Project(
        id: map['projectId'],
        projectName: map['name'],
        description: map['description'],
        owner: map['owner'],
        startDate: DateTime.parse(map['startDate']),
        endDate: DateTime.parse(map['endDate']),
        workHours: map['workHours'].toString(),
        teamMembers: map['teamMembers'].toString(),
        tasks: tasks,
        userId: map['userId'],
        assignedTeamMembers: assignedTeamMembers,
        completed: map['completed'] == 1,
      );
    } else {
      throw Exception("Project not found");
    }
  }

// Future<void> insertMemberCredentials() async {
  //   await _checkAndInitDB();
  //   try {
  //     for (var credential in memberCredentials) {
  //       await _database.insert(
  //         'preUsers',
  //         {
  //           'name': credential.elementAt(0),
  //           'email': credential.elementAt(1),
  //           'password': credential.elementAt(2),
  //         },
  //         conflictAlgorithm: ConflictAlgorithm.replace,
  //       );
  //     }
  //     // print("stored-------->");
  //   } catch (e) {
  //     throw CustomException("Error inserting member credentials");
  //   }
  // }

// Future<bool> loginMembers(String email, String pass) async {
//   await _checkAndInitDB();
//   final List<Map<String, dynamic>> result = await _database.query(
//     'preUsers',
//     where: 'email = ? AND password = ?',
//     whereArgs: [email, pass],
//   );
//   // print("login by stored---->");
//   return result.isNotEmpty;
// }

// Future<List<CompletedProject>> getCompletedProjects(int userID) async {
  //   await _checkAndInitDB();
  //   final List<Map<String, dynamic>> maps = await _database
  //       .query('completedProjects', where: 'userId=?', whereArgs: [userID]);
  //   // print('c maps $maps');
  //   return List.generate(maps.length, (i) {
  //     return CompletedProject(
  //       project: Project(
  //         id: maps[i]['projectId'],
  //         projectName: maps[i]['name'],
  //         description: maps[i]['description'],
  //         owner: maps[i]['owner'],
  //         startDate: DateTime.parse(maps[i]['startDate']),
  //         endDate: DateTime.parse(maps[i]['endDate']),
  //         workHours: maps[i]['workHours'].toString(),
  //         teamMembers: maps[i]['teamMembers'].toString(),
  //         tasks: maps[i]['tasks'],
  //         userId: maps[i]['userId'],
  //       ),
  //       userId: maps[i]['userId'],
  //     );
  //   });
  // }

// Future<int> insertCompletedProjects(Project project) async {
  //   await _checkAndInitDB();
  //   try {
  //     int id = await _database.insert('completedProjects', {
  //       'name': project.projectName,
  //       'description': project.description,
  //       'owner': project.owner,
  //       'startDate': project.startDate,
  //       'endDate': project.description,
  //       'workHours': project.description,
  //       'teamMembers': project.teamMembers,
  //       'tasks': project.tasks,
  //       'userId': project.userId
  //     });
  //     // print('completed - ${project.projectName}');
  //     return id;
  //   } catch (e) {
  //     throw CustomException("Error while inserting completed projects");
  //   }
  // }

//Get User Projects Old Method--->
  //
  // Future<List<Project>> getUserProjects(int userId) async {
  //   await _checkAndInitDB();
  //   final List<Map<String, dynamic>> maps = await _database.query(
  //     'projectsDdd',
  //     where: 'userId = ?',
  //     whereArgs: [userId],
  //   );
  //   Set<String> assignedTeamMembers = {};
  //   return List.generate(maps.length, (i) {
  //     List<Task> tasks = [];
  //     if (maps[i]['tasks'] != null) {
  //       var decodedTasks = jsonDecode(maps[i]['tasks']);
  //       tasks = List<Task>.from(
  //           decodedTasks.map((taskJson) => Task.fromJson(taskJson)));
  //       // Add team members to the assigned list
  //       for (var task in tasks) {
  //         assignedTeamMembers.addAll(task.teamMembers!);
  //       }
  //     }
  //     return Project(
  //       id: maps[i]['projectId'],
  //       projectName: maps[i]['name'],
  //       description: maps[i]['description'],
  //       owner: maps[i]['owner'],
  //       startDate: DateTime.parse(maps[i]['startDate']),
  //       endDate: DateTime.parse(maps[i]['endDate']),
  //       workHours: maps[i]['workHours'].toString(),
  //       teamMembers: maps[i]['teamMembers'].toString(),
  //       tasks: tasks,
  //       userId: maps[i]['userId'],
  //     );
  //   });
  // }

// final String _preUsers =
  //     "create table preUsers (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT UNIQUE, password TEXT)";
  // await db.execute(_preUsers);
}
