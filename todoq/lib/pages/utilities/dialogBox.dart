import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  VoidCallback saved;

  DialogBox({
    super.key,
    required this.controller,
    required this.saved,
  });

  @override
  Widget build(BuildContext context) {
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
              hintText: "Todo",
            ),
            cursorColor: Colors.black,
          ),
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
