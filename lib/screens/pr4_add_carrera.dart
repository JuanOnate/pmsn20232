import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/carrera_model.dart';

class PR4AddCarrera extends StatefulWidget {
  PR4AddCarrera({super.key, this.carreraModel});

  CarreraModel? carreraModel;

  @override
  State<PR4AddCarrera> createState() => _PR4AddCarreraState();
}

class _PR4AddCarreraState extends State<PR4AddCarrera> {

  TextEditingController txtCarreraName = TextEditingController();

  AgendaDB? agendaDB;

  @override
  void initState(){
    super.initState();
    agendaDB = AgendaDB();
    if(widget.carreraModel != null){
      txtCarreraName.text = widget.carreraModel!.nomCarrera!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final txtNameCarrera = TextFormField(
      decoration: const InputDecoration(
        label: Text('Carrera'),
        border: OutlineInputBorder()
      ),
      controller: txtCarreraName,
    );

    final space = SizedBox(
      height: 10,
    );

    final ElevatedButton btnGuardar = 
      ElevatedButton(
        onPressed: (){
          if (widget.carreraModel == null){
            agendaDB!.INSERT('tblTareas', {
              'nombreTarea' : txtCarreraName.text
            }).then((value){
              var msj = (value > 0)
                ? 'La inserción fue exitosa'
                : 'Ocurrió un error';
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pop(context);
            });
          }
          else{
            agendaDB!.UPDATE4('idCarrera', {
              'idCarrera' : widget.carreraModel!.idCarrera,
              'nomCarrera' : txtCarreraName.text
            }, 'idCarrera', widget.carreraModel!.idCarrera!).then((value){
              GlobalValues.flagPR4Carrera.value = !GlobalValues.flagPR4Carrera.value;
              var msj = (value > 0)
                ? 'La actualización fue exitosa'
                : 'Ocurrió un error';
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pop(context);
            });
          }
        }, 
        child: Text('Guardar carrera')
      );

    return Scaffold(
      appBar: AppBar(
        title: widget.carreraModel == null
          ? Text('Agregar carrera')
          : Text('Actualizar carrera'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
          txtNameCarrera,
          space,
          btnGuardar
          ],
        ),
      ),
    );
  }
}