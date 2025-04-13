import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/providers/task_provider.dart';
import 'package:workflow/widget/mymainlayout/mainlayout.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/mydropdownbutton.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';
import 'package:workflow/widget/mytextfield.dart';

import '../../models/task.dart';

class TaskAddPage extends StatefulWidget {
  const TaskAddPage({super.key});

  @override
  State<TaskAddPage> createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _typeController = TextEditingController();
  final _pointController = TextEditingController();
  final _estimatedHoursController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _typeController.dispose();
    _pointController.dispose();
    _estimatedHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(label: 'Add a new user'),
      body: MainLayout(
        actions: [
          MyButton(
            onPressed: () async {
              if (_formkey.currentState!.validate()) {
                return context.read<TaskProvider>().createtask(
                  Task(
                    description: _descriptionController.text,
                    title: _titleController.text,
                    estimatedHours:
                        double.tryParse(_estimatedHoursController.text) ?? 0,
                    type: _typeController.text,
                    point: int.tryParse(_pointController.text) ?? 0,
                  ),
                );
              }
            },
            child: Text('Create'),
          ),
        ],
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 500,
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    MyTextField(
                      isValidator: true,
                      label: 'Task title',
                      controller: _titleController,
                    ),
                    MyTextField(
                      isValidator: true,
                      label: 'Task decription',
                      controller: _descriptionController,
                    ),

                    MyTextField(label: 'Point', controller: _pointController),
                    MyTextField(
                      label: 'Estimated Hours',
                      controller: _estimatedHoursController,
                    ),
                    MyDropdownButton(
                      label: 'Task type',
                      controller: _typeController,
                      items: ['routine', 'irreguler'],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
