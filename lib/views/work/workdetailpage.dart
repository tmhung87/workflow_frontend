import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workflow/models/hour.dart';
import 'package:workflow/models/user.dart';
import 'package:workflow/models/work.dart';
import 'package:workflow/providers/auth_provider.dart';
import 'package:workflow/service/hour_api.dart';
import 'package:workflow/service/work_api.dart';
import 'package:workflow/utils/tomysqldate.dart';
import 'package:workflow/views/user/usermanagerpage.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/mycontainer.dart';
import 'package:workflow/widget/mydropdown.dart';
import 'package:workflow/widget/myloadingwidget.dart';
import 'package:workflow/widget/mymainlayout/mainlayout.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';
import 'package:workflow/widget/mytable.dart';
import 'package:workflow/widget/mytextfield.dart';
import 'package:workflow/widget/showdialog.dart';

class WorkDetailPage extends StatefulWidget {
  const WorkDetailPage({super.key, this.work});
  final Work? work;

  @override
  State<WorkDetailPage> createState() => _WorkDetailPageState();
}

class _WorkDetailPageState extends State<WorkDetailPage> {
  final _titleController = TextEditingController();
  final _percentController = TextEditingController();
  final _actualHoursController = TextEditingController();
  final _remarkController = TextEditingController();
  final _statusController = TextEditingController();
  final _workIdController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointController = TextEditingController();
  final _estHoursController = TextEditingController();
  final _assignedController = TextEditingController();
  final _workHoursController = TextEditingController();
  final _workTimeController = TextEditingController();
  final _staffIdController = TextEditingController();

  late Work _work;

  List<List<String>> _list = [];
  void _createHours() async {
    var response = await HourApiService.create(
      Hour(
        workId: int.parse(_workIdController.text),
        staffId: _staffIdController.text,
        createdBy: context.read<AuthProvider>().auth!.staffId,
        createdAt: DateFormat('dd/MM/yyyy').parse(_workTimeController.text),
        workHours: double.parse(_workHoursController.text),
      ),
    );
    if (response['state'] == false) {
    } else {
      var map = response['workHours'] as List<dynamic>;
      _list =
          map.map((e) {
            e = e as Map<String, dynamic>;
            return [
              '${e['id']}',
              '${e['staffId']}',
              '${e['workHours']}',
              '${e['createdAt']}',
            ];
          }).toList();
      double totalHours = _list.fold(0.0, (sum, item) {
        double hours = double.tryParse(item[2]) ?? 0.0;
        return sum + hours;
      });
      _actualHoursController.text = totalHours.toString();
      _percentController.text =
          (totalHours * 100 / (_work.task.estimatedHours)).toString();
      setState(() {});
    }
  }

  void _initHours() async {
    var response = await HourApiService.getByWorkId(_work.workId!);
    print(response);
    if (response['state'] == false) {
    } else {
      var map = response['workHours'] as List<dynamic>;
      _list =
          map.map((e) {
            e = e as Map<String, dynamic>;
            return [
              '${e['id']}',
              '${e['staffId']}',
              '${e['workHours']}',
              '${e['createdAt']}',
            ];
          }).toList();
      double totalHours = _list.fold(0.0, (sum, item) {
        double hours = double.tryParse(item[2]) ?? 0.0;
        return sum + hours;
      });
      _actualHoursController.text = totalHours.toString();
      _percentController.text =
          (totalHours * 100 / (_work.task.estimatedHours)).toString();
      setState(() {});
    }
  }

  void _initWork() {
    if (widget.work != null) {
      _work = widget.work!;
      _workIdController.text = _work.workId.toString();
      _titleController.text = _work.task.title;
      _percentController.text = _work.percent.toString();
      _actualHoursController.text = _work.actualHours.toString();
      _remarkController.text = _work.remark;
      _statusController.text = _work.status;
      _descriptionController.text = _work.task.description;
      _pointController.text = _work.task.point.toString();
      _estHoursController.text = _work.task.estimatedHours.toString();
      _assignedController.text = _work.assigned;
      _initHours();
    }
  }

