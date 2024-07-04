import 'package:flutter_projects/data/datasources/project_datasource.dart';
import 'package:flutter_projects/domain/model/project/project.dart';
import 'package:flutter_projects/data/repositories/database_project_impl.dart';
import 'package:flutter_projects/domain/model/project/task.dart';
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
      print('edited in provider ----->>>> true');
      return true;
    } catch (e) {
      return false;
    }
  }

  // Future<bool> editProject(int projectId, Project updatedProject) async {
  //   try {
  //     await _repository.editProject(projectId, updatedProject);
  //     state = state.map((project) {
  //       if (project.id == projectId) {
  //         return project.copyWith(
  //           projectName: updatedProject.projectName,
  //           description: updatedProject.description,
  //           owner: updatedProject.owner,
  //           workHours: updatedProject.workHours,
  //           endDate: updatedProject.endDate,
  //           teamMembers: updatedProject.teamMembers,
  //         );
  //       } else {
  //         return project;
  //       }
  //     }).toList();
  //     print(
  //         'Project edited in provider ----->>>$state, ${updatedProject.workHours}, $projectId');
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

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
          return project.copyWith(completed: true, teamMembers: '');
        }
        return project;
      }).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> updateProjectTasks(int projectId, List<Task> tasks) async {
    try {
      int id = await _repository.updateTasks(projectId, tasks);
      state = state.map((project) {
        if (project.id == projectId) {
          return project.copyWith(tasks: tasks);
        }
        return project;
      }).toList();
      return id;
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
          return project.copyWith(tasks: updatedTasks, teamMembers: '');
        }
        return project;
      }).toList();
    } catch (e) {
      throw CustomException("Unable to update the task");
    }
  }

  Future<bool> isMemberAssignedToAnotherProject(String member) async {
    try {
      return await _repository.isTeamMemberAssigned(member);
    } catch (e) {
      return false;
    }
  }

  Future<void> getCompletedProjectsFromDB(
      int userId, int projectId, bool completed) async {
    try {
      await _repository.getCompletedProjectsFromTable(userId, projectId, true);
    } catch (e) {
      throw CustomException(
          "Unable to fetch completed projects in providerrrr");
    }
  }

  Future<void> updateTaskStatus(int projectId, String taskName,
      String memberName, UserStatus newStatus) async {
    try {
      final projectIndex =
          state.indexWhere((project) => project.id == projectId);
      if (projectIndex == -1) {
        throw CustomException("Project not found");
      }
      final project = state[projectIndex];

      final taskIndex =
          project.tasks.indexWhere((task) => task.taskName == taskName);
      if (taskIndex == -1) {
        throw CustomException("Task not found");
      }
      final task = project.tasks[taskIndex];

      final updatedMemberStatuses = {...task.memberStatuses};
      updatedMemberStatuses[memberName] = newStatus;

      final updatedTasks = List<Task>.from(project.tasks);
      updatedTasks[taskIndex] =
          task.copyWith(memberStatuses: updatedMemberStatuses);

      final updatedProjects = List<Project>.from(state);
      updatedProjects[projectIndex] = project.copyWith(tasks: updatedTasks);
      state = updatedProjects;
    } catch (e) {
      throw CustomException("Error updating task status: $e");
    }
  }

  Future<void> changeStatus(List<Project> projects) async {
    for (var project in projects) {
      for (var task in project.tasks) {
        for (var member in task.memberStatuses.keys) {
          await task.loadStatusFromPrefs(member);
        }
      }
    }
  }

  Future<List<Project>> getProjectsAndTasksForTeamMember(
      String teamMember) async {
    try {
      return await _repository.getProjectsAndTasksForTeamMember(teamMember);
    } catch (e) {
      throw CustomException(
          "Unable to fetch projects and tasks for team member");
    }
  }
}
