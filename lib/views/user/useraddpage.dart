import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/models/user.dart';
import 'package:workflow/providers/user_provider.dart';
import 'package:workflow/widget/mainlayout.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/mydropdownbutton.dart';
import 'package:workflow/widget/myappbar.dart';
import 'package:workflow/widget/mytextfield.dart';

class UserAddPage extends StatefulWidget {
  const UserAddPage({super.key});

  @override
  State<UserAddPage> createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> {
  final _nameController = TextEditingController();
  final _staffIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _divisionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _userPositionController = TextEditingController();
  final _roleController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _staffIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _divisionController.dispose();
    _departmentController.dispose();
    _userPositionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(label: 'Add a new user'),
      body: MainLayout(
        actions: [
          MyButton(
            onPressed: () async {
              if (_formkey.currentState!.validate()) {
                return context.read<UserProvider>().createUser(
                  User(
                    staffId: _staffIdController.text,
                    name: _nameController.text,
                    division: _divisionController.text,
                    department: _departmentController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                );
              }
            },
            child: Text('Create'),
          ),
        ],
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 500,
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    MyTextField(
                      isValidator: true,
                      label: 'Staff id',
                      controller: _staffIdController,
                    ),
                    MyTextField(
                      isValidator: true,
                      label: 'Name',
                      controller: _nameController,
                    ),
                    MyTextField(label: 'Email', controller: _emailController),
                    MyTextField(
                      label: 'Password',
                      controller: _passwordController,
                    ),
                    MyDropdownButton(
                      label: 'Division',
                      items: ['Division 1', 'Division 2', 'Division 3'],

                      controller: _divisionController,
                    ),
                    MyDropdownButton(
                      label: 'Department',
                      items: ['Department 1', 'Department 2', 'Department 3'],

                      controller: _departmentController,
                    ),
                    MyDropdownButton(
                      label: 'Role',
                      items: ['Role 1', 'Role 2', 'Role 3'],

                      controller: _roleController,
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
