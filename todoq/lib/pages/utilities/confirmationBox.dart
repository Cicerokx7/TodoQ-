//This class is used to confirm if a queue should be deleted.

import 'package:flutter/material.dart';

class ConfirmationBox extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  VoidCallback delete;
  VoidCallback cancel;

  ConfirmationBox({super.key, required this.delete, required this.cancel, y});

  @override
  Widget build(BuildContext context) {
    //Display a box in front of the home page.
    return AlertDialog(
      backgroundColor: Colors.blue[400],
      content: Container(
        height: 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text("Are you sure you want to delete this queue?",
              style: const TextStyle(
                fontFamily: 'BookAntiqua',
                color: Colors.black,
                fontSize: 24,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                onPressed: delete,
                color: Color.fromARGB(255, 179, 0, 0),
                child: const Text(
                  "Delete",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'BookAntiqua',
                    color: Colors.black,
                  ),
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                onPressed: cancel,
                color: Colors.purple[500],
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'BookAntiqua',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
