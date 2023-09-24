import 'package:flutter/material.dart';
import 'package:pmsn20232/database/agenda_db.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String dropDownValue = "Pendiente";
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
          agendaDB!.INSERT('tblTareas', {
            'nombreTarea' : txtConName.text,
            'descTarea' : txtConDsc.text,
            'estadoTarea' : dropDownValue.substring(1,1)
          }).then((value) {
            var msj = (value > 0 )
            ? 'La insersión fue exitosa'
            : 'OCurrió un error';
            var snackbar = SnackBar(content: Text(msj));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            Navigator.pop(context);
          });
        }, 
        child: Text('Guardar Tarea')
      );

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Tarea'),
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