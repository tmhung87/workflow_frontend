import 'package:flutter/material.dart';
import 'package:excel/excel.dart' hide Border;
import 'dart:io';
import 'package:workflow/utils/getdownloadfolder.dart';

class MyTable extends StatefulWidget {
  const MyTable({
    super.key,
    required this.length,
    required this.builder,
    required this.header,
    this.columnWidths,
    this.fileName = 'table',
    this.onClick,
  });
  final int length;
  final List<Widget> Function(int index) builder;
  final List<String> header;
  final Map<int, double>? columnWidths;
  final String fileName;
  final Function(int index)? onClick;

  @override
  State<MyTable> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {
  int _indexCol = 0;
  bool _isAscending = true;
  List<List<Widget>> _data = [];
  List<List<Widget>> _filteredData = [];
  String _selectedColumn = 'Toàn bảng';
  double _totalWidth = 0;

  // Tạo kích thước cột mặc định
  final Map<int, TableColumnWidth> _defaultColumnWidths = {};
  Map<int, double> _columnWidths = {};

  void _initColumnWidths() {
    _columnWidths = {
      for (var index in List.generate(widget.header.length, (index) => index))
        index: widget.columnWidths?[index] ?? 100,
    };
  }

  void _fillDefaultColumnWidths() {
    _totalWidth = 0;
    for (int i = 0; i < widget.header.length; i++) {
      _defaultColumnWidths[i] = FixedColumnWidth(_columnWidths[i]!);
      _totalWidth += _columnWidths[i]!;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    print('init');
    _data = List.generate(widget.length, (index) => widget.builder(index));
    _filteredData = List.from(_data);
    _initColumnWidths();
    _fillDefaultColumnWidths();
  }

  void _sortData() {
    setState(() {
      _filteredData.sort((a, b) {
        final valueA = _extractText(a[_indexCol]);
        final valueB = _extractText(b[_indexCol]);

        final parsedA = _parseValue(valueA);
        final parsedB = _parseValue(valueB);

        int compareResult;
        if (parsedA is int && parsedB is int) {
          compareResult = parsedA.compareTo(parsedB);
        } else if (parsedA is DateTime && parsedB is DateTime) {
          compareResult = parsedA.compareTo(parsedB);
        } else {
          compareResult = valueA.compareTo(valueB);
        }

        return _isAscending ? compareResult : -compareResult;
      });
    });
  }

  String _extractText(Widget widget) {
    if (widget is Text) {
      return widget.data ?? '';
    } else if (widget is RichText) {
      return widget.text.toPlainText();
    }
    return widget.toString();
  }

  dynamic _parseValue(String value) {
    final intValue = int.tryParse(value);
    if (intValue != null) return intValue;

    final dateValue = DateTime.tryParse(value);
    if (dateValue != null) return dateValue;

    return value;
  }

  void _filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = List.from(_data);
      } else {
        if (_selectedColumn == 'Toàn bảng') {
          _filteredData =
              _data
                  .where(
                    (row) => row.any(
                      (cell) => _extractText(
                        cell,
                      ).toLowerCase().contains(query.toLowerCase()),
                    ),
                  )
                  .toList();
        } else {
          final columnIndex = widget.header.indexOf(_selectedColumn);
          _filteredData =
              _data
                  .where(
                    (row) => _extractText(
                      row[columnIndex],
                    ).toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();
        }
      }
    });
  }

  Future<void> _exportToExcel(BuildContext context, String fileName) async {
    final excel = Excel.createExcel();

    final sheet = excel['Sheet1'];

    sheet.appendRow(widget.header.map((e) => TextCellValue(e)).toList());
    for (var row in _filteredData) {
      sheet.appendRow(
        row.map((cell) => TextCellValue(_extractText(cell))).toList(),
      );
    }

    final fileBytes = excel.save(
      fileName:
          '$fileName${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}.xlsx',
    );
    if (fileBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tạo file Excel.')),
      );
      return;
    }

    try {
      String? outputDir = await getDownloadsDirectory();
      final file = File(
        '$outputDir/$fileName${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}.xlsx',
      );
      await file.writeAsBytes(fileBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xuất dữ liệu thành công: ${file.path}')),
      );
    } catch (e) {
      print(e);
    }
  }

  Widget _buildHeader() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: _defaultColumnWidths,
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: [
            for (int colIndex = 0; colIndex < widget.header.length; colIndex++)
              TableCell(
                child: InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      _indexCol = colIndex;
                      _isAscending = !_isAscending;
                      _sortData();
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            widget.header[colIndex],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                              color:
                                  _indexCol == colIndex
                                      ? Colors.blue
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _columnWidths[colIndex] =
                                (_columnWidths[colIndex]! + details.delta.dx)
                                    .clamp(50.0, 1000.0);

                            _fillDefaultColumnWidths();
                          });
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.resizeLeftRight,
                          child: LayoutBuilder(
                            builder:
                                (context, constraints) => Container(
                                  width: 5,
                                  // height: constraints.maxHeight,
                                  height: 20,
                                  color: Colors.grey[100],
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(int index) {
    return InkWell(
      // hoverColor: Colors.transparent,
      // focusColor: Colors.transparent,
      // highlightColor: Colors.transparent,
      // splashColor: Colors.transparent,
      onTap: () => widget.onClick?.call(index),
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        columnWidths: _defaultColumnWidths, // Sử dụng mặc định nếu null
        children: [
          TableRow(
            children: [
              for (var item in _filteredData[index])
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: item,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 500),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: topTable(context),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: _totalWidth,
                  child: Column(
                    children: [
                      _buildHeader(),
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _buildRow(index);
                        },
                        itemCount: _filteredData.length,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row topTable(BuildContext context) {
    return Row(
      children: [
        PopupMenuButton<String>(
          constraints: BoxConstraints(maxHeight: 300),
          shadowColor: Colors.black,
          position: PopupMenuPosition.under,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              Icons.filter_list,
              color: _selectedColumn == 'All' ? Colors.grey : Colors.blue,
            ),
          ),
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: 'All', child: Text('All')),
                ...widget.header.map(
                  (header) => PopupMenuItem(value: header, child: Text(header)),
                ),
              ],
          onSelected: (value) {
            setState(() {
              _selectedColumn = value;
            });
          },
        ),
        const VerticalDivider(color: Colors.grey, width: 1),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: Colors.transparent),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 8,
              ),
              isDense: true,
            ),
            onChanged: _filterData,
          ),
        ),
        const VerticalDivider(color: Colors.grey, width: 1),
        Tooltip(
          message: 'Export to excel',
          child: InkWell(
            onTap: () => _exportToExcel(context, widget.fileName),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: const Icon(Icons.print, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
