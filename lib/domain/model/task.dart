class Task {
  int? id;
  String taskName;
  String description;
  DateTime dueDate;
  bool status;
  List<String>? teamMembers;
  List<String>? assignedMembers;
  String? hours;

  Task({
    this.id,
    required this.taskName,
    required this.description,
    required this.dueDate,
    required this.status,
    this.teamMembers,
    this.assignedMembers,
    this.hours,
  });

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
    // if (json == null) {
    //   throw ArgumentError('Invalid JSON data for Task');
    // }
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
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    // if (map == null) {
    //   throw ArgumentError('Invalid map data for Task');
    // }
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
    );
  }
}
