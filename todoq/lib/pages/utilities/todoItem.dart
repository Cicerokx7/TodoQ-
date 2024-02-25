import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoItem extends StatelessWidget {
  final String itemName;
  final bool itemCompleted;
  Function(bool?)? onChanged;
  final bool isTop;
  Function(BuildContext)? delete;

  ToDoItem({
    Key? key,
    required this.itemName,
    required this.itemCompleted,
    required this.onChanged,
    required this.isTop,
    required this.delete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? itemColor = Colors.blue[400];
    if (isTop) {
      itemColor = Colors.green;
    }
    if (itemCompleted) {
      itemColor = const Color.fromRGBO(
        184,
        148,
        7,
        1,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(children: [
        Visibility(
          visible: isTop,
          child: Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[500], thickness: 3)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text("Next to Complete",
                    style: TextStyle(
                        fontFamily: 'BookAntiqua',
                        color: Color.fromRGBO(
                          184,
                          148,
                          7,
                          1,
                        ),
                        fontSize: 24)),
              ),
              Expanded(child: Divider(color: Colors.grey[500], thickness: 3))
            ],
          ),
        ),
        Slidable(
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
                      softWrap: true,
                      maxLines: null,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'BookAntiqua',
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
        Visibility(
          visible: isTop,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Expanded(
              child: Divider(color: Colors.grey[500], thickness: 3),
            ),
          ),
        ),
      ]),
    );
  }
}
