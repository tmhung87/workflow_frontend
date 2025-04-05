import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/models/user.dart';
import 'package:workflow/providers/user_provider.dart';
import 'package:workflow/views/user/userdetailpage.dart';
import 'package:workflow/widget/button2.dart';
import 'package:workflow/widget/mycontainer.dart';
import 'package:workflow/widget/dropdownbutton2.dart';
import 'package:workflow/widget/iconbutton2.dart';
import 'package:workflow/widget/mainlayout.dart';
import 'package:workflow/widget/mytable.dart';
import 'package:workflow/widget/textfield2.dart';

class UserManagerPage extends StatefulWidget {
  const UserManagerPage({super.key});

  @override
  State<UserManagerPage> createState() => _UserManagerPageState();
}

class _UserManagerPageState extends State<UserManagerPage> {
  final _userNameController = TextEditingController();
  final _userStaffIdController = TextEditingController();
  final _userDivisionController = TextEditingController();
  final _userDepartmentController = TextEditingController();
  final List<User> _users = [];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      actions: _actions,
      sideBar: _sideBar,
      child: UserDetailPage(),
    );
  }

  List<Widget> get _actions {
    return [
      IconButton2(
        tooltip: 'Add User',
        child: Icon(Icons.person_add_outlined),
        onPressed: () {
          showDialog(context: context, builder: (context) => AddUserDialog());
        },
      ),

      IconButton2(
        tooltip: 'Import Users',
        child: Icon(Icons.upload_file),
        onPressed: () {},
      ),

      IconButton2(
        tooltip: 'Place management',
        child: Stack(children: [Icon(Icons.home_work_outlined)]),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => PlaceManagementDialog(),
          );
        },
      ),
    ];
  }

  Widget get _sideBar {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyContainer(
            title: 'Find Users',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 4),
                TextField2(
                  labelText: 'User id',
                  controller: _userStaffIdController,
                ),
                TextField2(
                  labelText: 'User name',
                  controller: _userNameController,
                ),
                DropdownButton2(
                  label: 'Division',
                  items: ['Division 1', 'Division 2', 'Division 3'],
                  onChanged: (value) => _userDivisionController.text = value,
                  controller: _userDivisionController,
                  value: _userDivisionController.text,
                ),
                DropdownButton2(
                  label: 'Department',
                  items: ['Department 1', 'Department 2', 'Department 3'],
                  onChanged: (value) => _userDepartmentController.text = value,
                  controller: _userDepartmentController,
                  value: _userDepartmentController.text,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Button2(
                    onPressed: () async {
                      context.read<UserProvider>().findUsers(
                        staffId: _userStaffIdController.text,
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
          MyContainer(
            title: 'User list',
            child: Consumer<UserProvider>(
              builder: (_, ref, child) {
                List<User> users = ref.users;
                print('abc' + users.length.toString());
                return MyTable(
                  columnWidths: {0: 50},
                  length: users.length,
                  header: ['id', 'name', 'email', 'division', 'department'],
                  builder:
                      (index) => [
                        Text((index + 1).toString()),
                        Text(users[index].name ?? ''),
                        Text(users[index].email ?? ''),
                        Text(users[index].division ?? ''),
                        Text(users[index].department ?? ''),
                      ],
                  onClick: (index) {
                    context.read<UserProvider>().setSelectedUser(users[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceManagementDialog extends StatefulWidget {
  const PlaceManagementDialog({super.key});

  @override
  State<PlaceManagementDialog> createState() => _PlaceManagementDialogState();
}

class _PlaceManagementDialogState extends State<PlaceManagementDialog> {
  final _placeDivisionController = TextEditingController();
  final _placeDepartmentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Place management'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton2(
              label: 'Division',
              items: ['Division 1', 'Division 2', 'Division 3'],
              onChanged: (value) => _placeDivisionController.text = value,
              controller: _placeDivisionController,
              value: _placeDivisionController.text,
            ),
            DropdownButton2(
              label: 'Department',
              items: ['Department 1', 'Department 2', 'Department 3'],
              onChanged: (value) => _placeDepartmentController.text = value,
              controller: _placeDepartmentController,
              value: _placeDepartmentController.text,
            ),
          ],
        ),
      ),
    );
  }
}

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _userNameController = TextEditingController();
  final _userStaffIdController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userDivisionController = TextEditingController();
  final _userDepartmentController = TextEditingController();
  final _userPositionController = TextEditingController();
  final _userStatusController = TextEditingController();
  // @override
  // void dispose() {
  //   _userNameController.dispose();
  //   _userStaffIdController.dispose();
  //   _userEmailController.dispose();
  //   _userPasswordController.dispose();
  //   _userDivisionController.dispose();
  //   _userDepartmentController.dispose();
  //   _userPositionController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add User'),
      content: Container(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField2(
                      labelText: 'User id',
                      controller: _userStaffIdController,
                    ),
                    TextField2(
                      labelText: 'User name',
                      controller: _userNameController,
                    ),
                    TextField2(
                      labelText: 'User email',
                      controller: _userEmailController,
                    ),
                    TextField2(
                      labelText: 'User password',
                      controller: _userPasswordController,
                    ),
                    DropdownButton2(
                      label: 'User division',
                      items: ['Division 1', 'Division 2', 'Division 3'],
                      onChanged:
                          (value) => _userDivisionController.text = value,
                      controller: _userDivisionController,
                      value: _userDivisionController.text,
                    ),
                    DropdownButton2(
                      label: 'User department',
                      items: ['Department 1', 'Department 2', 'Department 3'],
                      onChanged:
                          (value) => _userDepartmentController.text = value,
                      controller: _userDepartmentController,
                      value: _userDepartmentController.text,
                    ),
                    DropdownButton2(
                      label: 'User position',
                      items: ['Position 1', 'Position 2', 'Position 3'],
                      onChanged:
                          (value) => _userPositionController.text = value,
                      controller: _userPositionController,
                      value: _userPositionController.text,
                    ),
                    DropdownButton2(
                      label: 'User status',
                      items: ['Status 1', 'Status 2', 'Status 3'],
                      onChanged: (value) => _userStatusController.text = value,
                      controller: _userStatusController,
                      value: _userStatusController.text,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Button2(
                    onPressed: () async {
                      context.read<UserProvider>().addUser(
                        _userStaffIdController.text,
                        _userNameController.text,
                        _userEmailController.text,
                        _userPasswordController.text,
                        _userDivisionController.text,
                        _userDepartmentController.text,
                        _userPositionController.text,
                        _userStatusController.text,
                      );
                    },
                    child: Text('Add'),
                  ),
                  SizedBox(width: 10),
                  Button2(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
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
