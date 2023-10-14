import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/carrera_model.dart';
import 'package:pmsn20232/models/profe_model.dart';

class PR4AddProfe extends StatefulWidget {
  PR4AddProfe({super.key, this.profeModel});

  ProfeModel? profeModel;

  @override
  State<PR4AddProfe> createState() => _PR4AddProfeState();
}

class _PR4AddProfeState extends State<PR4AddProfe> {

  TextEditingController txtProfeName = TextEditingController();
  TextEditingController txtProfeEmail = TextEditingController();
  int? selectedIDCarrera;
  List<CarreraModel> carreras = [];

  AgendaDB? agendaDB;

  @override
  void initState(){
    super.initState();
    agendaDB = AgendaDB();
    if(widget.profeModel != null){
      txtProfeName.text = widget.profeModel!.nomProfe!;
      txtProfeEmail.text = widget.profeModel!.email!;
      selectedIDCarrera = widget.profeModel!.idCarrera!;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final txtNameProfe = TextFormField(
      decoration: const InputDecoration(
        label: Text('Profesor'),
        border: OutlineInputBorder()
      ),
      controller: txtProfeName,
    );

    final space = SizedBox(
      height: 10,
    );

    final ElevatedButton btnGuardar = 
      ElevatedButton(
        onPressed: (){
          if (widget.profeModel == null){
            agendaDB!.INSERT('tblProfesor', {
              'nomProfe' : txtProfeName.text,
              'email' : txtProfeEmail.text,
              'idCarrera' : selectedIDCarrera,
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
            agendaDB!.UPDATE4('tblProfesor', {
              'idProfe' : widget.profeModel!.idProfe,
              'nomProfe' : txtProfeName.text,
              'email' : txtProfeEmail.text,
              'idCarrera' : selectedIDCarrera,
            }, 'idProfe', widget.profeModel!.idProfe!).then((value){
              GlobalValues.flagPR4Profe.value = !GlobalValues.flagPR4Profe.value;
              var msj = (value > 0)
                ? 'La actualización fue exitosa'
                : 'Ocurrió un error';
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pop(context);
            });
          }
        }, 
        child: Text('Guardar profesor')
      );

    return Scaffold(
      appBar: AppBar(
        title: widget.profeModel == null
          ? Text('Agregar profesor')
          : Text('Actualizar profesor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
          txtNameProfe,
          space,
          FutureBuilder<List<CarreraModel>>(
            future: agendaDB!.GETALLCARRERAS(), 
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  carreras = snapshot.data!;
                  return DropdownButtonFormField<int>(
                    value: selectedIDCarrera,
                    items: carreras.map((carrera){
                      return DropdownMenuItem<int>(
                        value: carrera.idCarrera,
                        child: Text(carrera.nomCarrera!),
                      );
                    }).toList(), 
                    onChanged: (value){
                      setState(() {
                        selectedIDCarrera = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Carrera',
                    ),
                  );
                }else{
                  return const Text('No se encontraron carreras');
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
    );
  }
}