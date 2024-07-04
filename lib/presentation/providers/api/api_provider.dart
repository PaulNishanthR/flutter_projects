import 'package:flutter_projects/domain/model/api/members.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class ApiCallForMemberNotifier extends StateNotifier<List<Member>> {
  ApiCallForMemberNotifier() : super([]) {
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    try {
      final response = await Dio()
          .get('https://api-generator.retool.com/QmZ5OU/memberslist');
      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data as List<dynamic>;
        final members = responseData
            .map((memberJson) => Member.fromJson(memberJson))
            .toList();
        state = members;
      } else {
        print(
            'Failed to load members with status code: ${response.statusCode}');
        state = [];
      }
    } catch (error) {
      print('Error fetching members: $error');
      state = [];
    }
  }
}

final membersProvider =
    StateNotifierProvider<ApiCallForMemberNotifier, List<Member>>((ref) {
  return ApiCallForMemberNotifier();
});
