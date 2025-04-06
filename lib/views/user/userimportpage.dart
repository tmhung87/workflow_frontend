import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/models/user.dart';
import 'package:workflow/providers/user_provider.dart';
import 'package:workflow/utils/importexcel.dart';
import 'package:workflow/widget/mainlayout.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/myprogress.dart';
import 'package:workflow/widget/mytable.dart';

class UserImportPage extends StatefulWidget {
  const UserImportPage({super.key});

  @override
  State<UserImportPage> createState() => _UserImportPageState();
}

class _UserImportPageState extends State<UserImportPage> {
  List<List<String>> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MainLayout(
        actions: [
          MyButton(
            child: Text('Import'),
            onPressed: () async {
              list = await importExcel();
              list.removeAt(0);
              setState(() {});
            },
          ),
          MyButton(
            child: Text('Push'),
            onPressed: () async {
              List<User> users = [];
              for (var i = 0; i < list.length; i++) {
                users.add(
                  User(
                    staffId: list[i][0],
                    password: list[i][1],
                    name: list[i][2],
                    email: list[i][3],
                    division: list[i][4],
                    department: list[i][5],
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
                      items: users,
                      onPush: (item) async {
                        return context.read<UserProvider>().createUser(item);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
        child: MyTable(
          data: list,
          header: [
            'staffId',
            'password',
            'name',
            'email',
            'division',
            'department',
          ],
        ),
      ),
    );
  }
}
