import 'package:intl/intl.dart';

String get getDate {
  String data = DateTime.now().toString();
  var inputFormat = DateFormat('yyyy-MM-dd');
  var inputDate = inputFormat.parse(data);
  var outputFormat = DateFormat('dd/MM/yyyy');
  return outputFormat.format(inputDate);
}
