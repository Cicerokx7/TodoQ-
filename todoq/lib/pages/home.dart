import 'package:flutter/material.dart';
import 'package:todoq/pages/utilities/todoItem.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  List toDoQueue = [
    ["GetJob", false],
    ["Stuff", false],
  ];

  void checkBoxChanged(bool? val, int i) {
    setState(() {
      toDoQueue[i][1] = !toDoQueue[i][1];
    });
  }

  void enqueue() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "TodoQ",
          style: TextStyle(color: Colors.purple[500]),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: toDoQueue.length,
              itemBuilder: (context, index) {
                return ToDoItem(
                  itemName: toDoQueue[index][0],
                  itemCompleted: toDoQueue[index][1],
                  onChanged: (val) => checkBoxChanged(val, index),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: enqueue,
              child: Icon(Icons.add),
              backgroundColor: Colors.purple[500],
            ),
          ),
        ],
      ),
    );
  }
}
