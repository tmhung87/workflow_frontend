import 'package:flutter/material.dart';
import 'package:workflow/models/place.dart'; // Mô hình Place mới
import 'package:workflow/service/place_api.dart'; // Dịch vụ API
import 'package:workflow/views/place/placeaddpage.dart';
import 'package:workflow/views/place/placedetailpage.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/mymainlayout/myappbar.dart';
import 'package:workflow/widget/mycontainer.dart';
import 'package:workflow/widget/mymainlayout/mydrawer.dart';
import 'package:workflow/widget/mymainlayout/mainlayout.dart';
import 'package:workflow/widget/mytable.dart';
import 'package:workflow/widget/mytextfield.dart';

class PlaceManagerPage extends StatefulWidget {
  const PlaceManagerPage({super.key, this.isSelect = false});
  final bool isSelect;

  @override
  State<PlaceManagerPage> createState() => _PlaceManagerPageState();
}

class _PlaceManagerPageState extends State<PlaceManagerPage> {
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();
  List<Place> places = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // _loadPlaces(); // Tải dữ liệu địa điểm khi khởi tạo
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  // Phương thức tải dữ liệu địa điểm từ API
  // Future<void> _loadPlaces() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     places = await PlaceApiService.getPlaces(); // Gọi API để lấy danh sách địa điểm
  //   } catch (e) {
  //     print('Error loading places: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            widget.isSelect
                ? AppBar(title: Text('Select Place'))
                : MyAppBar(label: 'Place Manager'),
        drawer: widget.isSelect ? null : MyDrawer(),
        body: MainLayout(
          actions: widget.isSelect ? null : _actions,
          sideBar: _sideBar,
          child: _child,
        ),
      ),
    );
  }

  MyContainer get _child {
    if (isLoading) {
      return MyContainer(
        title: 'Loading places...',
        child: Center(
          child: CircularProgressIndicator(),
        ), // Hiển thị loading spinner khi đang tải
      );
    }

    if (places.isEmpty) {
      return MyContainer(
        title: 'Place List',
        child: Center(child: Text('No places found.')),
      );
    }

    var list =
        places.map((place) {
          return [
            (places.indexOf(place) + 1).toString(),
            place.division ?? '',
            place.department ?? '',
            place.position ?? '',
            place.createdBy ?? '',
            place.createdAt?.toIso8601String() ?? '',
          ];
        }).toList();
    print(list);
    return MyContainer(
      title: 'Place List',
      child: MyTable(
        header: [
          'Place ID',
          'Division',
          'Department',
          'Position',
          'Created By',
          'Created At',
        ],
        data: list,
        onTap: (index) {
          widget.isSelect
              ? Navigator.pop(context, places[index])
              : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaceDetailPage(place: places[index]),
                ),
              );
        },
        columnWidths: {0: 50},
        alignments: {0: Alignment.center},
      ),
    );
  }

  List<Widget> get _actions {
    return [
      MyButton(
        child: Text('Create Place'),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlaceAddPage()),
            ),
      ),
    ];
  }

  Widget get _sideBar {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyContainer(
              title: 'Find Places',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 4),
                  MyTextField(
                    label: 'Place Title',
                    controller: _titleController,
                  ),
                  MyTextField(
                    label: 'Place Description',
                    controller: _descriptionController,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          places = await PlaceApiService.findPlace(
                            division: _titleController.text,
                            department: _descriptionController.text,
                          );
                        } catch (e) {
                          print('Error searching places: $e');
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: Center(child: Text('Search')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
