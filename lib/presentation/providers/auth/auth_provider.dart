import 'package:flutter_projects/domain/repositories/project_repository.dart';
import 'package:flutter_projects/presentation/providers/project/project_provider.dart';
// import 'package:flutter_projects/presentation/providers/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref.read(projectRepositoryProvider));
});

class AuthNotifier extends StateNotifier<bool> {
  final ProjectRepository _repository;
  AuthNotifier(this._repository) : super(false);

  Future<bool> login(String userName, String userPassword) async {
    final result = await _repository.login(userName, userPassword);
    state = result;
    // print('login in provider---> $state');
    return result;
  }

  Future<void> signup(String userName, String userPassword) async {
    await _repository.signup(userName, userPassword);
    state = true;
    // print('signup in provider---> $state');
  }
}
