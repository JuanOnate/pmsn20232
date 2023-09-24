import 'package:flutter/material.dart';
import 'package:pmsn20232/models/tarea_model.dart';

class CardTaskWidget extends StatelessWidget {
  CardTaskWidget(
    {super.key, required this.taskModel}
  );

  TareaModel taskModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Text(taskModel.nombreTarea!),
              Text(taskModel.descTarea!)
            ],
          )
        ],
      ),
    );
  }
}