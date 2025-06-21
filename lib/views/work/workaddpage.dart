import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/models/task.dart';
import 'package:workflow/models/user.dart';
import 'package:workflow/models/work.dart';
import 'package:workflow/providers/auth_provider.dart';
import 'package:workflow/service/work_api.dart';
import 'package:workflow/views/task/taskmanagerpage.dart';
import 'package:workflow/views/user/usermanagerpage.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/myloadingwidget.dart';
import 'package:workflow/widget/mymainlayout/mainlayout.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';
import 'package:workflow/widget/mytextfield.dart';
import 'package:workflow/widget/showdialog.dart';

class WorkAddPage extends StatefulWidget {
  const WorkAddPage({super.key});

  @override
  State<WorkAddPage> createState() => _WorkAddPageState();
}

class _WorkAddPageState extends State<WorkAddPage> {
  final _workIdController = TextEditingController();
  final _taskIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointController = TextEditingController();
  final _estimatedHoursController = TextEditingController();
  final _infoController = TextEditingController();
  final _statusController = TextEditingController();
  final _assignedController = TextEditingController();
  final _percentController = TextEditingController();
  final _workHourController = TextEditingController();
  final _remarkController = TextEditingController();
  final _createByController = TextEditingController();
  final _createdAtController = TextEditingController();
  final _doneByController = TextEditingController();
  final _doneAtController = TextEditingController();
  late Task? _task;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _workIdController.dispose();
    _taskIdController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _pointController.dispose();
    _infoController.dispose();
    _statusController.dispose();
    _assignedController.dispose();
    _percentController.dispose();
    _workHourController.dispose();
    _remarkController.dispose();
    _createByController.dispose();
    _createdAtController.dispose();
    _doneByController.dispose();
    _doneAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MyLoadingWidget(
        child: Scaffold(
          appBar: MyAppBar(label: 'Add a new work'),
          body: MainLayout(
            actions: [
              MyButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final work = Work(
                      task: _task,
                      status: _statusController.text,
                      assigned: _assignedController.text,
                      percent: double.tryParse(_percentController.text),
                      actualHours: double.tryParse(_workHourController.text),
                      remark: _remarkController.text,
                      createdBy: context.read<AuthProvider>().auth!.staffId,
                    );
                   
                    final response = await WorkApiService.createWork(work);
                    print(response);
                    if (response['state'] == false) {
                      showMyDialog(
                        isSuccess: false,
                        context: context,
                        title: 'Error',
                        content: response['error'],
                      );
                    } else {
                      setState(() {
                        _workIdController.text = '${response['workId']}';
                      });
                      showMyDialog(
                        context: context,
                        title: 'Success',
                        content:
                            '${response['message']}. Id: ${response['workId']}',
                      );
                    }
                  }
                },
                child: Text('Add'),
              ),
            ],
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: 500,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 30),
                        MyTextField(
                          enable: false,
                          isValidator: false,
                          label: 'Id',
                          controller: _workIdController,
                        ),
                        MyTextField(
                          isValidator: true,
                          label: 'title',
                          controller: _titleController,
                          suffixIcon: InkWell(
                            child: Icon(Icons.select_all),
                            onDoubleTap: () {
                              _titleController.clear();
                            },
                            onTap: () async {
                              _task = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          TaskManagerPage(isSelect: true),
                                ),
                              );
                              print(_task!.toJson());
                              if (_task != null) {
                                print(_task);
                                _titleController.text = _task!.title;
                                _descriptionController.text =
                                    _task!.description;
                                _pointController.text = _task!.point.toString();
                                _estimatedHoursController.text =
                                    _task!.estimatedHours.toString();
                                setState(() {});
                              }
                            },
                          ),
                        ),
                        MyTextField(
                          isValidator: true,
                          label: 'description',
                          controller: _descriptionController,
                        ),
                        MyTextField(
                          keyboardType: TextInputType.number,
                          isValidator: false,
                          label: 'point',
                          controller: _pointController,
                        ),
                        MyTextField(
                          keyboardType: TextInputType.number,
                          isValidator: false,
                          label: 'Estimated Hours',
                          controller: _estimatedHoursController,
                        ),
                        MyTextField(
                          isValidator: false,
                          label: 'assigned',
                          controller: _assignedController,
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
                                _assignedController.text = user.staffId;
                              }
                            },
                          ),
                        ),
                        MyTextField(
                          label: 'Remark',
                          controller: _remarkController,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
