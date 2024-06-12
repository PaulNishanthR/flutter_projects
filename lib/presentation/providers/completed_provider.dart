import 'package:flutter_projects/data/datasources/project_datasource.dart';
import 'package:flutter_projects/data/repositories/database_project_impl.dart';
import 'package:flutter_projects/domain/model/completed_project.dart';
import 'package:flutter_projects/domain/model/project.dart';
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

  CompletedNotifier(this._repository) : super([]);

  Future<void> insertCompletedProject(
    Project project,
  ) async {
    final completedProject =
        CompletedProject(project: project, userId: project.userId);
    state = [...state, completedProject];
    try {
      // print('GEtting Compelted in pro $project');
      int id = await _repository.insertCompletedProjects(
        project,
      );
      // print("completed tasks in provider with project ID---> $project");
      project.id = id;
    } catch (e) {
      // print('Error inserting completed project: $e');
    }
  }

  Future<List<CompletedProject>> fetchCompletedProjects(int userId) async {
    // try {
    //   final completedProjects = await _repository.getCompletedProjects();
    //   state = completedProjects;
    //   print(
    //       "fetched completed projects from DB---> $state, $completedProjects");
    // } catch (e) {
    //   print('Error fetching completed projects: $e');
    // }
    List<CompletedProject> project =
        await _repository.getCompletedProjects(userId);
    return state = project;
  }
}
