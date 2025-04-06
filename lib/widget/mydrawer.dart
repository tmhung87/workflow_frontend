import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/providers/auth_provider.dart';
import 'package:workflow/styles/strings.dart';
import 'package:workflow/views/home/homepage.dart';
import 'package:workflow/views/settings/settingspage.dart';
import 'package:workflow/views/task/taskmanagerpage.dart';
import 'package:workflow/views/user/usermanagerpage.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Consumer<AuthProvider>(
            builder:
                (context, value, child) => UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person),
                  ),
                  accountName: Text(value.auth!.staffId!),
                  accountEmail: Text(value.auth!.name!),
                ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            title: Text('User Manager'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserManagerPage()),
              );
            },
          ),
          ListTile(
            title: Text('Task Manager'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TaskManagerPage()),
              );
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
