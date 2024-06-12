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
    return _instance;
  }

  bool _isDbInitialized = false;

  late Database _database;

  final String _databaseName = "projjii.db";

  final String _users =
      "create table users (userId INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPassword TEXT)";

  final String _projectsDdd =
      "create table projectsDdd (projectId INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT NOT NULL, owner TEXT NOT NULL, workHours INTEGER NOT NULL, startDate TEXT, endDate TEXT, teamMembers INTEGER NOT NULL, tasks TEXT, userId INTEGER NOT NULL, assignedTeamMembers TEXT, completed INTEGER DEFAULT 0, FOREIGN KEY (userId) REFERENCES users (userId))";

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
      await db.execute(_projectsDdd);
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

  //Method to get User ID from Table
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

  //Method for Login
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
      // print("stored-------->");
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
    // print("login by stored---->");
    return result.isNotEmpty;
  }

  //Method for SignUp
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

  //Method to Check the Email was already exists or not
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

  //Create Project Old Method
  // @override
  // Future<int> createProject(Project project, int userId) async {
  //   await _checkAndInitDB();
  //   try {
  //     int projectId = await _database.insert(
  //       'projectsDdd',
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

  //Method for Create New Project
  @override
  Future<int> createProject(Project project, int userId) async {
    await _checkAndInitDB();

    // for (var teamMember in project.getAssignedTeamMembersList()) {
    //   bool isAssigned = await isTeamMemberAssigned(teamMember);
    //   if (isAssigned) {
    //     throw CustomException(
    //         "Team member $teamMember is already assigned to another project");
    //   }
    // }

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
  @override
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
  @override
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
  @override
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
  @override
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
      // List<Task> tasks = [];
      // if (maps[i]['tasks'] != null) {
      //   var decodedTasks = jsonDecode(maps[i]['tasks']);
      //   tasks = List<Task>.from(
      //       decodedTasks.map((taskJson) => Task.fromJson(taskJson)));
      // }

      // List<String> assignedTeamMembers = [];
      // if (maps[i]['assignedTeamMembers'] != null &&
      //     maps[i]['assignedTeamMembers'].isNotEmpty) {
      //   var decodedAssignedTeamMembers =
      //       jsonDecode(maps[i]['assignedTeamMembers']);
      //   assignedTeamMembers = List<String>.from(decodedAssignedTeamMembers);
      // }
      // print(
      //     "Project ${maps[i]['projectId']} - Tasks: $tasks, AssignedTeamMembers: $assignedTeamMembers");
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
  // Future<List<Project>> getUserProjects(int userId) async {
  //   await _checkAndInitDB();
  //   final List<Map<String, dynamic>> maps = await _database.query(
  //     'projectsDdd',
  //     where: 'userId = ?',
  //     whereArgs: [userId],
  //   );
  //   // print("Fetched projects for userID $userId from DB: $maps");

  //   List<Project> projects = [];

  //   for (var map in maps) {
  //     List<Task> tasks = [];
  //     if (map['tasks'] != null) {
  //       print(1);
  //       var decodedTasks = jsonDecode(map['tasks']);
  //       tasks = List<Task>.from(
  //           decodedTasks.map((taskJson) => Task.fromJson(taskJson)));
  //     }

  //     List<String> assignedTeamMembers = [];
  //     if (map['assignedTeamMembers'] != null &&
  //         map['assignedTeamMembers'].isNotEmpty) {
  //       print(2);
  //       var decodedAssignedTeamMembers = jsonDecode(map['assignedTeamMembers']);
  //       assignedTeamMembers = List<String>.from(decodedAssignedTeamMembers);
  //     }
  //     print(map['projectId']);
  //     print(map['name']);
  //     print(map['description']);
  //     print(map['owner']);
  //     print(map['startDate']);
  //     print(map['endDate']);
  //     print(map['workHours']);
  //     print(map['teamMembers']);
  //     print(map['tasks']);
  //     print(tasks);
  //     print(map['userId']);
  //     print(map['assignedTeamMembers']);
  //     print(assignedTeamMembers);
  //     Project a=Project(
  //       id: map['projectId'],
  //       projectName: map['name'],
  //       description: map['description'],
  //       owner: map['owner'],
  //       startDate: DateTime.parse(map['startDate']),
  //       endDate: DateTime.parse(map['endDate']),
  //       workHours: map['workHours'].toString(),
  //       teamMembers: map['teamMembers'],
  //       tasks: tasks,
  //       userId: map['userId'],
  //       assignedTeamMembers: assignedTeamMembers,
  //     );
  //     print('aaaaaaaaaa=${a.id}');
  //     projects.add(a);
  //   }
  //   print('project maps-----------------$maps');
  //   return projects;
  // }

  //Get User Projects Old Method--->
  // @override
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

  //Method to get Tasks for the Project
  @override
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
  @override
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

  //Method for Insert Completed Projects into Table
  @override
  Future<int> insertCompletedProjects(Project project) async {
    await _checkAndInitDB();
    try {
      int id = await _database.insert('completedProjects', {
        'name': project.projectName,
        'description': project.description,
        'owner': project.owner,
        'startDate': project.startDate,
        'endDate': project.description,
        'workHours': project.description,
        'teamMembers': project.teamMembers,
        'tasks': project.tasks,
        'userId': project.userId
      });
      // print('completed - ${project.projectName}');
      return id;
    } catch (e) {
      throw CustomException("Error while inserting completed projects");
    }
  }

  //Method for Get The Completed Projects
  @override
  Future<List<CompletedProject>> getCompletedProjects(int userID) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps = await _database
        .query('completedProjects', where: 'userId=?', whereArgs: [userID]);
    // print('c maps $maps');
    return List.generate(maps.length, (i) {
      return CompletedProject(
        project: Project(
          id: maps[i]['projectId'],
          projectName: maps[i]['name'],
          description: maps[i]['description'],
          owner: maps[i]['owner'],
          startDate: DateTime.parse(maps[i]['startDate']),
          endDate: DateTime.parse(maps[i]['endDate']),
          workHours: maps[i]['workHours'].toString(),
          teamMembers: maps[i]['teamMembers'].toString(),
          tasks: maps[i]['tasks'],
          userId: maps[i]['userId'],
        ),
        userId: maps[i]['userId'],
      );
    });
  }

  //Method for Create New Tasks for the Project
  @override
  // Future<void> updateTasks(int projectId, List<Task> tasks) async {
  //   await _checkAndInitDB();

  //   final assignedTeamMembers = tasks
  //       .where((task) => task.teamMembers != null)
  //       .expand((task) => task.teamMembers!)
  //       .toSet()
  //       .toList();

  //   for (var teamMember in assignedTeamMembers) {
  //     bool isAssigned =
  //         await isTeamMemberAssignedToOtherProject(teamMember, projectId);
  //     if (isAssigned) {
  //       throw CustomException(
  //           "Team member $teamMember is already assigned to another project");
  //     }
  //   }
  //   final updatedTasksJson =
  //       jsonEncode(tasks.map((task) => task.toJson()).toList());
  //   final assignedTeamMembersJson = jsonEncode(assignedTeamMembers);
  //   try {
  //     await _database.update(
  //       'projectsDdd',
  //       {
  //         'tasks': updatedTasksJson,
  //         'assignedTeamMembers': assignedTeamMembersJson
  //       },
  //       where: 'projectId = ?',
  //       whereArgs: [projectId],
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //     print("tasks in databaseeee-----> $tasks");
  //   } catch (e) {
  //     throw CustomException("Error updating tasks for the project");
  //   }
  // }
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

  //Create Tasks Old Method--->
  // @override
  // Future<void> updateTasks(int projectId, List<Task> tasks) async {
  //   try {
  //     // Ensure that team members are not already assigned to other projects
  //     final assignedTeamMembers = tasks
  //         .where((task) => task.teamMembers != null)
  //         .expand((task) => task.teamMembers!)
  //         .toSet()
  //         .toList();
  //     for (var teamMember in assignedTeamMembers) {
  //       bool isAssigned = await isTeamMemberAssigned(teamMember);
  //       if (isAssigned) {
  //         print("member was already assigned---->");
  //         throw CustomException(
  //             "Team member $teamMember is already assigned to another project");
  //       }
  //     }
  //     // If all checks pass, update tasks for the project
  //     final updatedTasksJson =
  //         jsonEncode(tasks.map((task) => task.toJson()).toList());
  //     final assignedTeamMembersJson = jsonEncode(assignedTeamMembers);
  //     await _database.update(
  //       'projectsDdd',
  //       {
  //         'tasks': updatedTasksJson,
  //         'assignedTeamMembers': assignedTeamMembersJson
  //       },
  //       where: 'projectId = ?',
  //       whereArgs: [projectId],
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //     print("tasks in databaseeee-----> $tasks");
  //     print("Tasks updated successfully");
  //   } catch (e) {
  //     print("Error updating tasks: $e");
  //     throw CustomException("Unable to update tasks for the project");
  //   }
  // }

  //Edit the Tasks
  @override
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
  @override
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

  @override
  Future<Project> getCompletedProjectsFromTable(
      int userId, int projectId, bool completed) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps = await _database.query(
      'projectsDdd',
      where: 'userId = ? AND projectId = ? AND completed = 1',
      whereArgs: [userId, projectId],
    );
    // print(
    //     "Completed projects for userID $userId and projectID $projectId from projectsDdd--->: $maps");

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
}
