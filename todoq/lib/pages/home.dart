//This is the main page where the to-do queue is shown.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoq/data/dataBase.dart';
import 'package:todoq/pages/utilities/dialogBox.dart';
import 'package:todoq/pages/utilities/queue.dart';
import 'package:todoq/pages/utilities/todoItem.dart';

import 'utilities/confirmationBox.dart';
import 'utilities/editBox.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final box = Hive.box("phoneBox");
  QueueDataBase data = QueueDataBase();
  int queueIndex = 0;

  @override
  void initState() {
    // If this is the first time the app has been opened start with the demo data.
    if (box.get("QUEUES") == null) {
      data.createInitialData();
    }
    // If not then load the data from the database
    else {
      data.load();
      queueIndex = data.queue;
    }
    super.initState();
  }

  final controller = TextEditingController();

  // If an item's box is checked then this will run.
  // The parameters are the checkBox's state and the index of the item.
  void checkBoxChanged(bool? val, int i) {
    setState(() {
      //Set the checkBox to the oposite state.
      data.toDoQueue[queueIndex][1][i][1] =
          !data.toDoQueue[queueIndex][1][i][1];
    });
    //update the database
    data.update();
  }

  //This runs to create a new item after all the necesary info has been entered into the dialog box and the save button has been pressed.
  void save() {
    setState(() {
      data.toDoQueue[queueIndex][1].add([controller.text, false]);
    });
    controller.clear();
    Navigator.of(context).pop();
    data.update();
  }

  //This runs to edit an item after the save button has been pressed on the editBox.
  void editSave(int index) {
    setState(() {
      data.toDoQueue[queueIndex][1][index][0] = controller.text;
    });
    controller.clear();
    Navigator.of(context).pop();
    data.update();
  }

  //This runs to edit a queue after the save button has been pressed on the editBox.
  void editQueueSave(int index) {
    setState(() {
      data.toDoQueue[index][0] = controller.text;
    });
    controller.clear();
    Navigator.of(context).pop();
    data.update();
  }

  //This runs to save a new queue after the save button has been pressed on the dialogBox then it will move the queueIndex to the newly created queue.
  void saveQueue() {
    setState(() {
      data.toDoQueue.add([controller.text, []]);
    });
    controller.clear();
    Navigator.of(context).pop();
    queueIndex = data.toDoQueue.length - 1;
    data.updateQueue(queueIndex);
    // data.update();
  }

  //This runs when the floating plus button has been pressed to open the dialog box
  void enqueue() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(controller: controller, hintText: "Todo", saved: save);
      },
    );
  }

  //This runs when the "add" button is pressed to add a new queue to the bottom.
  void newQueue() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
            controller: controller, hintText: "Queue", saved: saveQueue);
      },
    );
    data.update();
  }

  //This runs when the delete button on an item has been pressed and this will then delete the item.
  void delete(int index) {
    setState(() {
      data.toDoQueue[queueIndex][1].removeAt(index);
    });
    data.update();
  }

  //This runs when the delete button is pressed on the confirmationBox. It will delete the selected queue.
  void deleteQueue(int index) {
    setState(() {
      data.toDoQueue.removeAt(index);
      //If the queueIndex is greater than or equal to the queue that is being deleted, it will decrease the queueIndex to keep the queue displayed the same.
      if (queueIndex >= index) {
        queueIndex -= 1;
        data.updateQueue(queueIndex);
      }
    });
    data.update();
  }

  //This runs when a queue's delete button is pressed it will open a ConfirmationBox. If the delete button is selected the queue will be deleted. If the cancel button is selected it will close the box.
  void deleteQueueConfirm(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return ConfirmationBox(
            delete: () {
              deleteQueue(index);
              Navigator.of(context).pop();
            },
            cancel: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  //This runs when the edit button is selected on an item and it will open an EditBox.
  void edit(int index, String title) {
    controller.text = title;
    showDialog(
      context: context,
      builder: (context) {
        return EditBox(
          controller: controller,
          saved: () {
            editSave(index);
          },
          hintText: "TodoQ",
        );
      },
    );
    data.update();
  }

  //This will run when the edit button is selected on a queue and it will open an EditBox.
  void editQueue(int index, String title) {
    controller.text = title;
    showDialog(
      context: context,
      builder: (context) {
        return EditBox(
          controller: controller,
          saved: () {
            editQueueSave(index);
          },
          hintText: "Queue",
        );
      },
    );
    data.update();
  }

  //This will run when an item has been moved. It will update the order of the items in the database.
  void updateItemOrder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex = newIndex - 1;
    }
    setState(() {
      final item = data.toDoQueue[queueIndex][1].removeAt(oldIndex);
      data.toDoQueue[queueIndex][1].insert(newIndex, item);
    });
    data.update();
  }

  //This will run when an item has been moved. It will update the order of the queue in the database.
  void updateQueueOrder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex = newIndex - 1;
    }
    queueIndex = newIndex;
    data.updateQueue(queueIndex);
    setState(() {
      final item = data.toDoQueue.removeAt(oldIndex);
      data.toDoQueue.insert(newIndex, item);
    });
    data.update();
  }

  //This will run when a queue has been selected in the droor and the queue will be set as the main queue.
  void changeQueue(int index) {
    setState(() {
      queueIndex = index;
      data.updateQueue(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    //This var is used to determine if an item is next uncomplete item in the queue.
    bool isTop = true;
    //This var is used to determine if the top of the queue has been found.
    bool topNotFound = true;
    return Scaffold(
      backgroundColor: Colors.black,
      //This will show the name of the app and the logo at the top of the app.
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Todo",
              style: TextStyle(
                color: Colors.purple,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'BookAntiqua',
              ),
            ),
            Image.asset(
              'lib/images/iconTransparent2ForApp.png',
              height: 72,
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      //This will display a floating plus button at the bottom center to create a new task. This will only work if there is a queue to add to.
      floatingActionButton: (queueIndex != -1)
          ? FloatingActionButton(
              backgroundColor: Colors.purple[500],
              onPressed: enqueue,
              elevation: 0,
              child: const Icon(
                Icons.add_rounded,
                size: 50,
                color: Colors.black,
              ),
            )
          : Container(), //This is an empty container to be used if there is no queues.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //This is the queue of tasks displayed as a column. This will only be shown if there is a queue.
      body: (queueIndex != -1)
          ? ReorderableListView.builder(
              buildDefaultDragHandles: false,
              itemCount: data.toDoQueue[queueIndex][1].length + 1,
              itemBuilder: (context, index) {
                //If the top of the queue has not been found and this item is not completed then it must be the top of the queue
                if (index == data.top) {
                  isTop = true;
                } else {
                  isTop = false;
                }
                // Display the item.
                return (index == data.toDoQueue[queueIndex][1].length)
                    ? Container(key: Key('$index'), height: 70)
                    : ReorderableDelayedDragStartListener(
                        key: Key('$index'),
                        index: index,
                        child: ToDoItem(
                          itemName: data.toDoQueue[queueIndex][1][index][0],
                          itemCompleted: data.toDoQueue[queueIndex][1][index]
                              [1],
                          onChanged: (val) => checkBoxChanged(val, index),
                          isTop: isTop,
                          delete: (context) => delete(index),
                          edit: (context) => edit(
                              index, data.toDoQueue[queueIndex][1][index][0]),
                        ),
                      );
              },
              onReorder: (oldIndex, newIndex) =>
                  updateItemOrder(oldIndex, newIndex),
            )
          :
          //This will be displayed if there are no queues.
          Center(
              child: Text("Add a new queue.",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'BookAntiqua',
                    color: Colors.white,
                  )),
            ),
      // This is a drawer to select and add queues.
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          children: [
            Text(
              "Queues",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'BookAntiqua',
                color: Colors.white,
              ),
            ),
            Divider(
              color: Colors.grey[800],
            ),
            Expanded(
              //It will display a list of the queues if there are queues to display.
              child: (queueIndex != -1)
                  ? ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      itemCount: data.toDoQueue.length,
                      itemBuilder: (context, index) {
                        bool selectedQueue = false;
                        if (index == queueIndex) {
                          selectedQueue = true;
                        }
                        //If a queue has been selected it will be set as the main queue.
                        return GestureDetector(
                          onTap: () => changeQueue(index),
                          key: Key('$index'),
                          child: ReorderableDelayedDragStartListener(
                            index: index,
                            child: Queue(
                                selectedQueue: selectedQueue,
                                queueName: data.toDoQueue[index][0],
                                delete: (context) => deleteQueueConfirm(index),
                                edit: (context) =>
                                    editQueue(index, data.toDoQueue[index][0])),
                          ),
                        );
                      },
                      onReorder: (oldIndex, newIndex) =>
                          updateQueueOrder(oldIndex, newIndex),
                    )
                  :
                  //If there are no queues the following will be displayed.
                  Center(
                      child: Text(
                        "Add a new queue",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'BookAntiqua',
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
            //This is the add button to add a new queue.
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              onPressed: newQueue,
              color: Colors.purple[500],
              child: const Text(
                "Add",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'BookAntiqua',
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
