import 'package:hive_flutter/hive_flutter.dart';

class QueueDataBase {
  List toDoQueue = [];
  final box = Hive.box("phoneBox");
  void createInitialData() {
    toDoQueue = [
      ["create tasks", false],
      ["complete the green task first", false],
      ["then complete the next green task", false],
      ["delete demo tasks", false],
    ];
  }

  void load() {
    toDoQueue = box.get("QUEUE");
  }

  void update() {
    box.put("QUEUE", toDoQueue);
  }
}
