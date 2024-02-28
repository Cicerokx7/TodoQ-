import 'package:hive_flutter/hive_flutter.dart';

class QueueDataBase {
  List toDoQueue = [];
  final box = Hive.box("phoneBox");
  void createInitialData() {
    toDoQueue = [];
  }

  void load() {
    toDoQueue = box.get("QUEUE");
  }

  void update() {
    box.put("QUEUE", toDoQueue);
  }
}
