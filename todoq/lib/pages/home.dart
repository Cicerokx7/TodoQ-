//This is the main page where the to-do queue is shown.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoq/data/dataBase.dart';
import 'package:todoq/pages/utilities/dialogBox.dart';
import 'package:todoq/pages/utilities/todoItem.dart';

import 'utilities/editBox.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final box = Hive.box("phoneBox");
  QueueDataBase data = QueueDataBase();

  @override
  void initState() {
    // If this is the first time the app has been opened start with the demo data.
    if (box.get("QUEUE") == null) {
      data.createInitialData();
    }
    // If not then load the data from the database
    else {
      data.load();
    }
    super.initState();
  }

  final controller = TextEditingController();

  // If an item's box is checked then this will run.
  // The parameters are the checkBox's state and the index of the item.
  void checkBoxChanged(bool? val, int i) {
    setState(() {
      //Set the checkBox to the oposite state.
      data.toDoQueue[i][1] = !data.toDoQueue[i][1];
    });
    //update the database
    data.update();
  }

  //This runs to create a new item after all the necesary info has been entered into the dialog box and the save button has been pressed.
  void save() {
    setState(() {
      data.toDoQueue.add([controller.text, false]);
    });
    controller.clear();
    Navigator.of(context).pop();
    data.update();
  }

  void editSave(int index) {
    setState(() {
      data.toDoQueue[index][0] = controller.text;
    });
    controller.clear();
    Navigator.of(context).pop();
    data.update();
  }

  //This runs when the floating plus button has been pressed to open the dialog box
  void enqueue() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(controller: controller, saved: save);
      },
    );
  }

  //This runs when the delete button on an item has been pressed and this will then delete the item.
  void delete(int index) {
    setState(() {
      data.toDoQueue.removeAt(index);
    });
    data.update();
  }

  //This runs when the move up button has been pressed and then it moves the item up in the queue.
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
        );
      },
    );
  }

  void updateItemOrder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex = newIndex - 1;
    }
    setState(() {
      final item = data.toDoQueue.removeAt(oldIndex);
      data.toDoQueue.insert(newIndex, item);
    });
    data.update();
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
      //This will display a floating plus button at the bottom center to create a new task.
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple[500],
        onPressed: enqueue,
        elevation: 0,
        child: const Icon(
          Icons.add_rounded,
          size: 50,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //This is the queue of tasks displayed as a column
      body: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        itemCount: data.toDoQueue.length,
        itemBuilder: (context, index) {
          //If the top of the queue has not been found and this item is not completed then it must be the top of the queue
          if (index == data.top) {
            isTop = true;
          } else {
            isTop = false;
          }
          // Display the item.
          return ReorderableDelayedDragStartListener(
            key: Key('$index'),
            index: index,
            child: ToDoItem(
              // key: Key('$index'),
              itemName: data.toDoQueue[index][0],
              itemCompleted: data.toDoQueue[index][1],
              onChanged: (val) => checkBoxChanged(val, index),
              isTop: isTop,
              delete: (context) => delete(index),
              edit: (context) => edit(index, data.toDoQueue[index][0]),
            ),
          );
        },
        onReorder: (oldIndex, newIndex) => updateItemOrder(oldIndex, newIndex),
      ),
    );
  }
}
