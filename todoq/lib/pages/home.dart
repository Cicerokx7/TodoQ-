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
    // if (box.get("QUEUE") == null) {
    //   data.createInitialData();
    // } else {
    data.load();
    // }
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
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: Colors.purple[500],
          onPressed: enqueue,
          elevation: 0,
          child: const Icon(
            Icons.add_rounded,
            size: 50,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data.toDoQueue.length,
              itemBuilder: (context, index) {
                if (topNotFound && data.toDoQueue[index][1] == false) {
                  isTop = true;
                  topNotFound = false;
                  Row(
                    children: [
                      Expanded(
                          child:
                              Divider(color: Colors.grey[500], thickness: 3)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("Or Sign In Using",
                            style: TextStyle(
                                color: Color.fromRGBO(
                                  184,
                                  148,
                                  7,
                                  1,
                                ),
                                fontSize: 20)),
                      ),
                      Expanded(
                          child: Divider(color: Colors.grey[500], thickness: 3))
                    ],
                  );
                } else {
                  isTop = false;
                }
                return ToDoItem(
                  itemName: data.toDoQueue[index][0],
                  itemCompleted: data.toDoQueue[index][1],
                  onChanged: (val) => checkBoxChanged(val, index),
                  isTop: isTop,
                  delete: (context) => delete(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
