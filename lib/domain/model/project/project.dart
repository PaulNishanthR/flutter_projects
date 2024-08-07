import 'dart:convert';
import 'package:flutter_projects/domain/model/project/task.dart';
import 'package:intl/intl.dart';

class Project {
  int? id;
   int userId;
  final String projectName;
  final String description;
  final String owner;
  DateTime startDate;
  DateTime endDate;
  final String workHours;
  final String teamMembers;
  List<Task> tasks;
  bool completed;
  List<String>? assignedTeamMembers;
  String? interval;

  Project(
      {this.id,
      required this.userId,
      required this.projectName,
      required this.description,
      required this.owner,
      required this.startDate,
      required this.endDate,
      required this.workHours,
      required this.teamMembers,
      required this.tasks,
      this.completed = false,
      this.assignedTeamMembers,
      this.interval});

  List<String> getAssignedTeamMembersList() {
    return assignedTeamMembers!.map((member) => member.trim()).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': projectName,
      'description': description,
      'owner': owner,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'workHours': workHours,
      'teamMembers': teamMembers,
      // 'tasks': jsonEncode(tasks),
      'tasks': jsonEncode(tasks.map((task) => task.toJson()).toList()),
      'assignedTeamMembers': jsonEncode(assignedTeamMembers),
      'interval': 'ongoing',
    };
  }

  Project copyWith(
      {int? id,
      int? userId,
      String? projectName,
      String? description,
      String? owner,
      DateTime? startDate,
      DateTime? endDate,
      String? workHours,
      String? teamMembers,
      List<Task>? tasks,
      bool? completed,
      String? interval}) {
    return Project(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      owner: owner ?? this.owner,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      workHours: workHours ?? this.workHours,
      teamMembers: teamMembers ?? this.teamMembers,
      tasks: tasks ?? this.tasks,
      completed: completed ?? this.completed,
      interval: interval ?? this.interval,
    );
  }

  Project copyWithID(int newId) {
    return Project(
        id: newId,
        userId: userId,
        projectName: projectName,
        description: description,
        owner: owner,
        startDate: startDate,
        endDate: endDate,
        workHours: workHours,
        teamMembers: teamMembers,
        tasks: tasks,
        completed: completed,
        interval: interval);
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    var tasksFromJson = json['tasks'] != null ? jsonDecode(json['tasks']) : [];
    List<Task> tasksList =
        tasksFromJson.map<Task>((taskJson) => Task.fromJson(taskJson)).toList();

    var assignedMembersFromJson = json['assignedTeamMembers'] != null
        ? jsonDecode(json['assignedTeamMembers'])
        : [];
    List<String> assignedMembersList =
        List<String>.from(assignedMembersFromJson);

    return Project(
      id: json['projectId'],
      projectName: json['name'],
      description: json['description'],
      owner: json['owner'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      workHours: json['workHours'].toString(),
      teamMembers: json['teamMembers'].toString(),
      tasks: tasksList,
      userId: json['userId'],
      assignedTeamMembers: assignedMembersList,
      completed: json['completed'] == 1,
      interval: json['interval'],
    );
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    List<Task> tasks = [];
    if (map['tasks'] != null) {
      var decodedTasks = jsonDecode(map['tasks']);
      tasks = List<Task>.from(
          decodedTasks.map((taskJson) => Task.fromMap(taskJson)));
    }
    return Project(
      id: map['projectId'],
      userId: map['userId'],
      projectName: map['name'],
      description: map['description'],
      owner: map['owner'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      workHours: map['workHours'].toString(),
      teamMembers: map['teamMembers'].toString(),
      tasks: tasks,
      assignedTeamMembers:
          List<String>.from(jsonDecode(map['assignedTeamMembers'])),
      interval: map['interval'],
    );
  }

  factory Project.parseProject(Map<String, dynamic> json) {
    List<Task> tasks = _parseTasks(json['tasks']);
    return Project(
      id: json['id'] ?? '',
      userId: json['userId'] != null
          ? int.tryParse(json['userId'].toString()) ?? 0
          : 0,
      projectName: json['projectName'] ?? '',
      description: json['description'] ?? '',
      owner: json['owner'] != null ? json['owner'].toString() : '',
      startDate: json['startdate'] != null
          ? _parseDateTime(json['startdate'])
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? _parseDateTime(json['endDate'])
          : DateTime.now(),
      workHours: json['workHours']?.toString() ?? '',
      teamMembers: _parseTeamMembers(json['teamMembers']),
      tasks: tasks,
      completed: json['completed'] ?? false,
      interval: json['interval'],
    );
  }

  static DateTime _parseDateTime(dynamic dateString) {
    if (dateString is String) {
      if (RegExp(r'\d{1,2}/\d{1,2}/\d{4}').hasMatch(dateString)) {
        return DateFormat('MM/dd/yyyy').parse(dateString);
      } else if (RegExp(r'\d{4}-\d{2}-\d{2}').hasMatch(dateString)) {
        return DateFormat('yyyy-MM-dd').parse(dateString);
      }
    }
    return DateTime.now();
  }

  static String _parseTeamMembers(dynamic teamMembers) {
    if (teamMembers == null) {
      return '';
    } else if (teamMembers is int) {
      return teamMembers.toString();
    } else if (teamMembers is String) {
      return teamMembers;
    } else {
      return '';
    }
  }

  static List<Task> _parseTasks(dynamic tasks) {
    if (tasks == null || tasks is String) {
      return [];
    }
    return (tasks as List<dynamic>).map((taskJson) {
      return Task(
        taskName: taskJson['taskName'] ?? '',
        description: taskJson['description'] ?? '',
        dueDate: taskJson['dueDate'] != null
            ? DateTime.parse(taskJson['dueDate'])
            : DateTime.now(),
        status: taskJson['status'] ?? false,
      );
    }).toList();
  }
}
