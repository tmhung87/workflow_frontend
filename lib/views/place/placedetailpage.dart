import 'package:flutter/material.dart';
import 'package:workflow/models/place.dart';
import 'package:workflow/service/place_api.dart';
import 'package:workflow/widget/mymainlayout/mainlayout.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/mytextfield.dart';

class PlaceDetailPage extends StatefulWidget {
  const PlaceDetailPage({super.key, required this.place});
  final Place place;

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  final _divisionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _positionController = TextEditingController();

  void _initPlace() {
    _divisionController.text = widget.place.division;
    _departmentController.text = widget.place.department;
    _positionController.text = widget.place.position ?? '';
  }

  @override
  void initState() {
    super.initState();
    _initPlace();
  }

  @override
  void dispose() {
    _divisionController.dispose();
    _departmentController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(label: 'Place Detail'),
      body: MainLayout(
        actions: [
          MyButton(
            onPressed: () async {
              final updatedPlace = Place(
                id: widget.place.id,
                division: _divisionController.text.trim(),
                department: _departmentController.text.trim(),
                position: _positionController.text.trim(),
                createdBy: widget.place.createdBy,
                createdAt: widget.place.createdAt,
              );

              final result = await PlaceApiService.updatePlace(updatedPlace);
              print('Updated: $result');
            },
            child: Text('Update'),
          ),
          MyButton(
            onPressed: () async {
              final result = await PlaceApiService.deletePlace(
                widget.place.id!,
              );
              print('Deleted: $result');
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  MyTextField(
                    label: 'Division',
                    controller: _divisionController,
                    isValidator: true,
                  ),
                  MyTextField(
                    label: 'Department',
                    controller: _departmentController,
                    isValidator: true,
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
    );
  }
}
