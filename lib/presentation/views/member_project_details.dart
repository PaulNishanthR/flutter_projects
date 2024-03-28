// import 'package:flutter/material.dart';
// import 'package:flutter_projects/data/model/project.dart';

// class MemberProjectDetailsPage extends StatelessWidget {
//   final Task tasks;

//   const MemberProjectDetailsPage({Key? key, required this.tasks})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(tasks.taskName),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Task Name: ${tasks.taskName}'),
//             Text('Due Date: ${tasks.dueDate.toString()}'),
//             Text('Status: ${tasks.status}'),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle edit status
//               },
//               child: const Text('Edit Status'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project.dart';

class MemberProjectDetailsPage extends StatefulWidget {
  final Task tasks;

  const MemberProjectDetailsPage({Key? key, required this.tasks})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MemberProjectDetailsPageState createState() =>
      _MemberProjectDetailsPageState();
}

class _MemberProjectDetailsPageState extends State<MemberProjectDetailsPage> {
  late bool _isStatusYes;

  @override
  void initState() {
    super.initState();
    // ignore: unrelated_type_equality_checks
    _isStatusYes = widget.tasks.status == 'yes';
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
            Text('Status: ${_isStatusYes ? 'yes' : 'no'}'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Toggle the status when the button is pressed
                  _isStatusYes = !_isStatusYes;
                });
              },
              child: const Text('Edit Status'),
            ),
          ],
        ),
      ),
    );
  }
}
