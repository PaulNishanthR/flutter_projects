import 'dart:convert';

class Task {
  int? id;
  String taskName;
  String description;
  DateTime dueDate;
  bool status;
  List<String>? teamMembers;
  List<String>? assignedMembers;

  Task(
      {required this.taskName,
      required this.description,
      required this.dueDate,
      required this.status,
      this.teamMembers,
      this.assignedMembers});

  Map<String, dynamic> toJson() {
    return {
      'name': taskName,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'teamMembers': teamMembers,
      'assignedMembers': assignedMembers,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    // ignore: unnecessary_null_comparison
    if (json == null) {
      throw ArgumentError('Invalid JSON data for Task');
    }
    return Task(
      taskName: json['taskName'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : DateTime.now(),
      status: json['status'] ?? false,
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    // ignore: unnecessary_null_comparison
    if (map == null) {
      throw ArgumentError('Invalid map data for Task');
    }
    return Task(
      taskName: map['taskName'] ?? '',
      description: map['description'] ?? '',
      dueDate: DateTime.parse(map['dueDate'] ?? ''),
      status: map['status'] ?? false,
      teamMembers: map['teamMembers'] != null
          ? List<String>.from(map['teamMembers'])
          : null,
      assignedMembers: map['assignedMembers'] != null
          ? List<String>.from(map['assignedMembers'])
          : null,
    );
  }
}

class Project {
  final int? id;
  final int userId;
  final String projectName;
  final String description;
  final String owner;
  final DateTime startDate;
  final DateTime endDate;
  final String workHours;
  final String teamMembers;
  final List<Task> tasks;

  Project({
    this.id,
    required this.userId,
    required this.projectName,
    required this.description,
    required this.owner,
    required this.startDate,
    required this.endDate,
    required this.workHours,
    required this.teamMembers,
    required this.tasks,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': projectName,
      'description': description,
      'owner': owner,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'workHours': workHours,
      'teamMembers': teamMembers,
      'tasks': jsonEncode(tasks),
    };
  }

  Project copyWith({
    int? id,
    String? projectName,
    String? description,
    String? owner,
    DateTime? startDate,
    DateTime? endDate,
    String? workHours,
    String? teamMembers,
  }) {
    return Project(
      id: id ?? this.id,
      userId: userId,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      owner: owner ?? this.owner,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      workHours: workHours ?? this.workHours,
      teamMembers: teamMembers ?? this.teamMembers,
      tasks: tasks,
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
    );
  }
}
