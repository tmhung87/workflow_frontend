import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/models/task.dart';
import 'package:workflow/providers/task_provider.dart';
import 'package:workflow/widget/mymainlayout/mainlayout.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/mydropdown.dart';
import 'package:workflow/widget/mytextfield.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({super.key, required this.task});
  final Task task;
  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointController = TextEditingController();
  final _tasktimeController = TextEditingController();
  final _typeController = TextEditingController();
  final _statusController = TextEditingController();

  void _inittask() {
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
    _pointController.text = widget.task.point.toString();
    _tasktimeController.text = widget.task.estimatedHours.toString();
    _typeController.text = widget.task.type;
    _statusController.text = widget.task.status;
  }

  @override
  void initState() {
    super.initState();
    _inittask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(label: 'Detail task'),
      body: MainLayout(
        actions: [
          MyButton(
            onPressed: () async {
              print(_pointController.text);
              await context.read<TaskProvider>().updateTask(
                Task(
                  taskId: widget.task.taskId,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  estimatedHours:
                      double.tryParse(_tasktimeController.text) ?? 0,
                  point: int.tryParse(_pointController.text) ?? 0,
                  status: _statusController.text,
                  type: _typeController.text,
                ),
              );
            },
            child: Text('Update'),
          ),
          MyButton(
            onPressed: () async {
              return await context.read<TaskProvider>().deleteTask(
                widget.task.taskId!,
              );
            },
            child: Text('Delete'),
          ),
        ],
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  MyTextField(label: 'Title', controller: _titleController),
                  MyTextField(
                    label: 'Description',
                    controller: _descriptionController,
                  ),

                  MyTextField(label: 'Point', controller: _pointController),
                  MyTextField(
                    label: 'TaskTime',
                    controller: _tasktimeController,
                  ),
                  MyDropdown(
                    label: 'Type',
                    controller: _typeController,
                    items: ['routine', 'irregular'],
                  ),
                  MyDropdown(
                    label: 'Status',
                    controller: _statusController,
                    items: ['active', 'inactive'],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
