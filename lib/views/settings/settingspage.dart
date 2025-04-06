import 'package:flutter/material.dart';
import 'package:workflow/widget/myappbar.dart';
import 'package:workflow/widget/mydrawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(label: 'Settings'),
      drawer: MyDrawer(),
      body: Center(),
    );
  }
}
