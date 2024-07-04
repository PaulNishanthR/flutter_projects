class NotificationModel {
  final int id;
  final int projectId;
  final String message;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.projectId,
    required this.message,
    required this.isRead,
  });

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'message': message,
      'isRead': isRead ? 1 : 0,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      projectId: map['projectId'],
      message: map['message'],
      isRead: map['isRead'] == 1,
    );
  }

  NotificationModel copyWith({
    int? id,
    int? projectId,
    String? message,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
    );
  }
}
