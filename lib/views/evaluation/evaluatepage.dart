import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/models/user.dart';
import 'package:workflow/providers/user_provider.dart';
import 'package:workflow/views/user/useraddpage.dart';
import 'package:workflow/views/user/userconfig.dart';
import 'package:workflow/views/user/userdetailpage.dart';
import 'package:workflow/views/user/userimportpage.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';
import 'package:workflow/widget/mycontainer.dart';
import 'package:workflow/widget/mymainlayout/mydrawer.dart';
import 'package:workflow/widget/mydropdownbutton.dart';
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
  final _userNameController = TextEditingController();
  final _staffIdController = TextEditingController();
  final _userDivisionController = TextEditingController();
  final _userDepartmentController = TextEditingController();
  List<User> _users = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            widget.isSelect == true ? null : MyAppBar(label: 'User manager'),
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
      title: 'User list',
      child: Consumer<UserProvider>(
        builder: (_, ref, child) {
          List<User> users = List.from(ref.users);
          var list =
              users.map((user) {
                return [
                  (users.indexOf(user) + 1).toString(),
                  user.staffId ?? '',
                  user.name ?? '',
                  user.email ?? '',
                  user.division ?? '',
                  user.department ?? '',
                ];
              }).toList();
          if (users.isEmpty) {
            return Center();
          }
          return MyTable(
            header: [
              'id',
              'staffid',
              'name',
              'email',
              'division',
              'department',
            ],
            data: list,

            onTap: (index) {
              widget.isSelect == true
                  ? Navigator.pop(context, users[index])
                  : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailPage(user: users[index]),
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
      MyButton(child: Text('Daily'), onPressed: () async {}),
      MyButton(child: Text('Monthly'), onPressed: () async {}),

      MyButton(
        child: Text('Import users'),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserImportPage()),
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
              title: 'Find Users',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 4),
                  MyTextField(
                    label: 'Staff id',
                    controller: _staffIdController,
                  ),
                  MyTextField(
                    label: 'User name',
                    controller: _userNameController,
                  ),
                  MyDropdownButton(
                    label: 'Division',
                    items: ['Division 1', 'Division 2', 'Division 3'],

                    controller: _userDivisionController,
                  ),
                  MyDropdownButton(
                    label: 'Department',
                    items: ['Department 1', 'Department 2', 'Department 3'],

                    controller: _userDepartmentController,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      onPressed: () async {
                        context.read<UserProvider>().findUsers(
                          staffId: _staffIdController.text,
                          name: _userNameController.text,
                          division: _userDivisionController.text,
                          department: _userDepartmentController.text,
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
