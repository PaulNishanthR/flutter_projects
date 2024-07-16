import 'package:shared_preferences/shared_preferences.dart';

enum TaskStatus { todo, inProgress, completed }

enum UserStatus { todo, onProgress, done }

enum TaskPriority { low, medium, high }

class Task {
  int? id;
  String taskName;
  String description;
  DateTime dueDate;
  bool status;
  List<String>? teamMembers;
  List<String>? assignedMembers;
  String? hours;
  TaskStatus taskStatus;
  Map<String, UserStatus> memberStatuses;
  TaskPriority taskPriority;

  Task({
    this.id,
    required this.taskName,
    required this.description,
    required this.dueDate,
    required this.status,
    this.teamMembers,
    this.assignedMembers,
    this.hours,
    this.taskStatus = TaskStatus.todo,
    this.taskPriority = TaskPriority.low,
    Map<String, UserStatus>? memberStatuses,
  }) : memberStatuses = memberStatuses ?? {};

  Task copyWith({
    int? id,
    String? taskName,
    String? description,
    DateTime? dueDate,
    bool? status,
    List<String>? teamMembers,
    List<String>? assignedMembers,
    String? hours,
    TaskStatus? taskStatus,
    TaskPriority? taskPriority,
    Map<String, UserStatus>? memberStatuses,
  }) {
    return Task(
      id: id ?? this.id,
      taskName: taskName ?? this.taskName,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      teamMembers: teamMembers ?? this.teamMembers,
      assignedMembers: assignedMembers ?? this.assignedMembers,
      hours: hours ?? this.hours,
      taskStatus: taskStatus ?? this.taskStatus,
      taskPriority: taskPriority ?? this.taskPriority,
      memberStatuses: memberStatuses ?? this.memberStatuses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': id,
      'name': taskName,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'teamMembers': teamMembers,
      'assignedMembers': assignedMembers,
      'hours': hours,
      'taskStatus': taskStatus.toString().split('.').last,
      'taskPriority': taskPriority.toString().split('.').last,
      'memberStatuses': memberStatuses
          .map((key, value) => MapEntry(key, value.toString().split('.').last)),
    };
  }

  List<String> getTeamMembersList() {
    return teamMembers!
        .join(',')
        .split(',')
        .map((member) => member.trim())
        .toList();
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['taskId'],
      taskName: json['name'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : DateTime.now(),
      teamMembers: json['teamMembers'] != null
          ? List<String>.from(json['teamMembers'])
          : null,
      status: json['status'] ?? false,
      hours: json['hours'],
      taskStatus: TaskStatus.values.firstWhere(
        (e) => e.toString() == 'TaskStatus.${json['taskStatus']}',
        orElse: () => TaskStatus.todo,
      ),
      taskPriority: TaskPriority.values.firstWhere(
        (e) => e.toString() == 'TaskPriority.${json['taskPriority']}',
        orElse: () => TaskPriority.low,
      ),
      memberStatuses: (json['memberStatuses'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(
                  key,
                  UserStatus.values.firstWhere(
                      (e) => e.toString() == 'UserStatus.$value'))) ??
          {},
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['taskId'],
      taskName: map['name'] ?? '',
      description: map['description'] ?? '',
      dueDate: DateTime.parse(map['dueDate'] ?? ''),
      status: map['status'] ?? false,
      teamMembers: map['teamMembers'] != null
          ? List<String>.from(map['teamMembers'])
          : null,
      assignedMembers: map['assignedMembers'] != null
          ? List<String>.from(map['assignedMembers'])
          : null,
      hours: map['hours'] ?? '',
      taskStatus: TaskStatus.values.firstWhere(
        (e) => e.toString() == 'TaskStatus.${map['taskStatus']}',
        orElse: () => TaskStatus.todo,
      ),
      taskPriority: TaskPriority.values.firstWhere(
        (e) => e.toString() == 'TaskPriority.${map['taskPriority']}',
        orElse: () => TaskPriority.low,
      ),
      memberStatuses: (map['memberStatuses'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              UserStatus.values.firstWhere(
                (e) => e.toString() == 'UserStatus.$value',
                orElse: () => UserStatus.todo,
              ),
            ),
          ) ??
          {},
    );
  }

  /// Shared Preferences --->
  void updateUserStatus(String member, UserStatus status) {
    memberStatuses[member] = status;
  }

  Future<void> saveStatusToPrefs(String member, UserStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'task_${this.taskName}_$member';
    print('saved shared --- task_${this.taskName}_$member');
    print('saved shared --- task_${this.memberStatuses}_$member');
    await prefs.setString(key, status.toString().split('.').last);
  }

  Future<void> loadStatusFromPrefs(String member) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'task_${this.taskName}_$member';
    print('shared --- task_${this.taskName}_$member');
    print('shared team member ---> task_${this.teamMembers}_$member');
    print('shared --- task_${this.memberStatuses}_$member');
    final savedStatus = prefs.getString(key);
    print('savedStatus ---------- $savedStatus');
    if (savedStatus != null) {
      final status = UserStatus.values.firstWhere(
        (e) => e.toString().split('.').last == savedStatus,
        orElse: () => UserStatus.todo,
      );
      memberStatuses[member] = status;
    }
    print('PPPPPPPPPPPPPPPPPPPPPP - $status');
    print('in shareddd ---- >>> ${memberStatuses[member]}');
  }

  void updateUseraStatus(String member, UserStatus status) {
    memberStatuses[member] = status;
    saveStatusToPrefs(member, status);
  }

  Future<void> loadAllMemberStatuses() async {
    for (String member in memberStatuses.keys) {
      await loadStatusFromPrefs(member);
    }
  }
}
