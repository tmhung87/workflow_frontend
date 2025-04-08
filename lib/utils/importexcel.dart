import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

Future<List<List<String>>> importExcel() async {
  List<List<String>> allRows = [];

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx', 'xls'],
  );

  if (result == null) {
    return [];
  }
  Uint8List? fileBytes;

  if (!kIsWeb && result.files.single.path != null) {
    File file = File(result.files.single.path!);
    fileBytes = file.readAsBytesSync();
  } else {
    fileBytes = result.files.single.bytes;
  }

  if (fileBytes == null) {
    return [];
  }

  final excel = Excel.decodeBytes(fileBytes);
  final table = excel.tables.values.first;
  final rows = table.rows;
  allRows =
      rows
          .map(
            (e) =>
                e
                    .map(
                      (cell) =>
                          cell == null
                              ? ''
                              : (cell.value == null
                                  ? ''
                                  : cell.value.toString()),
                    )
                    .toList(),
          )
          .toList();
  allRows.removeAt(0);
  return allRows;
}
