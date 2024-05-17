//This is the class to display a to-do item.

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class ToDoItem extends StatelessWidget {
  // This is the name of the item.
  final String itemName;
  // This is if the checkBox is checked or not.
  final bool itemCompleted;
  // This is used to indicated if the state of the checkBox has been changed.
  Function(bool?)? onChanged;
  // This is if the item is at the top of the queue
  final bool isTop;
  // This is used to indicate if the item should be deleted.
  Function(BuildContext)? delete;
  // This is used to indicate if the item should be edited.
  Function(BuildContext)? edit;

  ToDoItem({
    Key? key,
    required this.itemName,
    required this.itemCompleted,
    required this.onChanged,
    required this.isTop,
    required this.delete,
    required this.edit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If the item is not at the top of the queue and the item is not completed then set it to blue.
    Color? itemColor = Colors.blue[400];
    // If the item is at the top of the queue and the item is not completed then set it to purple.
    if (isTop) {
      itemColor = Colors.green;
    }
    // If the item is completed set it to purple.
    if (itemCompleted) {
      itemColor = Colors.purple;
    }

    return Container(
      color: Color.fromARGB(200, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(children: [
          //If the item is the top of the queue the put a bar and text above the item to indicate this is the top of the queue.
          Visibility(
            visible: isTop,
            child: Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[500], thickness: 3)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text("Next Todo",
                      style: TextStyle(
                          fontFamily: 'BookAntiqua',
                          color: Colors.grey,
                          fontSize: 24)),
                ),
                Expanded(child: Divider(color: Colors.grey[500], thickness: 3))
              ],
            ),
          ),
          Slidable(
            //If the item is slid to the right diplay the edit button.
            startActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: edit,
                  icon: Icons.edit,
                  backgroundColor: Colors.yellow,
                  borderRadius: BorderRadius.circular(24),
                ),
              ],
            ),
            // If the item is slid to the left display the delete button on the right.
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: delete,
                  icon: Icons.close,
                  backgroundColor: Colors.red,
                  borderRadius: BorderRadius.circular(24),
                )
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: itemColor, borderRadius: BorderRadius.circular(24)),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        itemName,
                        // If the item's name goes out of bounds wrap around and extend the size of the item.
                        softWrap: true,
                        maxLines: null,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'BookAntiqua',
                            // If item is completed display the box as checked and put a line through the name of the item.
                            decoration: itemCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                    ),
                  ),
                  Checkbox(
                    value: itemCompleted,
                    onChanged: onChanged,
                    shape: const CircleBorder(),
                    activeColor: Colors.black,
                    side: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // If the item is the top of the queue then put a line across the bottom of the item to indicate that it is the top.
          Visibility(
            visible: isTop,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: Colors.grey[500], thickness: 3),
            ),
          ),
        ]),
      ),
    );
  }
}
