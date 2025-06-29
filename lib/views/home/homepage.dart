import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';
import 'package:workflow/widget/mymainlayout/mydrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = '';
  String email = '';
  void getUser() async {
    final staffId = (await SharedPreferences.getInstance()).getString( 'staffId');
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
      appBar: MyAppBar(label: 'Home'),
      drawer: MyDrawer(),
      body: Center(),
    );
  }
}
