import 'package:flutter_projects/data/datasources/project_datasource.dart';
import 'package:flutter_projects/data/repositories/database_project_impl.dart';
import 'package:flutter_projects/domain/model/completed_project.dart';
import 'package:flutter_projects/domain/repositories/project_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final completedProvider =
    StateNotifierProvider<CompletedNotifier, List<CompletedProject>>((ref) {
  return CompletedNotifier(ref.read(projectRepositoryProvider));
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return DatabaseProjectRepository(ref.read(databaseHelperProvider));
});

final databaseHelperProvider = Provider<ProjectDataSource>((ref) {
  return ProjectDataSource.instance;
});

class CompletedNotifier extends StateNotifier<List<CompletedProject>> {
  final ProjectRepository _repository;

  CompletedNotifier(this._repository) : super([]) {}

  Future<void> insertCompletedProject(
      CompletedProject project, int projectId) async {
    state = [...state, project];
    try {
      print('GEtting Compelted in pro $project');
      int id = await _repository.insertCompletedProjects(project, projectId);
      project.id = id;
      print("completed tasks in provider with project ID---> $projectId");
    } catch (e) {
      print('Error inserting completed project: $e');
    }
  }

  Future<void> fetchCompletedProjects() async {
    try {
      final completedProjects = await _repository.getCompletedProjects();
      state = completedProjects;
      print(
          "fetched completed projects from DB---> $state, $completedProjects");
    } catch (e) {
      print('Error fetching completed projects: $e');
    }
  }
}
