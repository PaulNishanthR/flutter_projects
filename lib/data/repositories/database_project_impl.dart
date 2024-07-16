import 'package:flutter_projects/domain/model/notification/notification.dart';
import 'package:flutter_projects/domain/model/project/project.dart';
import 'package:flutter_projects/data/datasources/project_datasource.dart';
import 'package:flutter_projects/domain/model/project/task.dart';
import 'package:flutter_projects/domain/repositories/project_repository.dart';

class DatabaseProjectRepository implements ProjectRepository {
  final ProjectDataSource _dataSource;

  DatabaseProjectRepository(this._dataSource);

  @override
  Future<int?> getUserId(String email) async {
    return await _dataSource.getUserId(email);
  }

  @override
  Future<bool> login(String userName, String userPassword) async {
    return await _dataSource.login(userName, userPassword);
  }

  @override
  Future<void> signup(String userName, String userPassword) async {
    return await _dataSource.signup(userName, userPassword);
  }

  @override
  Future<bool> checkUserExists(String userName) async {
    return await _dataSource.checkUserExists(userName);
  }

  @override
  Future<int> createProject(Project project, int userId) async {
    return await _dataSource.createProject(project, userId);
  }

  @override
  Future<void> editProject(int projectId, Project editedProject) async {
    await _dataSource.editProject(projectId, editedProject);
  }

  @override
  Future<void> deleteProject(int projectId) async {
    await _dataSource.deleteProject(projectId);
  }

  @override
  Future<List<Project>> getUserProjects(int userId) async {
    // print('Implementaionnnn--->');
    var impleProject = await _dataSource.getUserProjects(userId);
    // print('Impleeeeee$impleProject');
    return impleProject;
  }

  @override
  Future<List<Project>> getAllProjects() async {
    return await _dataSource.getAllProjects();
  }

  @override
  Future<void> markProjectAsCompleted(int projectId) async {
    return await _dataSource.markProjectAsCompleted(projectId);
  }

  @override
  Future<int> updateTasks(int projectId, List<Task> tasks) async {
    // print('Imple - ${tasks}');
    return await _dataSource.updateTasks(projectId, tasks);
  }

  @override
  Future<List<Task>> getUserTasks(int projectId) async {
    return await _dataSource.getUserTasks(projectId);
  }

  @override
  Future<void> updateTask(int projectId, Task updatedTask) async {
    return await _dataSource.updateTask(projectId, updatedTask);
  }

  @override
  Future<bool> isTeamMemberAssigned(String teamMember) async {
    return await _dataSource.isTeamMemberAssigned(teamMember);
  }

  @override
  Future<Project> getCompletedProjectsFromTable(
      int userId, int projectId, bool completed) async {
    return await _dataSource.getCompletedProjectsFromTable(
        userId, projectId, completed);
  }

  @override
  Future<List<Project>> getProjectsAndTasksForTeamMember(
      String teamMember) async {
    return await _dataSource.getProjectsAndTasksForTeamMember(teamMember);
  }

  @override
  Future<void> updateTaskStatus(
      int projectId, String taskName, String member, UserStatus status) async {
    return await _dataSource.updateTaskStatus(
        projectId, taskName, member, status);
  }

  @override
  Future<void> create(NotificationModel notification) async {
    await _dataSource.create(notification);
  }

  @override
  Future<int> getCountOfUnreadNotifications() async {
    return await _dataSource.getCountOfUnreadNotifications();
  }

  @override
  Future<Project> getUnCompletedProjectsFromTable(
      int userId, int projectId, bool completed) async {
    return await _dataSource.getUnCompletedProjectsFromTable(
        userId, projectId, completed);
  }
}
