import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/profe_model.dart';
import 'package:pmsn20232/models/task_model.dart';

class PR4AddTask extends StatefulWidget {
  PR4AddTask({super.key,this.taskModel});

  TaskModel? taskModel;

  @override
  State<PR4AddTask> createState() => _PR4AddTaskState();
}

class _PR4AddTaskState extends State<PR4AddTask> {

  //final _formKey = GlobalKey<FormState>();
  TextEditingController taskNameController = TextEditingController();
  DateTime? expiracionDate;
  DateTime? recordatorioDate;
  TextEditingController taskDescController = TextEditingController();
  int? selectedTaskStatus;
  int? selectedIDProfesor;
  List<TaskStatus> taskStatusList = [
    TaskStatus(0, 'Pendiente'),
    TaskStatus(1, 'Completada'),
  ];
  List<ProfeModel> profesores = [];

  AgendaDB? agendaDB;

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
    if (widget.taskModel != null) {
      taskNameController.text = widget.taskModel!.nomTask!;
      expiracionDate = widget.taskModel?.fecExpiracion;
      recordatorioDate = widget.taskModel?.fecRecordatorio;
      taskDescController.text = widget.taskModel!.desTask!;
      selectedTaskStatus = widget.taskModel?.realizada;
      selectedIDProfesor = widget.taskModel?.idProfe;
    }
  }

  void alerta(String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alerta Tarea'),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final txtNameTask = TextFormField(
      decoration: const InputDecoration(
        label: Text('Tarea'),
        border: OutlineInputBorder()
      ),
      controller: taskNameController,
    );

    final txtDescTask = TextFormField(
      decoration: const InputDecoration(
        label: Text('Descripcion'),
        border: OutlineInputBorder()
      ),
      controller: taskDescController,
    );

    final space = SizedBox(
      height: 10,
    );

    final ElevatedButton btnGuardar = ElevatedButton(
      onPressed: (){
        if(taskNameController.text.isEmpty || taskNameController.text.trim().isEmpty){//nombre vacio
          alerta('El nombre de la Tarea no puede estar vacío');
        }else{
          if(taskNameController.text.length > 100){//nombre muy largo
            alerta('El nombre de la Tarea es muy largo');
          }else{
            if(expiracionDate == null){//fecha expiracion nula
              alerta('Se debe elegir una fecha de expiración');
            }else{
              if(recordatorioDate == null){//fecha de recordatorio nula
                alerta('Se debe elegir una fecha de recordatorio');
              }else{
                if(taskDescController.text.isEmpty || taskDescController.text.trim().isEmpty){//descripcion vacia
                  alerta('La descripción de la Tarea no puede estar vacía');
                }else{
                  if(selectedTaskStatus == null){//estado vacío
                    alerta('Se debe seleccionar un estado de la Tarea');
                  }else{
                    if(selectedIDProfesor == null){//profesor vacío
                      alerta('Se debe seleccionar un profesor');
                    }else{
                      if (widget.taskModel == null){
                        agendaDB!.INSERT('tblTask', {
                          'nomTask' : taskNameController.text,
                          'fecExpiracion' : expiracionDate!.toIso8601String(),
                          'fecRecordatorio' : recordatorioDate!.toIso8601String(),
                          'desTask' : taskDescController.text,
                          'realizada' : selectedTaskStatus,
                          'idProfe' : selectedIDProfesor,
                        }).then((value){
                          print(recordatorioDate);
                          var msj = (value > 0)
                            ? 'La inserción fue exitosa'
                            : 'Ocurrió un error';
                          var snackbar = SnackBar(content: Text(msj));
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          Navigator.pop(context);
                        });
                      }
                      else{
                        agendaDB!.UPDATE4('tblTask',{
                          'idTask' : widget.taskModel!.idTask,
                          'nomTask' : taskNameController.text,
                          'fecExpiracion' : expiracionDate!.toIso8601String(),
                          'fecRecordatorio' : recordatorioDate!.toIso8601String(),
                          'desTask' : taskDescController.text,
                          'realizada' : selectedTaskStatus,
                          'idProfe' : selectedIDProfesor,
                        },'idTask', widget.taskModel!.idTask!).then((value){
                          GlobalValues.flagPR4Task.value = !GlobalValues.flagPR4Task.value;
                          var msj = (value > 0)
                            ? 'La actualización fue exitosa'
                            : 'Ocurrió un error';
                          var snackbar = SnackBar(content: Text(msj));
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          Navigator.pop(context);
                        });
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }, 
      child: Text('Guardar Tarea')
    );
    
    return Scaffold(
      appBar: AppBar(
        title: widget.taskModel == null 
        ? Text('Agregar Tarea') 
        : Text('Editar Tarea'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              txtNameTask,
              space,
              DateTimePicker(
                labelText: 'Fecha de Expiración',
                selectedDate: expiracionDate ?? DateTime.now(),
                onDateSelected: (date) {
                  setState(() {
                    expiracionDate = date;
                  });
                },
              ),
              space,
              DateTimePicker(
                labelText: 'Fecha de Recordatorio',
                selectedDate: recordatorioDate ?? DateTime.now(),
                onDateSelected: (date) {
                  setState(() {
                    recordatorioDate = date;
                  });
                },
              ),
              space,
              txtDescTask,
              space,
              DropdownButtonFormField<int>(
                  value: selectedTaskStatus,
                  items: taskStatusList.map((status) {
                    return DropdownMenuItem<int>(
                      value: status.value,
                      child: Text(status.label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTaskStatus = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Estado',
                  ),
                ),
                space,
                FutureBuilder<List<ProfeModel>>(
                  future: agendaDB!.GETALLPROFESORES(), 
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done){  
                      if(snapshot.hasData){
                        profesores = snapshot.data!;
                        return IntrinsicWidth(
                          child: DropdownButtonFormField<int>(
                            value: selectedIDProfesor,
                            items: profesores.map((profesor){
                              return DropdownMenuItem<int>(
                                value: profesor.idProfe,
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 310),
                                  child: Text(profesor.nomProfe!, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                              );
                            }).toList(),
                            onChanged: (value){
                              setState(() {
                                selectedIDProfesor = value;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Profesor'
                            ),
                          ),
                        );
                      }else{
                        return const Text('No se encontraron profesores');
                      }
                    }else{
                      return CircularProgressIndicator();
                    }
                  },
                ),
                space,
                btnGuardar
            ],
          ),
        ),
      ),
    );
  }
}

class TaskStatus {
  final int value;
  final String label;

  TaskStatus(this.value, this.label);
}

class DateTimePicker extends StatelessWidget {
  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  DateTimePicker({
    required this.labelText,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          labelText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2123),
            ).then((date) {
              if (date != null) {
                onDateSelected(date);
              }
            });
          },
          child: Text(
            selectedDate.toLocal().toString().split(' ')[0],
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
