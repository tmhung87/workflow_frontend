import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/models/task.dart';
import 'package:workflow/models/user.dart';
import 'package:workflow/providers/task_provider.dart';
import 'package:workflow/providers/user_provider.dart';
import 'package:workflow/utils/importexcel.dart';
import 'package:workflow/widget/mymainlayout/mainlayout.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/myprogress.dart';
import 'package:workflow/widget/mytable.dart';

class TaskImportPage extends StatefulWidget {
  const TaskImportPage({super.key});

  @override
  State<TaskImportPage> createState() => _TaskImportPageState();
}

class _TaskImportPageState extends State<TaskImportPage> {
  List<List<String>> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Import taks')),
      body: MainLayout(
        actions: [
          MyButton(
            child: Text('Import'),
            onPressed: () async {
              list = await importExcel();
              setState(() {});
            },
          ),
          MyButton(
            child: Text('Push'),
            onPressed: () async {
              List<Task> tasks = [];
              for (var i = 0; i < list.length; i++) {
                tasks.add(
                  Task(
                    taskId: i,
                    title: list[i][1],
                    description: list[i][2],
                    point: int.tryParse(list[i][3]) ?? 0,
                    estimatedHours: double.tryParse(list[i][4]) ?? 0,
                    type: list[i][5],
                  ),
                );
              }
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actions: [
                      MyButton(
                        child: Text('Close'),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                    title: Text('Push users to server'),
                    content: PushProgressWidget(
                      onFinish: () {},
                      items: tasks,
                      onPush: (item) async {
                        return context.read<TaskProvider>().createtask(item);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
        child: MyTable(
          columnWidths: {0: 50},
          data: list,
          header: [
            "taskId",
            "title",
            "description",
            "point",
            "taskTime",
            "type",
          ],
        ),
      ),
    );
  }
}
