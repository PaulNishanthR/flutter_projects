import 'package:flutter_projects/domain/repositories/project_repository.dart';
import 'package:flutter_projects/presentation/providers/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<int?> {
  final ProjectRepository _repository;

  UserNotifier(this._repository) : super(null);

  Future<int?> getUserId(String email) async {
    return await _repository.getUserId(email);
  }

  void setUserId(int userId) {
    state = userId;
  }
}

final userIdProvider = StateNotifierProvider<UserNotifier, int?>(
  (ref) => UserNotifier(ref.watch(projectRepositoryProvider)),
);
