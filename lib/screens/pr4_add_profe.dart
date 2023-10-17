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

  void alerta(String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alerta Profesor'),
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

  bool isValidEmail(String email) {
    // Expresión regular para validar una dirección de correo electrónico
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
    );

    return emailRegex.hasMatch(email);
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

    final txtEmailProfe = TextFormField(
      decoration: const InputDecoration(
        label: Text('Email'),
        border: OutlineInputBorder()
      ),
      controller: txtProfeEmail,
    );

    final space = SizedBox(
      height: 10,
    );

    final ElevatedButton btnGuardar = 
      ElevatedButton(
        onPressed: (){
          if(txtProfeName.text.isEmpty || txtProfeName.text.trim().isEmpty){//nombre vacio
            alerta('El nombre del Profesor no puede estar vacío');
          }else{
            if(txtProfeName.text.length > 80){//nombre muy largo
              alerta('El nombre del Profesor es muy largo');
            }else{
              if(txtProfeEmail.text.isEmpty || txtProfeEmail.text.trim().isEmpty){//email vacio
                alerta('El correo del Profesor no puede estar vacío');
              }else{
                if(txtProfeEmail.text.length > 50){//correo muy largo
                  alerta('El correo del Profesor es muy largo');
                }else{
                  if(isValidEmail(txtProfeEmail.text)){//email tiene formato de email correo@ejemplo.com
                    if(selectedIDCarrera == null){//carrera vacía
                      alerta('Se debe seleccionar una carrera');
                    }else{
                      if(widget.profeModel == null){
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
                    }
                  }else{
                    alerta('El correo del Profesor no cumple con el formato correo@ejemplo.com');
                  }
                }
              }
            }
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
          txtEmailProfe,
          space,
          FutureBuilder<List<CarreraModel>>(
            future: agendaDB!.GETALLCARRERAS(), 
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  carreras = snapshot.data!;
                  return IntrinsicWidth(
                    child:
                      DropdownButtonFormField<int>(
                        value: selectedIDCarrera,
                        items: carreras.map((carrera){
                          return DropdownMenuItem<int>(
                            value: carrera.idCarrera,
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 310),
                              child: Text(
                                carrera.nomCarrera!, 
                                maxLines: 1, 
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
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