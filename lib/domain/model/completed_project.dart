import 'task.dart';

class CompletedProject {
  int? id;
  final String projectName;
  final String description;
  final String owner;
  final DateTime startDate;
  final DateTime endDate;
  final String workHours;
  final String teamMembers;
  final List<Task> tasks;
  final int userId;

  CompletedProject({
    this.id,
    required this.projectName,
    required this.description,
    required this.owner,
    required this.startDate,
    required this.endDate,
    required this.workHours,
    required this.teamMembers,
    required this.tasks,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'projectId': id,
      'name': projectName,
      'description': description,
      'owner': owner,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'workHours': workHours,
      'teamMembers': teamMembers,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'userId': userId,
    };
  }

  static CompletedProject fromMap(Map<String, dynamic> map) {
    return CompletedProject(
      id: map['projectId'],
      projectName: map['name'],
      description: map['description'],
      owner: map['owner'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      workHours: map['workHours'].toString(),
      teamMembers: map['teamMembers'].toString(),
      tasks: List<Task>.from(
          (map['tasks'] as List).map((taskJson) => Task.fromJson(taskJson))),
      userId: map['userId'],
    );
  }
}
