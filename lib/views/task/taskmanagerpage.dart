import 'package:flutter/material.dart';
import 'package:workflow/widget/mydrawer.dart';

class TaskManagerPage extends StatefulWidget {
  const TaskManagerPage({super.key});

  @override
  State<TaskManagerPage> createState() => _TaskManagerPageState();
}

class _TaskManagerPageState extends State<TaskManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), drawer: MyDrawer());
  }
}
