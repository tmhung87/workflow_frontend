import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workflow/views/home/dashboard.dart';
import 'package:workflow/views/task/taskmanagerpage.dart';
import 'package:workflow/views/user/usermanagerpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _currentWidget = Dashboard();

  String name = '';
  String email = '';
  void getUser() async {
    final staffId = await FlutterSecureStorage().read(key: 'staffId');
    setState(() {
      name = staffId ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workflow'),
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8),
                  Text('${name}'),
                ],
              ),
            ),
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    child: Text('Profile'),
                    onTap: () => setState(() => _currentWidget = Dashboard()),
                  ),
                  PopupMenuItem(
                    child: Text('Settings'),
                    onTap: () => setState(() => _currentWidget = Dashboard()),
                  ),
                  PopupMenuItem(
                    child: Text('Logout'),
                    onTap: () => setState(() => _currentWidget = Dashboard()),
                  ),
                ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
              accountName: Text(name),
              accountEmail: Text(email),
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: () {
                setState(() => _currentWidget = Dashboard());
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('User Manager'),
              onTap: () {
                setState(() => _currentWidget = UserManagerPage());
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Task Manager'),
              onTap: () {
                setState(() => _currentWidget = TaskManagerPage());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _currentWidget,
    );
  }
}
