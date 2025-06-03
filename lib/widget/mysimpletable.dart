import 'package:flutter/material.dart';
import 'package:workflow/utils/formatCamelCase.dart';

class MySimpleTable extends StatefulWidget {
  const MySimpleTable({
    super.key,
    required this.length,
    required this.header,
    this.columnWidths = const {0: 50},
    required this.builder,
    this.alignments = const {},
    this.splitindex = 50,
    this.isScroll = true,
  });
  final List<Widget> Function(int index) builder;
  final List<String> header;
  final Map<int, double> columnWidths;
  final Map<int, AlignmentGeometry> alignments;
  final int splitindex;
  final bool isScroll;
  final int length;
  @override
  State<MySimpleTable> createState() => _MySimpleTableState();
}

class _MySimpleTableState extends State<MySimpleTable> {
  final int _columnIndex = 0;
  double _totalWidth = 0;
  final Map<int, double> _columnWidths = {};
  final Map<int, double> _dx = {};
  final _scrollControler = ScrollController();
  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    _initTableWidth();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Material(
            child: SizedBox(
              width: _totalWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [_header(), Flexible(child: _tableRow())],
              ),
            ),
          ),
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
                                      formatCamelCase(e),
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color:
                                            _columnIndex ==
                                                    widget.header.indexOf(e)
                                                ? Theme.of(context).primaryColor
                                                : null,
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
      itemCount: widget.length,
      itemBuilder:
          (context, index) => Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: _columnWidths.map(
              (key, value) => MapEntry(key, FixedColumnWidth(value)),
            ),
            border: TableBorder.all(color: Colors.grey.shade300),
            children: [TableRow(children: widget.builder(index))],
          ),
    );
  }
}
