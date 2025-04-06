import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:workflow/utils/exportexcel.dart';
import 'package:workflow/utils/getdownloadfolder.dart';
import 'package:workflow/widget/myiconbutton.dart';

class MyTable extends StatefulWidget {
  const MyTable({
    super.key,
    required this.header,
    this.columnWidths = const {},
    required this.data,
    this.onTap,
    this.alignments = const {},
  });
  final List<List<String>> data;
  final List<String> header;
  final Map<int, double> columnWidths;
  final Function(int index)? onTap;
  final Map<int, AlignmentGeometry> alignments;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i = 0; i < widget.header.length; i++) {
      _dx[i] = 0;
      _columnWidths[i] = 100;
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
    if (_isSort) {
      widget.data.sort((a, b) => a[_columnIndex].compareTo(b[_columnIndex]));
    } else {
      widget.data.sort((a, b) => b[_columnIndex].compareTo(a[_columnIndex]));
    }

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
      shrinkWrap: true,
      itemCount: _data.length,
      itemBuilder:
          (context, index) => InkWell(
            onTap: widget.onTap == null ? null : () => widget.onTap!(index),
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
