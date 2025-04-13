import 'package:intl/intl.dart';

final mysqlFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

String? toMySQLDate(DateTime? date) {
  if (date == null) return null;
  return mysqlFormat.format(date);
}
