// import 'package:flutter/material.dart';
// import 'package:flutter_projects/data/model/project.dart';
// import 'package:flutter_projects/presentation/views/create_project.dart';
// import 'package:flutter_projects/presentation/widgets/home.dart';
// import 'package:flutter_projects/presentation/widgets/table_of_projects.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';

// class BottomNavBar extends StatefulWidget {
//   final List<Project> projects;
//   final void Function(Project) addProject;

//   const BottomNavBar({
//     Key? key,
//     required this.projects,
//     required this.addProject,
//   }) : super(key: key);

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int _selectedIndex = 0;
//   late final List<Widget> _pages;

//   @override
//   void initState() {
//     super.initState();
//     _pages = [
//       MyHomePage(
//         title: "Kumaran's Projects",
//       ),
//       ProjectsTable(
//           projects: widget.projects,
//           onProjectUpdate: (project) {},
//           onProjectDelete: (projectName) {}),
//       CreateProjectPage(
//           projects: widget.projects, addProject: widget.addProject),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: GNav(
//           backgroundColor: Colors.grey,
//           color: Colors.redAccent,
//           activeColor: Colors.white,
//           tabBackgroundColor: Colors.grey.shade800,
//           gap: 8,
//           padding: EdgeInsets.all(16),
//           selectedIndex: _selectedIndex,
//           onTabChange: (index) {
//             setState(() {
//               _selectedIndex = index; // Update the selected index
//             });
//           },
//           tabs: [
//             GButton(
//               icon: Icons.home,
//               text: 'Home',
//             ),
//             GButton(
//               icon: Icons.category,
//               text: 'Projects',
//             ),
//             GButton(
//               icon: Icons.add,
//               text: 'New',
//             ),
//             GButton(
//               icon: Icons.settings,
//               text: 'Settings',
//             ),
//           ]),
//     );
//   }
// }