  @override
  void initState() {
    super.initState();
    _initWork();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _percentController.dispose();
    _actualHoursController.dispose();
    _remarkController.dispose();
    _statusController.dispose();
    _descriptionController.dispose();
    _pointController.dispose();
    _estHoursController.dispose();
    _assignedController.dispose();
    _workIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyLoadingWidget(
      child: Scaffold(
        appBar: MyAppBar(label: 'Detail Work'),
        body: MainLayout(
          actions: [
            SizedBox(
              width: 200,
              child: MyTextField(
                controller: _workIdController,
                prefixIcon: const Text('WORK ID: '),
                suffixIcon: InkWell(
                  onTap: () async {
                    final work = await WorkApiService.findWorkById(
                      _workIdController.text.trim(),
                    );
                    if (work != null) {
                      setState(() {
                        _work = work;
                        _initWork();
                      });
                    }
                  },
                  child: const Icon(Icons.search),
                ),
              ),
            ),
          ],
          sideBar: ListView(
            children: [
              MyButton(
                ask: true,

                onPressed: () async {
                  final updatedTask = _work.task.copyWith(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    point: int.tryParse(_pointController.text) ?? 0,
                    estimatedHours:
                        double.tryParse(_estHoursController.text) ?? 0.0,
                  );

                  final updatedWork = Work(
                    workId: _work.workId,
                    task: updatedTask,
                    status: _statusController.text,
                    assigned: _assignedController.text,
                    percent: double.tryParse(_percentController.text) ?? 0,
                    actualHours: double.tryParse(_actualHoursController.text),
                    remark: _remarkController.text,
                    createdBy: _work.createdBy,
                    createdAt: _work.createdAt,
                    doneBy: _work.doneBy,
                    doneAt: _work.doneAt,
                  );

                  final response = await WorkApiService.updateWork(updatedWork);
                  if (response['state'] == false) {
                    showMyDialog(
                      isSuccess: false,
                      context: context,
                      title: 'Error',
                      content: response['error'],
                    );
                  } else {
                    showMyDialog(
                      context: context,
                      title: 'Success',
                      content: response['message'],
                    );
                  }
                },
                child: const Text('Update'),
              ),
              MyButton(
                ask: true,
                onPressed: () async {
                  final response = await WorkApiService.deleteWork(
                    _work.workId!,
                  );
                  if (response['state'] == false) {
                    showMyDialog(
                      isSuccess: false,
                      context: context,
                      title: 'Error',
                      content: response['error'],
                    );
                  } else {
                    showMyDialog(
                      context: context,
                      title: 'Success',
                      content: response['message'],
                    );
                  }
                },
                child: const Text('Delete'),
              ),
              MyButton(
                child: Container(child: Text('Record hours')),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Input work hour"),
                        content: SizedBox(
                          width: 500,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              MyTextField(
                                hintText:
                                    context.read<AuthProvider>().auth!.staffId,
                                isValidator: false,
                                label: 'Staff id',
                                controller: _staffIdController,
                                suffixIcon: InkWell(
                                  child: Icon(Icons.select_all),
                                  onDoubleTap: () {
                                    _titleController.clear();
                                  },
                                  onTap: () async {
                                    User? user = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                UserManagerPage(isSelect: true),
                                      ),
                                    );
                                    if (user != null) {
                                      _staffIdController.text = user.staffId;
                                    }
                                  },
                                ),
                              ),
                              MyTextField(
                                keyboardType: TextInputType.number,
                                label: "Work hours",
                                controller: _workHoursController,
                              ),
                              MyTextField(
                                label: "Work time",
                                controller: _workTimeController,
                                isDate: true,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          MyButton(
                            child: Text('YES'),
                            onPressed: () async {
                              _createHours();
                              Navigator.pop(context);
                            },
                          ),
                          MyButton(
                            child: Text('NO'),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 500,
                child: Column(
                  children: [
                    MyContainer(
                      title:
                          'Work was created by ${_work.createdBy} at ${toMySQLDate(_work.createdAt)}',
                      child: Column(
                        children: [
                          MyDropdown(
                            label: 'Status',
                            controller: _statusController,
                            items: const [
                              'issued',
                              'pending',
                              'inprogress',
                              'done',
                              'cancelled',
                            ],
                          ),
                          MyTextField(
                            label: 'Title',
                            controller: _titleController,
                            enable: false,
                          ),
                          MyTextField(
                            label: 'Description',
                            controller: _descriptionController,
                          ),
                          MyTextField(
                            label: 'Point',
                            controller: _pointController,
                          ),
                          MyTextField(
                            label: 'Estimate hours',
                            controller: _estHoursController,
                          ),
                          MyTextField(
                            label: 'Assigned',
                            controller: _assignedController,
                            suffixIcon: InkWell(
                              child: const Icon(Icons.select_all),
                              onDoubleTap: () => _assignedController.clear(),
                              onTap: () async {
                                User? user = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const UserManagerPage(
                                          isSelect: true,
                                        ),
                                  ),
                                );
                                if (user != null) {
                                  _assignedController.text = user.staffId;
                                }
                              },
                            ),
                          ),

                          MyTextField(
                            label: 'Percent (%)',
                            controller: _percentController,
                            keyboardType: TextInputType.number,
                          ),
                          MyTextField(
                            label: 'Actual Hours',
                            controller: _actualHoursController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                          MyTextField(
                            label: 'Remark',
                            controller: _remarkController,
                          ),
                        ],
                      ),
                    ),
                    MyContainer(
                      title: 'Work hours',
                      actions: [],
                      child: MyTable(
                        header: ['id', 'staff id', 'hours', 'time'],
                        data: _list,
                      ),
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
