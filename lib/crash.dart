import 'package:uuid/uuid.dart';

class Crash{
  String id = Uuid().v4();
  String error;
  String stack;

  Crash({required this.error, required this.stack});
}