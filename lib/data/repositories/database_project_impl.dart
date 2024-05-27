import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/data/datasources/project_datasource.dart';
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
    return await _dataSource.getUserProjects(userId);
  }

  @override
  Future<List<Project>> getAllProjects() async {
    return await _dataSource.getAllProjects();
  }

  @override
  Future<void> markProjectAsCompleted(int projectId) async {
    // throw UnimplementedError();
    return await _dataSource.markProjectAsCompleted(projectId);
  }
}
