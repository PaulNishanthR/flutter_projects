import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/task.dart';

class MemberProjectDetailsPage extends StatefulWidget {
  final Task tasks;

  const MemberProjectDetailsPage({Key? key, required this.tasks})
      : super(key: key);

  @override
  State<MemberProjectDetailsPage> createState() =>
      _MemberProjectDetailsPageState();
}

class _MemberProjectDetailsPageState extends State<MemberProjectDetailsPage> {
  late bool _isStatusYes;

  @override
  void initState() {
    super.initState();
    _isStatusYes = widget.tasks.status == 'yes' as bool;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tasks.taskName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Task Name: ${widget.tasks.taskName}'),
            Text('Due Date: ${widget.tasks.dueDate.toString()}'),
            // Text('Status: ${_isStatusYes ? 'yes' : 'no'}'),
            // Text('Status: ${widget.tasks.status == 'yes' ? 'yes' : 'no'}'),
            Text('Status: ${_isStatusYes ? 'yes' : 'no'}'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isStatusYes = !_isStatusYes;
                });
              },
              child: const Text('Edit Status'),
              // child:
              //     Text(_isStatusYes ? 'Set Status to No' : 'Set Status to Yes'),
            ),
          ],
        ),
      ),
    );
  }
}
