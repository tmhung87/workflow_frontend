import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/providers/auth_provider.dart';
import 'package:workflow/service/place_api.dart';
import 'package:workflow/widget/mymainlayout/mainlayout.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';
import 'package:workflow/widget/mytextfield.dart';

import '../../models/place.dart';

class PlaceAddPage extends StatefulWidget {
  const PlaceAddPage({super.key});

  @override
  State<PlaceAddPage> createState() => _PlaceAddPageState();
}

class _PlaceAddPageState extends State<PlaceAddPage> {
  final _divisionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _positionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _divisionController.dispose();
    _departmentController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  Future<void> _createPlace() async {
    final place = Place(
      division: _divisionController.text.trim(),
      department: _departmentController.text.trim(),
      position: _positionController.text.trim(),
      createdBy: context.read<AuthProvider>().auth!.staffId,
    );

    try {
      final response = await PlaceApiService.createPlace(place: place);
      if (response['state'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Place created successfully")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create place: ${response['message']}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(label: 'Add New Place'),
      body: MainLayout(
        actions: [
          MyButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _createPlace();
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
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    MyTextField(
                      isValidator: true,
                      label: 'Division',
                      controller: _divisionController,
                    ),
                    MyTextField(
                      isValidator: true,
                      label: 'Department',
                      controller: _departmentController,
                    ),
                    MyTextField(
                      label: 'Position (optional)',
                      controller: _positionController,
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
