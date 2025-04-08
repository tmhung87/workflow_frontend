import 'package:flutter/material.dart';
import 'package:workflow/models/user.dart';
import 'package:workflow/widget/mymainlayout/mainlayout.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/mydropdownbutton.dart';
import 'package:workflow/widget/mytextfield.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key, required this.user});
  final User user;
  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final _staffIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _divisionController = TextEditingController();
  final _deparmentController = TextEditingController();

  final _createAtController = TextEditingController();

  final _updateAtController = TextEditingController();

  void _initUser() {
    _staffIdController.text = widget.user.staffId;
    _nameController.text = widget.user.name;
    _divisionController.text = widget.user.division;
    _deparmentController.text = widget.user.department;
    _createAtController.text = widget.user.createdAt!;
    _updateAtController.text = widget.user.updatedAt!;
  }

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(label: 'Detail user'),
      body: MainLayout(
        actions: [MyButton(onPressed: () async {}, child: Text('Update'))],
        child: Center(
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextField(label: 'Staff Id', controller: _staffIdController),
                MyTextField(label: 'Name', controller: _nameController),

                MyDropdownButton(
                  label: 'Division',
                  items: [],
                  controller: _divisionController,
                ),
                MyDropdownButton(
                  label: 'Deparment',
                  items: [],
                  controller: _deparmentController,
                ),

                MyTextField(
                  enable: false,
                  label: 'Create add',
                  controller: _createAtController,
                ),
                MyTextField(
                  enable: false,
                  label: 'Update add',
                  controller: _updateAtController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
