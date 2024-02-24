import 'package:flutter/material.dart';

class ToDoItem extends StatelessWidget {
  final String itemName;
  final bool itemCompleted;
  Function(bool?)? onChanged;

  ToDoItem(
      {super.key,
      required this.itemName,
      required this.itemCompleted,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Color? itemColor = Colors.blue[400];
    if (itemCompleted) {
      itemColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Container(
          padding: EdgeInsets.all(24),
          child: Row(
            children: [
              //todo item name
              Text(
                itemName,
                style: TextStyle(
                    decoration: itemCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
                // style: TextStyle(color: Colors.purple[500]),
              ),
              Spacer(),
              //check box
              Checkbox(
                  value: itemCompleted,
                  onChanged: onChanged,
                  shape: CircleBorder()),
            ],
          ),
          decoration: BoxDecoration(
              color: itemColor, borderRadius: BorderRadius.circular(24))),
    );
  }
}
