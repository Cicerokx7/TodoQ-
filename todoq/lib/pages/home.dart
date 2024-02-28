import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoq/data/dataBase.dart';
import 'package:todoq/pages/utilities/dialogBox.dart';
import 'package:todoq/pages/utilities/todoItem.dart';

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
    if (box.get("QUEUE") == null) {
      data.createInitialData();
    } else {
      data.load();
    }
    super.initState();
  }

  final controller = TextEditingController();

  void checkBoxChanged(bool? val, int i) {
    setState(() {
      data.toDoQueue[i][1] = !data.toDoQueue[i][1];
    });
    data.update();
  }

  void save() {
    setState(() {
      data.toDoQueue.add([controller.text, false]);
    });
    controller.clear();
    Navigator.of(context).pop();
    data.update();
  }

  void enqueue() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(controller: controller, saved: save);
      },
    );
  }

  void delete(int index) {
    setState(() {
      data.toDoQueue.removeAt(index);
    });
    data.update();
  }

  void moveUp(int index) {
    if (index > 0) {
      setState(() {
        List temp = data.toDoQueue[index];
        data.toDoQueue[index] = data.toDoQueue[index - 1];
        data.toDoQueue[index - 1] = temp;
      });
    }
    data.update();
  }

  void moveDown(int index) {
    if (index < data.toDoQueue.length - 1) {
      setState(() {
        List temp = data.toDoQueue[index];
        data.toDoQueue[index] = data.toDoQueue[index + 1];
        data.toDoQueue[index + 1] = temp;
      });
    }
    data.update();
  }

  @override
  Widget build(BuildContext context) {
    bool isTop = true;
    bool topNotFound = true;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Center(
          child: Text(
            "TodoQ",
            style: TextStyle(
              color: Colors.purple[500],
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'BookAntiqua',
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data.toDoQueue.length,
              itemBuilder: (context, index) {
                if (topNotFound && data.toDoQueue[index][1] == false) {
                  isTop = true;
                  topNotFound = false;
                } else {
                  isTop = false;
                }
                return ToDoItem(
                  itemName: data.toDoQueue[index][0],
                  itemCompleted: data.toDoQueue[index][1],
                  onChanged: (val) => checkBoxChanged(val, index),
                  isTop: isTop,
                  delete: (context) => delete(index),
                  moveUp: (context) => moveUp(index),
                  moveDown: (context) => moveDown(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
