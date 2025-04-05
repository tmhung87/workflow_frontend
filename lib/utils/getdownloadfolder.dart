import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

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
