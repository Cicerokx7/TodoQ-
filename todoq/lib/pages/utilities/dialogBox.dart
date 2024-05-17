//This class is used to create a new item or queue.

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DialogBox extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  VoidCallback saved;

  DialogBox({
    super.key,
    required this.controller,
    required this.hintText,
    required this.saved,
  });

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
          TextField(
              controller: controller,
              style: const TextStyle(
                fontFamily: 'BookAntiqua',
                color: Colors.black,
              ),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                hintText: hintText,
              ),
              cursorColor: Colors.black,
              onSubmitted: (String value) {
                saved();
              }),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            onPressed: saved,
            color: Colors.purple[500],
            child: const Text(
              "Save",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'BookAntiqua',
                color: Colors.black,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
