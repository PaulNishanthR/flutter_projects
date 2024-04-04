import 'package:flutter_projects/domain/model/project.dart';

abstract class ProjectRepository {
  Future<int?> getUserId(String email);
  Future<bool> login(String userName, String userPassword);
  Future<void> signup(String userName, String userPassword);
  Future<int> createProject(Project project, int userId);
  Future<void> editProject(int projectId, Project editedProject);
  Future<void> deleteProject(int projectId);
  Future<List<Project>> getUserProjects(int userId);
  Future<List<Project>> getAllProjects();
}
