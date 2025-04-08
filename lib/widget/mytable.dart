import 'package:flutter/material.dart';
import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workflow/widget/myiconbutton.dart';

class MyTable extends StatefulWidget {
  const MyTable({
    super.key,
    required this.header,
    this.columnWidths = const {},
    required this.data,
    this.onTap,
    this.alignments = const {},
    this.splitindex = 30,
  });
  final List<List<String>> data;
  final List<String> header;
  final Map<int, double> columnWidths;
  final Function(int index)? onTap;
  final Map<int, AlignmentGeometry> alignments;
  final int splitindex;
  @override
  State<MyTable> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {
  int _columnIndex = 0;
  double _totalWidth = 0;
  Map<int, double> _columnWidths = {};
  List<List<String>> _data = [];
  bool _isSort = true;
  String _query = '';
  int _selectFilterIndex = 0;
  Map<int, double> _dx = {};
  final _scrollControler = ScrollController();
  int _count = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i = 0; i < widget.header.length; i++) {
      _dx[i] = 0;
      _columnWidths[i] = 100;
    }
    _count = widget.splitindex;

    _scrollControler.addListener(() => _onScroll());
  }

  void _onScroll() {
    final position = _scrollControler.position;
    if (position.pixels == position.maxScrollExtent) {
      if (_count < widget.data.length) {
        _count = _count + widget.splitindex;
        _scrollControler.jumpTo(1);
        setState(() {});
      }
    } else if (position.pixels == 0) {
      if (_count > widget.splitindex) {
        _count = _count - widget.splitindex;
        _scrollControler.jumpTo(position.maxScrollExtent - 1);
        setState(() {});
      }
    }
  }

  void _initTableWidth() {
    _totalWidth = 0;

    for (var i = 0; i < widget.header.length; i++) {
      _columnWidths[i] = (widget.columnWidths[i] ?? 100.0) + (_dx[i] ?? 0);
      _totalWidth = _totalWidth + _columnWidths[i]!;
    }
  }

  void _sort() {
    if (widget.data.isEmpty) return;

    int compare(dynamic a, dynamic b) {
      if (a == null || b == null) return 0;

      num? numA = num.tryParse(a.toString());
      num? numB = num.tryParse(b.toString());

      if (numA != null && numB != null) {
        return numA.compareTo(numB);
      }

      DateTime? dateA = DateTime.tryParse(a.toString());
      DateTime? dateB = DateTime.tryParse(b.toString());

      if (dateA != null && dateB != null) {
        return dateA.compareTo(dateB);
      }

      return a.toString().compareTo(b.toString());
    }

    if (_isSort) {
      widget.data.sort((a, b) => compare(a[_columnIndex], b[_columnIndex]));
    } else {
      widget.data.sort((a, b) => compare(b[_columnIndex], a[_columnIndex]));
    }
    print(_data);

    setState(() {});
  }

  void _filter() {
    _data =
        widget.data
            .where(
              (e) =>
                  (_selectFilterIndex == 0
                      ? e.any((f) => f.contains(_query))
                      : e[_selectFilterIndex - 1].contains(_query)),
            )
            .skip(_count > widget.splitindex ? _count : 0)
            .take(widget.splitindex)
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    _initTableWidth();
    _filter();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          _top(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Material(
                child: SizedBox(
                  width: _totalWidth,
                  child: Column(
                    children: [_header(), Expanded(child: _tableRow())],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _top() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 32,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PopupMenuButton(
              position: PopupMenuPosition.under,
              menuPadding: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.filter_list_outlined,
                  color:
                      _selectFilterIndex == 0
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                ),
              ),
              itemBuilder: (context) {
                return ['all', ...widget.header]
                    .map(
                      (e) => PopupMenuItem(
                        child: Text(e),
                        onTap: () {
                          setState(() {
                            _selectFilterIndex = [
                              'all',
                              ...widget.header,
                            ].indexOf(e);
                          });
                        },
                      ),
                    )
                    .toList();
              },
            ),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  isDense: true,
                  contentPadding: EdgeInsets.all(12),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            MyIconButton(
              child: Icon(Icons.print_outlined, color: Colors.grey),
              onPressed: () {
                exportToExcel(
                  context: context,
                  data: _data,
                  header: widget.header,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: _columnWidths.map(
        (key, value) => MapEntry(key, FixedColumnWidth(value)),
      ),
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          children:
              widget.header
                  .map(
                    (e) => TableCell(
                      child: SizedBox(
                        height: 36,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (_columnIndex ==
                                      widget.header.indexOf(e)) {
                                    _isSort = !_isSort;
                                  } else {
                                    _columnIndex = widget.header.indexOf(e);
                                    _isSort = true;
                                  }
                                  _sort();
                                },
                                child: SizedBox.expand(
                                  child: Container(
                                    color: Colors.grey.shade200,
                                    alignment:
                                        widget.alignments[widget.header.indexOf(
                                          e,
                                        )] ??
                                        Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color:
                                              _columnIndex ==
                                                      widget.header.indexOf(e)
                                                  ? Theme.of(
                                                    context,
                                                  ).primaryColor
                                                  : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                setState(() {
                                  _dx[widget.header.indexOf(e)] =
                                      _dx[widget.header.indexOf(e)]! +
                                      details.delta.dx;
                                });
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.resizeLeftRight,
                                child: Container(
                                  width: 5,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _tableRow() {
    return ListView.builder(
      controller: _scrollControler,
      shrinkWrap: true,
      itemCount: _data.length,
      itemBuilder:
          (context, index) => InkWell(
            onTap:
                widget.onTap == null
                    ? null
                    : () => widget.onTap!(int.parse(_data[index][0]) - 1),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: _columnWidths.map(
                (key, value) => MapEntry(key, FixedColumnWidth(value)),
              ),
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                TableRow(
                  children:
                      _data[index]
                          .map(
                            (e) => TableCell(
                              child: SizedBox(
                                height: 36,
                                child: SizedBox.expand(
                                  child: Container(
                                    alignment:
                                        widget.alignments[_data[index].indexOf(
                                          e,
                                        )] ??
                                        Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
    );
  }
}

Future<void> exportToExcel({
  required BuildContext context,
  required List<List<String>> data,
  required List<String>? header,
}) async {
  final excel = Excel.createExcel();
  final sheet = excel['Sheet1'];

  // Add header row
  if (header != null) {
    sheet.appendRow(header.map((e) => TextCellValue(e)).toList());
  }

  // Add data rows
  for (var row in data) {
    sheet.appendRow(row.map((cell) => TextCellValue(cell)).toList());
  }

  try {
    final fileBytes = excel.save();
    if (fileBytes == null) throw Exception('Failed to generate Excel file');

    final String? outputDir = await getDownloadsDirectory();
    if (outputDir == null) {
      throw Exception('Could not get download directory');
    }

    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final filePath = '$outputDir/data_$timestamp.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(fileBytes);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Export successfully: $filePath')));

    // 👉 Mở file ngay sau khi export thành công
    await OpenFile.open(filePath);
  } catch (e) {
    if (!kIsWeb) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}

Future<String?> getDownloadsDirectory() async {
  if (kIsWeb) {
    return null;
  }
  if (Platform.isAndroid) {
    // Android: Use external storage directory
    return "/storage/emulated/0/Download";
  } else if (Platform.isIOS) {
    // iOS: Use the application documents directory
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  } else if (Platform.isWindows) {
    return "C:\\Users\\${Platform.environment['USERNAME']}\\Downloads";
  } else if (Platform.isMacOS) {
    return "~/Downloads";
  } else if (Platform.isLinux) {
    return "~/Downloads";
  }

  return null;
}
