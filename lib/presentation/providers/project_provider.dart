import 'package:flutter_projects/data/datasources/project_datasource.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/data/repositories/database_project_impl.dart';
import 'package:flutter_projects/domain/model/task.dart';
import 'package:flutter_projects/domain/repositories/project_repository.dart';
import 'package:flutter_projects/utils/constants/custom_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final projectsProvider =
    StateNotifierProvider<ProjectsNotifier, List<Project>>((ref) {
  return ProjectsNotifier(ref.read(projectRepositoryProvider));
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return DatabaseProjectRepository(ref.read(databaseHelperProvider));
});

final databaseHelperProvider = Provider<ProjectDataSource>((ref) {
  return ProjectDataSource.instance;
});

class ProjectsNotifier extends StateNotifier<List<Project>> {
  final ProjectRepository _repository;

  ProjectsNotifier(this._repository) : super([]) {
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    try {
      List<Project> projects = await _repository.getAllProjects();
      state = projects;
    } catch (e) {
      CustomException("Unable to fetch projects");
    }
  }

  Future<bool> addProject(Project project, int userId) async {
    try {
      int projectId = await _repository.createProject(project, userId);
      project = project.copyWithID(projectId);
      state = [...state, project];
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editProject(int projectId, Project editedProject) async {
    try {
      await _repository.editProject(projectId, editedProject);
      state = state.map((project) {
        if (project.id == projectId) {
          return editedProject;
        }
        return project;
      }).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteProject(int projectId) async {
    try {
      await _repository.deleteProject(projectId);
      state = state.where((project) => project.id != projectId).toList();
    } catch (e) {
      CustomException("Unable to Delete Project");
    }
  }

  Future<void> getProjects(int userId) async {
    try {
      List<Project> userProjects = await _repository.getUserProjects(userId);
      state = userProjects;
    } catch (e) {
      CustomException("Unable to get the projects");
    }
  }

  Future<bool> markProjectAsCompleted(int projectId) async {
    try {
      await _repository.markProjectAsCompleted(projectId);
      state = state.map((project) {
        if (project.id == projectId) {
          return project.copyWith(completed: true);
        }
        return project;
      }).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateProjectTasks(int projectId, List<Task> tasks) async {
    try {
      await _repository.updateTasks(projectId, tasks);
      print("tasks updated in database $projectId, $tasks");
    } catch (e) {
      throw CustomException("Unable to update tasks in dbbb");
    }
  }

  Future<List<Task>> getTasks(int projectId) async {
    try {
      List<Task> userTasks = await _repository.getUserTasks(projectId);
      return userTasks;
    } catch (e) {
      throw CustomException("Unable to get the projects");
    }
  }

  Future<void> updateTask(int projectId, Task updatedTask) async {
    try {
      await _repository.updateTask(projectId, updatedTask);
      state = state.map((project) {
        if (project.id == projectId) {
          List<Task> updatedTasks = project.tasks.map((task) {
            return task.id == updatedTask.id ? updatedTask : task;
          }).toList();
          return project.copyWith(tasks: updatedTasks);
        }
        return project;
      }).toList();
      print("task updated in provider");
    } catch (e) {
      throw CustomException("Unable to update the task");
    }
  }
}
