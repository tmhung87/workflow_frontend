import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:workflow/utils/getdownloadfolder.dart';
import 'package:workflow/widget/showdialog.dart'; // thêm dòng này

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

    showMyDialog(
      context: context,
      title: 'Export to excel',
      content: 'PATH: $filePath',
    );

    // 👉 Mở file ngay sau khi export thành công
    await OpenFile.open(filePath);
  } catch (e) {
    if (!kIsWeb) {
      showMyDialog(
        isSuccess: false,
        context: context,
        title: 'Export to excel',
        content: '$e',
      );
    }
  }
}
