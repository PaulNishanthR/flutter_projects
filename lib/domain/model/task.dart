class Task {
  int? id;
  String taskName;
  String description;
  DateTime dueDate;
  bool status;
  List<String>? teamMembers;
  List<String>? assignedMembers;

  Task(
      {required this.taskName,
      required this.description,
      required this.dueDate,
      required this.status,
      this.teamMembers,
      this.assignedMembers});

  Map<String, dynamic> toJson() {
    return {
      'name': taskName,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'teamMembers': teamMembers,
      'assignedMembers': assignedMembers,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    // if (json == null) {
    //   throw ArgumentError('Invalid JSON data for Task');
    // }
    return Task(
      taskName: json['taskName'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : DateTime.now(),
      status: json['status'] ?? false,
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    // if (map == null) {
    //   throw ArgumentError('Invalid map data for Task');
    // }
    return Task(
      taskName: map['taskName'] ?? '',
      description: map['description'] ?? '',
      dueDate: DateTime.parse(map['dueDate'] ?? ''),
      status: map['status'] ?? false,
      teamMembers: map['teamMembers'] != null
          ? List<String>.from(map['teamMembers'])
          : null,
      assignedMembers: map['assignedMembers'] != null
          ? List<String>.from(map['assignedMembers'])
          : null,
    );
  }
}
