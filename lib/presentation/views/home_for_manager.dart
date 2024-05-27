import 'package:flutter/material.dart';

class HomeForManager extends StatefulWidget {
  const HomeForManager({super.key});

  @override
  State<HomeForManager> createState() => _HomeForManagerState();
}

class _HomeForManagerState extends State<HomeForManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KS ProjectHub"),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
