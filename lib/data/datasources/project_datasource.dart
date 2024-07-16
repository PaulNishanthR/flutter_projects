import 'dart:convert';
import 'package:flutter_projects/domain/model/notification/notification.dart';
import 'package:flutter_projects/domain/model/project/project.dart';
import 'package:flutter_projects/domain/model/project/task.dart';
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

  final String _databaseName = "ppxxzz.db";

  final String _users =
      "create table users (userId INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPassword TEXT)";

  final String _projectsDdd =
      "create table projectsDdd (projectId INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT NOT NULL, owner TEXT NOT NULL, workHours INTEGER NOT NULL, startDate TEXT, endDate TEXT, teamMembers INTEGER NOT NULL, tasks TEXT, userId INTEGER NOT NULL, assignedTeamMembers TEXT, completed INTEGER DEFAULT 0, interval TEXT, FOREIGN KEY (userId) REFERENCES users (userId))";

  final String _notifications =
      "CREATE TABLE notifications (id INTEGER PRIMARY KEY AUTOINCREMENT, projectId INTEGER, message TEXT, isRead INTEGER, FOREIGN KEY (projectId) REFERENCES projectsDdd (projectId))";

  Future<void> _initDB() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, _databaseName);

    _database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(_users);
      await db.execute(_projectsDdd);
      await db.execute(_notifications);
    });

    _isDbInitialized = true;
  }

  Future<void> _checkAndInitDB() async {
    if (!_isDbInitialized) {
      await _initDB();
    }
  }

  Future<NotificationModel> create(NotificationModel notification) async {
    await _checkAndInitDB();

    final id = await _database.insert('notifications', notification.toMap());
    final newNotification = notification.copyWith(id: id);

    return newNotification;
  }

  Future<int> getCountOfUnreadNotifications() async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> unreadNotifications =
        await _database.query(
      'notifications',
      where: 'isRead = 0',
    );
    return unreadNotifications.length;
  }

  Future<List<NotificationModel>> getAllNotifications() async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps =
        await _database.query('notifications');
    print('NO MAPS - $maps');
    return List.generate(maps.length, (i) {
      return NotificationModel(
        id: maps[i]['id'],
        projectId: maps[i]['projectId'],
        message: maps[i]['message'],
        isRead: maps[i]['isRead'] == 1,
      );
    });
  }

  Future<int> update(int projectId) async {
    await _checkAndInitDB();
    // print('notif updated ---- >>> $notification');
    return _database.update(
      'notifications',
      {
        'isRead': 1,
      },
      where: 'projectId = ?',
      whereArgs: [projectId],
    );
  }

  Future<int> delete(int id) async {
    await _checkAndInitDB();
    print('notif deleted ---- >>> $id');

    return await _database.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
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
      print('mapppppp - $maps');
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
    print("Fetched projects for userID $userId from DB: $maps");
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
      print('maps inside return --->>> $maps');
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
        interval: maps[i]['interval'] ?? '',
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

  //Method for Mark As Completed
  Future<void> markProjectAsCompleted(int projectId) async {
    await _checkAndInitDB();
    try {
      await _database.update(
        'projectsDdd',
        {'completed': 1, 'interval': 'done'},
        where: 'projectId = ?',
        whereArgs: [projectId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      CustomException("Can't mark project as completed");
    }
  }

  //Method for Create New Tasks for the Project
  Future<int> updateTasks(int projectId, List<Task> tasks) async {
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
        int id = await _database.update(
          'projectsDdd',
          {
            'tasks': updatedTasksJson,
            'assignedTeamMembers': assignedTeamMembersJson
          },
          where: 'projectId = ?',
          whereArgs: [projectId],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return id;
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

  //Method for Get Un Completed Projects from projects table
  Future<Project> getUnCompletedProjectsFromTable(
      int userId, int projectId, bool completed) async {
    await _checkAndInitDB();
    final List<Map<String, dynamic>> maps = await _database.query(
      'projectsDdd',
      where: 'userId = ? AND projectId = ? AND completed = 0',
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
        completed: map['completed'] == 0,
      );
    } else {
      throw Exception("Project not found");
    }
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

  //Get Assigned Tasks and Projects for Members
  // Future<List<Project>> getAssignedProjectsAndTasks(
  //     String assignedTeamMembers) async {
  //   await _checkAndInitDB();
  //   final List<Map<String, dynamic>> maps = await _database.query(
  //     'projectsDdd',
  //     where: 'assignedTeamMembers LIKE ?',
  //     whereArgs: ['%"$assignedTeamMembers"%'],
  //   );
  //   return List.generate(maps.length, (i) {
  //     final map = maps[i];
  //     print('maps--->$map, $maps');
  //     List<Task> tasks = [];
  //     if (map['tasks'] != null) {
  //       var decodedTasks = jsonDecode(map['tasks']);
  //       tasks = List<Task>.from(
  //           decodedTasks.map((taskJson) => Task.fromJson(taskJson)));
  //     }
  //     print('proj and task for memberrr in dbbb--->$map, $maps');
  //     List<String> assignedTeamMembers = [];
  //     if (map['assignedTeamMembers'] != null &&
  //         map['assignedTeamMembers'].isNotEmpty) {
  //       var decodedAssignedTeamMembers = jsonDecode(map['assignedTeamMembers']);
  //       assignedTeamMembers = List<String>.from(decodedAssignedTeamMembers);
  //     }
  //     print('proj and task for member in dbbb--->$map, $maps');
  //     return Project(
  //       id: map['projectId'],
  //       projectName: map['name'],
  //       description: map['description'],
  //       owner: map['owner'],
  //       startDate: DateTime.parse(map['startDate']),
  //       endDate: DateTime.parse(map['endDate']),
  //       workHours: map['workHours'].toString(),
  //       teamMembers: map['teamMembers'].toString(),
  //       tasks: tasks,
  //       userId: map['userId'],
  //       assignedTeamMembers: assignedTeamMembers,
  //       completed: map['completed'] == 1,
  //     );
  //   });
  // }

  // Future<List<Project>> getAssignedProjectsAndTasks(
  //     String assignedTeamMember) async {
  //   await _checkAndInitDB();
  //   print('Assigned team member: $assignedTeamMember');
  //   print('Running query...');
  //   final List<Map<String, dynamic>> maps = await _database.query(
  //     'projectsDdd',
  //     where: 'assignedTeamMembers LIKE ?',
  //     whereArgs: ['%"$assignedTeamMember"%'],
  //   );
  //   print('Query result: $maps');
  //   return List.generate(maps.length, (i) {
  //     final map = maps[i];
  //     print('Map: $map');
  //     List<Task> tasks = [];
  //     if (map['tasks'] != null) {
  //       var decodedTasks = jsonDecode(map['tasks']);
  //       tasks = List<Task>.from(
  //           decodedTasks.map((taskJson) => Task.fromJson(taskJson)));
  //     }
  //     List<String> assignedTeamMembers = [];
  //     if (map['assignedTeamMembers'] != null &&
  //         map['assignedTeamMembers'].isNotEmpty) {
  //       var decodedAssignedTeamMembers = jsonDecode(map['assignedTeamMembers']);
  //       assignedTeamMembers = List<String>.from(decodedAssignedTeamMembers);
  //     }
  //     return Project(
  //       id: map['projectId'],
  //       projectName: map['name'],
  //       description: map['description'],
  //       owner: map['owner'],
  //       startDate: DateTime.parse(map['startDate']),
  //       endDate: DateTime.parse(map['endDate']),
  //       workHours: map['workHours'].toString(),
  //       teamMembers: map['teamMembers'].toString(),
  //       tasks: tasks,
  //       userId: map['userId'],
  //       assignedTeamMembers: assignedTeamMembers,
  //       completed: map['completed'] == 1,
  //     );
  //   });
  // }

  //Finalized method to get the tasks based on team member's login
  Future<List<Project>> getProjectsAndTasksForTeamMember(
      String teamMember) async {
    await _checkAndInitDB();

    print('Assigned team member: $teamMember');
    print('Running query...');

    final List<Map<String, dynamic>> projectMaps =
        await _database.query('projectsDdd');
    final normalizedTeamMember = teamMember.trim().toLowerCase();
    print('Normalized team member: $normalizedTeamMember');

    final List<Project> projectsWithTeamMember =
        projectMaps.where((projectMap) {
      final List<dynamic> tasksJson = jsonDecode(projectMap['tasks']);
      final List<Task> tasks =
          tasksJson.map((taskJson) => Task.fromJson(taskJson)).toList();
      print('Tasks in project ${projectMap['projectId']}:');
      tasks.forEach((task) {
        final normalizedTeamMembers = task.teamMembers
                ?.map((member) => member.trim().toLowerCase())
                .toList() ??
            [];
        print('${task.taskName}: $normalizedTeamMembers');
      });

      // return tasks
      //     .any((task) => task.teamMembers?.contains(teamMember) ?? false);
      final bool hasTeamMember = tasks.any((task) {
        final normalizedTeamMembers = task.teamMembers
                ?.map((member) => member.trim().toLowerCase())
                .toList() ??
            [];
        final containsMember =
            normalizedTeamMembers.contains(normalizedTeamMember);
        if (containsMember) {
          print(
              'Task ${task.taskName} contains team member $normalizedTeamMember');
        } else {
          print(
              'Task ${task.taskName} does NOT contain team member $normalizedTeamMember');
        }
        return containsMember;
      });

      return hasTeamMember;
    }).map((projectMap) {
      // final List<dynamic> tasksJson = jsonDecode(projectMap['tasks']);
      // final List<Task> tasks = tasksJson
      //     .map((taskJson) => Task.fromJson(taskJson))
      //     .where((task) => task.teamMembers?.contains(teamMember) ?? false)
      //     .toList();
      final List<dynamic> tasksJson = jsonDecode(projectMap['tasks']);
      final List<Task> tasks =
          tasksJson.map((taskJson) => Task.fromJson(taskJson)).where((task) {
        final normalizedTeamMembers = task.teamMembers
                ?.map((member) => member.trim().toLowerCase())
                .toList() ??
            [];
        return normalizedTeamMembers.contains(normalizedTeamMember);
      }).toList();
      print('inside map dbb ---- $projectMap, $projectMaps');
      print('Project with assigned tasks: ${projectMap['projectId']}');
      final List<String> assignedTeamMembers =
          projectMap['assignedTeamMembers'] != null &&
                  projectMap['assignedTeamMembers'].isNotEmpty
              ? List<String>.from(jsonDecode(projectMap['assignedTeamMembers']))
              : [];

      return Project(
        id: projectMap['projectId'],
        projectName: projectMap['name'],
        description: projectMap['description'],
        owner: projectMap['owner'],
        startDate: DateTime.parse(projectMap['startDate']),
        endDate: DateTime.parse(projectMap['endDate']),
        workHours: projectMap['workHours'].toString(),
        teamMembers: projectMap['teamMembers'].toString(),
        tasks: tasks,
        userId: projectMap['userId'],
        assignedTeamMembers: assignedTeamMembers,
        completed: projectMap['completed'] == 1,
      );
    }).toList();
    print('Projects with team member ----> $projectsWithTeamMember');
    return projectsWithTeamMember;
  }

  // Future<List<Project>> getAssignedTasks(String teamMember) async {
  //   await _checkAndInitDB();
  //   print('Assigned team member: $teamMember');
  //   print('Running query...');
  //   // final List<Map<String, dynamic>> maps = await _database.query(
  //   //   'projectsDdd',
  //   //   where: 'teamMembers LIKE ?',
  //   //   whereArgs: ['%"$teamMember"%'],
  //   // );
  //   // Ensure both the column and search value are in the same case
  //   final List<Map<String, dynamic>> maps = await _database.rawQuery(
  //     'SELECT * FROM projectsDdd WHERE LOWER(teamMembers) LIKE ?',
  //     ['%"${teamMember.toLowerCase()}"%'],
  //   );
  //   print('Query result: $maps');
  //   return List.generate(maps.length, (i) {
  //     final map = maps[i];
  //     print('Map: $map');
  //     List<Task> tasks = [];
  //     if (map['tasks'] != null) {
  //       var decodedTasks = jsonDecode(map['tasks']);
  //       // tasks = List<Task>.from(decodedTasks
  //       //     .map((taskJson) => Task.fromJson(taskJson))
  //       //     .where((task) => task.assignedTeamMembers.contains(teamMember)));
  //       tasks = List<Task>.from(decodedTasks.map((taskJson) {
  //         Task task = Task.fromJson(taskJson);
  //         // Filter tasks to only include those assigned to the team member
  //         if (task.teamMembers != null &&
  //             task.teamMembers!.contains(teamMember)) {
  //           return task;
  //         }
  //       }).where((task) => task != null));
  //     }
  //     List<String> assignedTeamMembers = [];
  //     if (map['assignedTeamMembers'] != null &&
  //         map['assignedTeamMembers'].isNotEmpty) {
  //       var decodedAssignedTeamMembers = jsonDecode(map['assignedTeamMembers']);
  //       assignedTeamMembers = List<String>.from(decodedAssignedTeamMembers);
  //     }
  //     return Project(
  //       id: map['projectId'],
  //       projectName: map['name'],
  //       description: map['description'],
  //       owner: map['owner'],
  //       startDate: DateTime.parse(map['startDate']),
  //       endDate: DateTime.parse(map['endDate']),
  //       workHours: map['workHours'].toString(),
  //       teamMembers: map['teamMembers'].toString(),
  //       tasks: tasks,
  //       userId: map['userId'],
  //       assignedTeamMembers: assignedTeamMembers,
  //       completed: map['completed'] == 1,
  //     );
  //   });
  // }

  // void _debugDatabase() async {
  //   await _checkAndInitDB();
  //   final List<Map<String, dynamic>> maps =
  //       await _database.query('projectsDdd');
  //   print('All projects: $maps');
  // }

  // Future<void> updateUserTaskStatus(
  //     int projectId, Task taskToUpdate, UserStatus newStatus) async {
  //   await _checkAndInitDB();
  //   try {
  //     final List<Map<String, dynamic>> projectMaps = await _database.query(
  //       'projectsDdd',
  //       where: 'projectId = ?',
  //       whereArgs: [projectId],
  //     );
  //     if (projectMaps.isNotEmpty) {
  //       final projectData = projectMaps.first;
  //       if (projectData['tasks'] != null) {
  //         var decodedTasks = jsonDecode(projectData['tasks']);
  //         List<Task> tasks = List<Task>.from(
  //             decodedTasks.map((taskJson) => Task.fromJson(taskJson)));
  //         // Find the task with the same properties as taskToUpdate
  //         Task? existingTask = tasks.firstWhere(
  //           (task) =>
  //               task.taskName == taskToUpdate.taskName &&
  //               task.description == taskToUpdate.description,
  //         );
  //         existingTask.userStatus = newStatus;
  //         final updatedTasksJson =
  //             jsonEncode(tasks.map((task) => task.toJson()).toList());
  //         await _database.update(
  //           'projectsDdd',
  //           {'tasks': updatedTasksJson},
  //           where: 'projectId = ?',
  //           whereArgs: [projectId],
  //           conflictAlgorithm: ConflictAlgorithm.replace,
  //         );
  //       } else {
  //         throw CustomException("Tasks not found in project");
  //       }
  //     } else {
  //       throw CustomException("Project not found");
  //     }
  //   } catch (e) {
  //     throw CustomException("Error updating user task status: $e");
  //   }
  // }

  // Future<void> updateTaskStatus(
  //     int projectId, String taskName, String member, UserStatus status) async {
  //   await _checkAndInitDB();
  //   try {
  //     final List<Map<String, dynamic>> maps = await _database.query(
  //       'projectsDdd',
  //       where: 'projectId = ?',
  //       whereArgs: [projectId],
  //     );
  //     if (maps.isNotEmpty) {
  //       List<Task> tasks = [];
  //       if (maps.first['tasks'] != null) {
  //         var decodedTasks = jsonDecode(maps.first['tasks']);
  //         tasks = List<Task>.from(
  //             decodedTasks.map((taskJson) => Task.fromJson(taskJson)));
  //       }
  //       int taskIndex = tasks.indexWhere((task) => task.taskName == taskName);
  //       if (taskIndex != -1) {
  //         tasks[taskIndex].updateUserStatus(member, status);
  //         final updatedTasksJson =
  //             jsonEncode(tasks.map((task) => task.toJson()).toList());
  //         await _database.update(
  //           'projectsDdd',
  //           {'tasks': updatedTasksJson},
  //           where: 'projectId = ?',
  //           whereArgs: [projectId],
  //           conflictAlgorithm: ConflictAlgorithm.replace,
  //         );
  //       } else {
  //         throw CustomException("Task not found in project");
  //       }
  //     } else {
  //       throw CustomException("Project not found");
  //     }
  //   } catch (e) {
  //     throw CustomException("Error updating task status: $e");
  //   }
  // }

  //Method for updating Task Status
  Future<void> updateTaskStatus(
      int projectId, String taskName, String member, UserStatus status) async {
    final normalizedMember = member.split('@').first.toLowerCase().trim();
    await _checkAndInitDB();
    try {
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

        int taskIndex = tasks.indexWhere((task) => task.taskName == taskName);
        if (taskIndex != -1) {
          Task task = tasks[taskIndex];
          List<String> normalizedTeamMembers = task.teamMembers!
              .map((teamMember) =>
                  teamMember.split('@').first.toLowerCase().trim())
              .toList();
          print("Normalized team members: $normalizedTeamMembers");
          if (normalizedTeamMembers.contains(normalizedMember)) {
            task.updateUserStatus(normalizedMember, status);

            final updatedTasksJson =
                jsonEncode(tasks.map((task) => task.toJson()).toList());
            await _database.update(
              'projectsDdd',
              {'tasks': updatedTasksJson},
              where: 'projectId = ?',
              whereArgs: [projectId],
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          } else {
            throw CustomException(
                "Member '$normalizedMember' not found in task team members");
          }
        } else {
          throw CustomException("Task not found in project");
        }
      } else {
        throw CustomException("Project not found");
      }
    } catch (e) {
      print("Error updating task status: $e");
      throw CustomException("Error updating task status: $e");
    }
  }
}
