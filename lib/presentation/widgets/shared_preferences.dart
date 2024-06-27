import 'package:shared_preferences/shared_preferences.dart';

class MemberSession {
  static const _keyMemberName = 'memberName';

  static Future<void> saveMemberName(String memberName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMemberName, memberName);
  }

  static Future<String?> getMemberName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMemberName);
  }

  static Future<void> clearMemberSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyMemberName);
  }
}
