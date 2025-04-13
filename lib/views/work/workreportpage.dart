import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workflow/models/work.dart';
import 'package:workflow/service/work_api.dart';
import 'package:workflow/views/work/workdetailpage.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/mycontainer.dart';
import 'package:workflow/widget/myloadingwidget.dart';
import 'package:workflow/widget/mymainlayout/mainlayout.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';
import 'package:workflow/widget/mymainlayout/mydrawer.dart';
import 'package:workflow/widget/mytable.dart';

class WorkReportPage extends StatefulWidget {
  const WorkReportPage({super.key, this.isSelect = false});
  final bool isSelect;
  @override
  State<WorkReportPage> createState() => _WorkReportPageState();
}

class _WorkReportPageState extends State<WorkReportPage> {
  final _workIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _assignedController = TextEditingController();
  final _statusController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  List<Work> works = [];
  List<List<String>> list = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MyLoadingWidget(
        child: Scaffold(
          appBar: MyAppBar(label: 'Work manager'),
          drawer: MyDrawer(),
          body: MainLayout(actions: _actions, sideBar: _sideBar, child: _child),
        ),
      ),
    );
  }

  MyContainer get _child {
    return MyContainer(
      title: 'Work list',
      child: MyTable(
        header: [
          'id',
          'work id',
          'title',
          'description',
          // 'point',
          // 'estimatedHours',
          'issued by',
          'assigned',
          'percent',
          'actualHours',
          'remark',
          'status',
        ],
        data: list,
        onTap: (index) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkDetailPage(work: works[index]),
            ),
          );
        },
        columnWidths: {0: 50},
        alignments: {0: Alignment.center, 1: Alignment.center},
      ),
    );
  }

  List<Widget> get _actions {
    return [];
  }

  Widget get _sideBar {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyButton(
              child: Text("Daily report"),
              onPressed: () async {
                works = await WorkApiService.findWork(
                  startTime: DateTime.now(),
                  endTime: DateFormat(
                    'dd/MM/yyyy',
                  ).tryParse(_endTimeController.text),
                );
                if (works != []) {
                  list =
                      works.map((work) {
                        return [
                          (works.indexOf(work) + 1).toString(),
                          work.workId.toString(),
                          work.task?.title ?? '',
                          work.task?.description ?? '',
                          // work.task?.point.toString() ?? '',
                          // work.task?.estimatedHours.toString() ?? '',
                          work.createdBy ?? '',
                          work.assigned ?? '',
                          work.percent?.toString() ?? '',
                          work.actualHours?.toString() ?? '',
                          work.remark ?? '',
                          work.status ?? '',
                        ];
                      }).toList();
                  setState(() {});
                }
              },
            ),
            MyButton(child: Text("Monthly report"), onPressed: () async {}),
            MyButton(
              child: Text("Total staffs report"),
              onPressed: () async {},
            ),
            MyButton(child: Text("Issuer report"), onPressed: () async {}),
            MyButton(
              child: Text("Staff detail report"),
              onPressed: () async {},
            ),
          ],
        ),
      ),
    );
  }
}
