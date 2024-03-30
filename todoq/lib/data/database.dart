// This class manages the phone's database.

import 'package:hive_flutter/hive_flutter.dart';

class QueueDataBase {
  List toDoQueue = [];
  int top = -1;
  final box = Hive.box("phoneBox");
  //This is the initial starting data.
  //This should be called only if it is the first time the app has everbeen used.
  void createInitialData() {
    toDoQueue = [];
  }

  //This loads the data from the phones database.
  void load() {
    toDoQueue = box.get("QUEUE");
    top = -1;
    for (int i = 0; i < toDoQueue.length; i++) {
      if (toDoQueue[i][1] == false) {
        top = i;
        i = toDoQueue.length;
      }
    }
  }

  //This store the new data to the phones database.
  void update() {
    box.put("QUEUE", toDoQueue);
    top = -1;
    for (int i = 0; i < toDoQueue.length; i++) {
      if (toDoQueue[i][1] == false) {
        top = i;
        i = toDoQueue.length;
      }
    }
  }
}
