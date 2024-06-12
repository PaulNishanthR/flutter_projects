import 'package:flutter_projects/domain/model/project.dart';

class CompletedProject {
  int? id;
  final Project project;
  final int userId;

  CompletedProject({
    this.id,
    required this.project,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'projectId': id,
      'userId': userId,
    };
  }

  // static CompletedProject fromMap(Map<String, dynamic> map) {
  //   return CompletedProject(
  //     id: map['projectId'],
  //     userId: map['userId'], project: ,
  //   );
  // }
}
