// This class manages the phone's database.

import 'package:hive_flutter/hive_flutter.dart';

class QueueDataBase {
  List toDoQueue = [];
  int queue = 0;
  int top = -1;
  final box = Hive.box("phoneBox");
  //This is the initial starting data.
  //This should be called only if it is the first time the app has everbeen used.
  void createInitialData() {
    toDoQueue = [
      ["General", []]
    ];
    box.put("QUEUES", toDoQueue);
    queue = 0;
    box.put("QUEUE", queue);
  }

  //This loads the data from the phones database.
  void load() {
    toDoQueue = box.get("QUEUES");
    queue = box.get("QUEUE");
    updateTop();
  }

  //This store the new toDoQueue data to the phones database.
  void update() {
    box.put("QUEUES", toDoQueue);
    updateTop();
  }

  //This will store the new data for the queue index to the phones database.
  void updateQueue(int q) {
    queue = q;
    box.put("QUEUE", queue);
    updateTop();
  }

  //This will identify the top of the queue. This will only run if there is a queue.
  void updateTop() {
    top = -1;
    if (queue != -1) {
      for (int i = 0; i < toDoQueue[queue][1].length; i++) {
        if (toDoQueue[queue][1][i][1] == false) {
          top = i;
          i = toDoQueue[queue][1].length;
        }
      }
    }
  }
}
