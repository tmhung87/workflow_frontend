import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workflow/models/work.dart';
import 'package:workflow/service/work_api.dart';
import 'package:workflow/views/work/workaddpage.dart';
import 'package:workflow/views/work/workdetailpage.dart';
import 'package:workflow/views/work/workreportpage.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/mycontainer.dart';
import 'package:workflow/widget/mydropdown.dart';
import 'package:workflow/widget/myloadingwidget.dart';
import 'package:workflow/widget/mymainlayout/mainlayout.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';
import 'package:workflow/widget/mymainlayout/mydrawer.dart';
import 'package:workflow/widget/mytable.dart';
import 'package:workflow/widget/mytextfield.dart';

class WorkManagerPage extends StatefulWidget {
  const WorkManagerPage({super.key, this.isSelect = false});
  final bool isSelect;
  @override
  State<WorkManagerPage> createState() => _WorkManagerPageState();
}

class _WorkManagerPageState extends State<WorkManagerPage> {
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
    return [
      MyButton(
        child: const Text('Add work'),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkAddPage()),
          );
        },
      ),
      MyButton(
        child: const Text('Report'),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkReportPage()),
          );
        },
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
              title: 'Find Works',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  MyTextField(label: 'Work id', controller: _workIdController),
                  MyTextField(label: 'Title', controller: _titleController),
                  MyTextField(
                    label: 'Description',
                    controller: _descriptionController,
                  ),
                  MyTextField(
                    label: 'Assigned',
                    controller: _assignedController,
                  ),
                  MyDropdown(
                    label: 'Status',
                    controller: _statusController,
                    items: [
                      'issued',
                      'inprogress',
                      'pending',
                      'done',
                      'cancelled',
                    ],
                  ),
                  MyTextField(
                    label: 'Start time',
                    controller: _startTimeController,
                    isDate: true,
                  ),
                  MyTextField(
                    isDate: true,
                    label: 'End time',
                    controller: _endTimeController,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      onPressed: () async {
                        works = await WorkApiService.findWork(
                          workId: _workIdController.text,
                          title: _titleController.text,
                          description: _descriptionController.text,
                          assigned: _assignedController.text,
                          status: _statusController.text,
                          startTime: DateFormat(
                            'dd/MM/yyyy',
                          ).tryParse(_startTimeController.text),
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
                                  work.task.title ?? '',
                                  work.task.description ?? '',
                                  // work.task?.point.toString() ?? '',
                                  // work.task?.estimatedHours.toString() ?? '',
                                  work.createdBy ?? '',
                                  work.assigned ?? '',
                                  work.percent.toString() ?? '',
                                  work.actualHours.toString() ?? '',
                                  work.remark ?? '',
                                  work.status ?? '',
                                ];
                              }).toList();
                          setState(() {});
                        }
                      },
                      child: const Center(child: Text('Search')),
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
