import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/task_model.dart';
import 'package:pmsn20232/screens/pr4_add_task.dart';

class PR4CardTaskWidget extends StatefulWidget {
  PR4CardTaskWidget(
    {super.key, required this.taskModel, this.agendaDB}
  );

  TaskModel taskModel;
  AgendaDB? agendaDB;

  @override
  State<PR4CardTaskWidget> createState() => _PR4CardTaskWidgetState();
}

class _PR4CardTaskWidgetState extends State<PR4CardTaskWidget> {
  bool isTaskCompleted = false;

  @override
  void initState(){
    super.initState();
    if(widget.taskModel.realizada == 1){
      isTaskCompleted = true;
    }else{
      isTaskCompleted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.green
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(widget.taskModel.nomTask!, 
                maxLines: 2, 
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),),
                Text(widget.taskModel.desTask!)
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: ()=> Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PR4AddTask(taskModel: widget.taskModel)
                  )
                ),
                child: Icon(Icons.border_color_rounded),
              ),
              IconButton(
                onPressed: (){
                  showDialog(
                    context: context, 
                    builder: (context){
                      return AlertDialog(
                        title: Text('Mensaje del sistema'),
                        content: Text('¿Deseas borrar la tarea?'),
                        actions: [
                          TextButton(
                            onPressed: (){
                              widget.agendaDB!.DELETE4('tblTask', 'idTask', widget.taskModel.idTask!).then((value){
                                Navigator.pop(context);
                                GlobalValues.flagPR4Task.value = !GlobalValues.flagPR4Task.value;
                              });
                            }, 
                            child: Text('Si')
                          ),
                          TextButton(
                            onPressed: ()=>Navigator.pop(context), 
                            child: Text('No')
                          ),
                        ],
                      );
                    },
                  );
                }, 
                icon: Icon(Icons.delete)
              ),
              Checkbox(
                value: isTaskCompleted, 
                onChanged: (newValue){
                  setState(() {
                    isTaskCompleted = newValue!;
                  });
                  int newValueInt = isTaskCompleted ? 1 : 0;
                  widget.agendaDB!.UPDATE4('tblTask', {'realizada': newValueInt}, 'idTask', widget.taskModel.idTask!).then((value){
                    GlobalValues.flagPR4Task.value = !GlobalValues.flagPR4Task.value;
                  });
                }
              )
            ],
          )
        ],
      ),
    );
  }
}