import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final DateTime dueDate;
  final int completion;
  final List<String> teamMembers;

  ProjectCard({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.dueDate,
    required this.completion,
    required this.teamMembers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(
          colors: [Colors.yellow, Colors.orangeAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Icon(Icons.more_vert, color: Colors.white),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Due: ${DateFormat('dd MMM').format(dueDate)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Text(
                'Completion: $completion/3',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: teamMembers
                .map((member) => CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(member),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
