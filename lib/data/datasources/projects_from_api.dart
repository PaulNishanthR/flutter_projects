import 'package:dio/dio.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:intl/intl.dart';

class APiFetch {
  final dio = Dio();
  Future<List<Project>> getHttp() async {
    try {
      final response =
          await dio.get('https://api-generator.retool.com/JOlVrH/dataas');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((item) => _parseProject(item)).toList();
      } else {
        throw Exception('Failed to load projects');
      }
    } catch (e) {
      // print('Error fetching projects: $e');
      rethrow;
    }
  }
}

Project _parseProject(Map<String, dynamic> json) {
  List<Task> tasks = [];
  if (json['tasks'] != null) {
    tasks = _parseTasks(json['tasks']);
  }
  return Project(
    id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
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
  );
}

DateTime _parseDateTime(dynamic dateString) {
  if (dateString is String) {
    if (RegExp(r'\d{1,2}/\d{1,2}/\d{4}').hasMatch(dateString)) {
      return DateFormat('MM/dd/yyyy').parse(dateString);
    } else if (RegExp(r'\d{4}-\d{2}-\d{2}').hasMatch(dateString)) {
      return DateFormat('yyyy-MM-dd').parse(dateString);
    }
  }
  return DateTime.now();
}

String _parseTeamMembers(dynamic teamMembers) {
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

List<Task> _parseTasks(dynamic tasks) {
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
