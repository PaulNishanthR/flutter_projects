import 'package:flutter_projects/domain/model/completed_project.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/domain/model/task.dart';

abstract class ProjectRepository {
  Future<int?> getUserId(String email);
  Future<bool> login(String userName, String userPassword);
  Future<void> signup(String userName, String userPassword);
  Future<bool> checkUserExists(String userName);
  Future<int> createProject(Project project, int userId);
  Future<void> editProject(int projectId, Project editedProject);
  Future<void> deleteProject(int projectId);
  Future<List<Project>> getUserProjects(int userId);
  Future<List<Project>> getAllProjects();
  Future<void> markProjectAsCompleted(int projectId);
  Future<void> updateTasks(int projectId, List<Task> tasks);
  Future<List<Task>> getUserTasks(int projectId);
  Future<void> updateTask(int projectId, Task updatedTask);
  Future<List<CompletedProject>> getCompletedProjects();
  Future<int> insertCompletedProjects(CompletedProject project, int projectId);
}
