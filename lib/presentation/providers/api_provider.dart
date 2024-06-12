import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class ApiCall extends StateNotifier<List<Project>> {
  ApiCall() : super([]) {
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    try {
      final response =
          await Dio().get('https://api-generator.retool.com/JOlVrH/dataas');
      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data as List<dynamic>;
        final projects = responseData
            .map((projectJson) => Project.fromJson(projectJson))
            .toList();
        state = projects;
        // print("projects from api:$projects");
      } else {
        state = [];
      }
    } catch (error) {
      state = [];
    }
  }
}

final apiProvider = StateNotifierProvider<ApiCall, List<Project>>((ref) {
  return ApiCall();
});
