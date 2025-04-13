import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/models/task.dart';
import 'package:workflow/providers/task_provider.dart';
import 'package:workflow/views/task/taskaddpage.dart';
import 'package:workflow/views/task/taskdetailpage.dart';
import 'package:workflow/views/task/taskimportpage.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';
import 'package:workflow/widget/mycontainer.dart';
import 'package:workflow/widget/mymainlayout/mydrawer.dart';
import 'package:workflow/widget/mymainlayout/mainlayout.dart';
import 'package:workflow/widget/mytable.dart';
import 'package:workflow/widget/mytextfield.dart';

class TaskManagerPage extends StatefulWidget {
  const TaskManagerPage({super.key, this.isSelect = false});
  final bool isSelect;
  @override
  State<TaskManagerPage> createState() => _TaskManagerPageState();
}

class _TaskManagerPageState extends State<TaskManagerPage> {
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();

  late TaskProvider taskProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskProvider = context.read<TaskProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    taskProvider.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            widget.isSelect == true
                ? AppBar(title: Text('Select task'))
                : MyAppBar(label: 'Task manager'),
        drawer: widget.isSelect == true ? null : MyDrawer(),
        body: MainLayout(
          actions: widget.isSelect == true ? null : _actions,
          sideBar: _sideBar,
          child: _child,
        ),
      ),
    );
  }

  MyContainer get _child {
    return MyContainer(
      title: 'Task list',
      child: Consumer<TaskProvider>(
        builder: (_, ref, child) {
          List<Task> tasks = List.from(ref.tasks);
          var list =
              tasks.map((task) {
                return [
                  (tasks.indexOf(task) + 1).toString(),
                  task.title ?? '',
                  task.description ?? '',
                  task.point.toString() ?? '',
                  task.estimatedHours.toString() ?? '',
                  task.type.toString() ?? '',
                  task.status.toString() ?? '',
                ];
              }).toList();
          if (tasks.isEmpty) {
            return Center();
          }
          return MyTable(
            header: [
              'taskId',
              'title',
              'description',
              'point',
              'tasktime',
              'type',
              'status',
            ],
            data: list,

            onTap: (index) {
              widget.isSelect
                  ? Navigator.pop(context, tasks[index])
                  : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailPage(task: tasks[index]),
                    ),
                  );
            },
            columnWidths: {0: 50},
            alignments: {0: Alignment.center},
          );
        },
      ),
    );
  }

  List<Widget> get _actions {
    return [
      MyButton(
        child: Text('Create task'),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskAddPage()),
            ),
      ),

      MyButton(
        child: Text('Import tasks'),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskImportPage()),
            ),
      ),
    ];
  }

  Widget get _sideBar {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyContainer(
              title: 'Find tasks',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 4),
                  MyTextField(
                    label: 'Task title',
                    controller: _titleController,
                  ),
                  MyTextField(
                    label: 'Task description',
                    controller: _descriptionController,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      onPressed: () async {
                        context.read<TaskProvider>().findtasks(
                          description: _descriptionController.text,
                          title: _titleController.text,
                        );
                      },
                      child: Center(child: Text('Search')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
