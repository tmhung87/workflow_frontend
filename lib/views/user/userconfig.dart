import 'package:flutter/material.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';

class UserConfigPage extends StatefulWidget {
  const UserConfigPage({super.key});

  @override
  State<UserConfigPage> createState() => _UserConfigPageState();
}

class _UserConfigPageState extends State<UserConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: MyAppBar(label: 'User config'), body: SizedBox());
  }
}
