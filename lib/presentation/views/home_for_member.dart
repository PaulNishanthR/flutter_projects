import 'package:flutter/material.dart';

class HomeForMember extends StatefulWidget {
  const HomeForMember({super.key});

  @override
  State<HomeForMember> createState() => _HomeForMemberState();
}

class _HomeForMemberState extends State<HomeForMember> {
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
