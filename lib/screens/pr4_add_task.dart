import 'package:flutter/material.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/task_model.dart';

class PR4AddTask extends StatefulWidget {
  PR4AddTask({super.key, this.taskModel});

  TaskModel? taskModel;

  @override
  State<PR4AddTask> createState() => _PR4AddTaskState();
}

class _PR4AddTaskState extends State<PR4AddTask> {
  String? dropDownValue = "Pendiente";
  TextEditingController txtConName = TextEditingController();
  TextEditingController txtConDsc = TextEditingController();
  List<String> dropDownValues = [
    'Pendiente',
    'Completado',
    'En proceso'
  ];

  AgendaDB? agendaDB;

  @override
  void initState(){
    super.initState();
    agendaDB = AgendaDB();
    if(widget.taskModel != null){
      txtConName.text = widget.taskModel!.nombreTarea!;
      txtConDsc.text = widget.taskModel!.descTarea!;
      switch(widget.taskModel!.estadoTarea){
        case 'E': dropDownValue = "En proceso"; break;
        case 'C': dropDownValue = "Completo"; break;
        case 'P': dropDownValue = "Pendiente";
      }
    }
  }

  @override
  Widget build(BuildContext context){
    final txtNameTask = TextFormField(
      decoration: const InputDecoration(
        label: Text('Tarea'),
        border: OutlineInputBorder()
      ),
      controller: txtConName,
    );

    final txtDscTask = TextFormField(
      decoration: const InputDecoration(
        label: Text('Descripción'),
        border: OutlineInputBorder()
      ),
      maxLines: 6,
      controller: txtConDsc,
    );

    final space = SizedBox(
      height: 10,
    );

    final DropdownButton ddBStatus = DropdownButton(
      value: dropDownValue,
      items: dropDownValues.map(
        (status) => DropdownMenuItem(
          value: status,
          child: Text(status)
        )
      ).toList(),
      onChanged: (value){
        dropDownValue = value;
        setState(() { });
      }
    );

    final ElevatedButton btnGuardar = 
      ElevatedButton(
        onPressed: (){
          if (widget.tareaModel == null){
            agendaDB!.INSERT('tblTareas', {
              'nombreTarea' : txtConName.text,
              'descTarea' : txtConDsc.text,
              'estadoTarea' : dropDownValue!.substring(0,1)
            }).then((value){
              var msj = ( value > 0)
                ? 'La inserción fue exitosa'
                : 'Ocurrió un error';
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pop(context);
            });
          }
          else{
            agendaDB!.UPDATE('tblTareas', {
              'idTarea' : widget.tareaModel!.idTarea,
              'nombreTarea' : txtConName.text,
              'descTarea' : txtConDsc.text,
              'estadoTarea' : dropDownValue!.substring(0,1)
            }).then((value){
              GlobalValues.flagTask.value = !GlobalValues.flagTask.value;
              var msj = (value > 0)
                ? 'La actualización fue exitosa'
                : 'Ocurrió un error';
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pop(context);
            });
          }
        }, 
        child: Text('Guardar Tarea')
      );

    return Scaffold(
      appBar: AppBar(
        title: widget.tareaModel == null
          ? Text('Agregar tarea')
          : Text('Actualizar tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
          txtNameTask,
          space,
          txtDscTask,
          space,
          ddBStatus,
          space,
          btnGuardar
          ],
        ),
      ),
    );
  }
}