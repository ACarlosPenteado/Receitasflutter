import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

String get getDate {
  String data = DateTime.now().toString();
  var inputFormat = DateFormat('yyyy-MM-dd');
  var inputDate = inputFormat.parse(data);
  var outputFormat = DateFormat('dd/MM/yyyy');
  return outputFormat.format(inputDate);
}

String get getId {
  var uid = Uuid();
  var v4 = uid.v4();
  String novo = v4.toString();
  return novo;
}
