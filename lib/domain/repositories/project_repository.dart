import 'package:flutter_projects/domain/model/notification/notification.dart';
import 'package:flutter_projects/domain/model/project/project.dart';
import 'package:flutter_projects/domain/model/project/task.dart';

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
  Future<int> updateTasks(int projectId, List<Task> tasks);
  Future<List<Task>> getUserTasks(int projectId);
  Future<void> updateTask(int projectId, Task updatedTask);
  Future<bool> isTeamMemberAssigned(String teamMember);
  Future<Project> getCompletedProjectsFromTable(
      int userId, int projectId, bool completed);
  Future<List<Project>> getProjectsAndTasksForTeamMember(String teamMember);
  Future<void> updateTaskStatus(
      int projectId, String taskName, String member, UserStatus status);
  Future<void> create(NotificationModel notification);
  Future<int> getCountOfUnreadNotifications();
  Future<Project> getUnCompletedProjectsFromTable(
      int userId, int projectId, bool completed);
}
