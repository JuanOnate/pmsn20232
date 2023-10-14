import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/profe_model.dart';
import 'package:pmsn20232/models/task_model.dart';

class PR4AddTask extends StatefulWidget {
  final TaskModel? task;

  PR4AddTask({this.task});

  @override
  _PR4AddTaskState createState() => _PR4AddTaskState();
}

class _PR4AddTaskState extends State<PR4AddTask> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskNameController = TextEditingController();
  DateTime? _expiracionDate;
  DateTime? _recordatorioDate;
  final TextEditingController _taskDescController = TextEditingController();
  int? _selectedTaskStatus;
  int? _selectedProfesorId;
  List<TaskStatus> _taskStatusList = [
    TaskStatus(0, 'Pendiente'),
    TaskStatus(1, 'En proceso'),
    TaskStatus(2, 'Completada'),
  ];
  List<ProfeModel> _profesores = [];

  @override
  void initState() {
    super.initState();
    _loadProfesores();
    if (widget.task != null) {
      _taskNameController.text = widget.task!.nomTask!;
      _expiracionDate = widget.task!.fecExpiracion;
      _recordatorioDate = widget.task!.fecRecordatorio;
      _taskDescController.text = widget.task!.desTask!;
      _selectedTaskStatus = widget.task!.realizada;
      _selectedProfesorId = widget.task!.idProfe;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Agregar Tarea' : 'Editar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _taskNameController,
                decoration: InputDecoration(labelText: 'Nombre de la Tarea'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese un nombre para la tarea.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DateTimePicker(
                labelText: 'Fecha de Expiración',
                selectedDate: _expiracionDate!,
                onDateSelected: (date) {
                  setState(() {
                    _expiracionDate = date;
                  });
                },
              ),
              SizedBox(height: 16.0),
              DateTimePicker(
                labelText: 'Fecha de Recordatorio',
                selectedDate: _recordatorioDate!,
                onDateSelected: (date) {
                  setState(() {
                    _recordatorioDate = date;
                  });
                },
              ),
              TextFormField(
                controller: _taskDescController,
                decoration: InputDecoration(labelText: 'Descripcion de la Tarea'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese una descripcion para la tarea.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                value: _selectedTaskStatus,
                items: _taskStatusList.map((status) {
                  return DropdownMenuItem<int>(
                    value: status.value,
                    child: Text(status.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTaskStatus = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Estado',
                ),
              ),
              DropdownButtonFormField<int>(
                value: _selectedProfesorId,
                items: _profesores.map((profe) {
                  return DropdownMenuItem<int>(
                    value: profe.idProfe,
                    child: Text(profe.nomProfe!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProfesorId = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Profesor',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitTask,
                child: Text('Guardar Tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadProfesores() async {
    List<ProfeModel> profesores = await AgendaDB().GETALLPROFESORES();
    setState(() {
      _profesores = profesores;
    });
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      final task = TaskModel(
        nomTask: _taskNameController.text,
        fecExpiracion: _expiracionDate,
        fecRecordatorio: _recordatorioDate,
        desTask: _taskDescController.text,
        realizada: _selectedTaskStatus,
        idProfe: _selectedProfesorId,
      );

      if (widget.task == null) {
        // Insertar nueva tarea
        AgendaDB().INSERT('tblTask', {
          'nomTask' : _taskNameController.text,
          'fecExpiracion' : _expiracionDate,
          'fecRecordatorio' : _recordatorioDate,
          'desTask' : _taskDescController.text,
          'realizada' : _selectedTaskStatus,
          'idProfe' : _selectedProfesorId,
        }).then((value) {
          var msj = (value > 0)
                ? 'La inserción fue exitosa'
                : 'Ocurrió un error';
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pop(context);
        });
      } else {
        // Actualizar tarea existente
        AgendaDB().UPDATE4('tblTask',{
          'idTask' : widget.task!.idTask,
          'nomTask' : _taskNameController.text,
          'fecExpiracion' : _expiracionDate,
          'fecRecordatorio' : _recordatorioDate,
          'desTask' : _taskDescController.text,
          'realizada' : _selectedTaskStatus,
          'idProfe' : _selectedProfesorId,
        },'idTask', widget.task!.idTask!).then((value) {
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

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
              firstDate: DateTime(2023),
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
