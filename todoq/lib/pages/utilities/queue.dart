//This is the class to display a to-do item.

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class Queue extends StatelessWidget {
  // This is the name of the queue.
  final String queueName;
  // This is used to indicate if the queue should be deleted.
  Function(BuildContext)? delete;
  // This is used to indicate if the queue should be edited.
  Function(BuildContext)? edit;
  //This is used to indicate if this queue is the main queue.
  final bool selectedQueue;

  Queue({
    Key? key,
    required this.queueName,
    required this.delete,
    required this.edit,
    required this.selectedQueue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //If the queue is not the main queue it has a dark background.
    Color? containerColors = Colors.grey[900];
    //If the queue is the main queue it has a lighter background.
    if (selectedQueue) {
      containerColors = Colors.grey[800];
    }
    return Container(
      color: containerColors,
      child: Slidable(
        //If the queue is slid to the right diplay the edit button.
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
        // If the queue is slid to the left display the delete button on the right.
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
        //Display the name of the queue.
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              queueName,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'BookAntiqua',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
