import 'package:flutter/material.dart';
import 'package:workflow/service/evaluate_api.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';
import 'package:workflow/widget/mycontainer.dart';
import 'package:workflow/widget/mymainlayout/mydrawer.dart';
import 'package:workflow/widget/mydropdown.dart';
import 'package:workflow/widget/mymainlayout/mainlayout.dart';
import 'package:workflow/widget/mytable.dart';
import 'package:workflow/widget/mytextfield.dart';

class EvaluatePage extends StatefulWidget {
  const EvaluatePage({super.key, this.isSelect = false});
  final bool isSelect;
  @override
  State<EvaluatePage> createState() => _EvaluatePageState();
}

class _EvaluatePageState extends State<EvaluatePage> {
  final _nameController = TextEditingController();
  final _staffIdController = TextEditingController();
  final _divisionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  List<Map<String, dynamic>> list = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            widget.isSelect == true
                ? null
                : MyAppBar(label: 'Evaluate manager'),
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
    List<String> header = [];
    List<List<String>> data = [];
    if (list.isNotEmpty) {
      header = ["Id", ...list[0].keys];
      data =
          list
              .map(
                (e) => [
                  (list.indexOf(e) + 1).toString(),
                  ...e.values
                      .toList()
                      .map((f) => (f ?? '').toString())
                      ,
                ],
              )
              .toList();
    }

    return MyContainer(
      title: 'Evaluate list',
      child:
          list.isNotEmpty
              ? MyTable(
                header: header,
                data: data,

                onTap: (index) async {
                  final res = await EvaluateApiService.getEvaluateStaff(
                    staffId: data[index][1],
                  );
                  list = List.from(res);
                  setState(() {});
                },
                columnWidths: {0: 50, 1: 120},
                alignments: {0: Alignment.center},
              )
              : Center(child: Text('No data')),
    );
  }

  List<Widget> get _actions {
    return [
      // MyButton(
      //   child: Text('Staff'),
      //   onPressed: () async {
      //     final res = await EvaluateApiService.fetchReport(type: 'daily');
      //     list = List.from(res);
      //     setState(() {});
      //   },
      // ),
    ];
  }

  Widget get _sideBar {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyContainer(
              title: 'Find Users',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 4),
                  MyTextField(
                    label: 'Staff id',
                    controller: _staffIdController,
                  ),
                  MyTextField(label: 'User name', controller: _nameController),
                  MyDropdown(
                    label: 'Division',
                    items: ['Division 1', 'Division 2', 'Division 3'],

                    controller: _divisionController,
                  ),
                  MyDropdown(
                    label: 'Department',
                    items: ['Department 1', 'Department 2', 'Department 3'],

                    controller: _departmentController,
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
                      onPressed: () async {},
                      child: const Center(child: Text('Search')),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      child: Center(child: Text('Daily')),
                      onPressed: () async {
                        final res = await EvaluateApiService.getEvaluateDaily(
                          staffId: _staffIdController.text,
                          name: _nameController.text,
                          division: _divisionController.text,
                          department: _departmentController.text,
                        );
                        list = List.from(res);
                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      child: Center(child: Text('Monthly')),
                      onPressed: () async {
                        final res = await EvaluateApiService.getEvaluateMonthly(
                          staffId: _staffIdController.text,
                          name: _nameController.text,
                          division: _divisionController.text,
                          department: _departmentController.text,
                        );
                        list = List.from(res);
                        setState(() {});
                      },
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
