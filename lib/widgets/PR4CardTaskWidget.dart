import 'package:flutter/material.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/task_model.dart';

class PR4CardTaskWidget extends StatelessWidget {
  PR4CardTaskWidget(
    {super.key, required this.taskModel, this.agendaDB}
  );

  TaskModel taskModel;
  AgendaDB? agendaDB;

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
          Column(
            children: [
              Text(taskModel.nomTask!),
              Text(taskModel.desTask!)
            ],
          ),
          Expanded(
            child: Container(),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: ()=> Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTask(tareaModel: taskModel)
                  )
                ),
                child: Image.asset('assets/icon_orange.png', height:50),
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
                              agendaDB!.DELETE('tblTareas', taskModel.idTarea!).then((value){
                                Navigator.pop(context);
                                GlobalValues.flagTask.value = !GlobalValues.flagTask.value;
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
              )
            ],
          )
        ],
      ),
    );
  }
}