import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/carrera_model.dart';
import 'package:pmsn20232/models/profe_model.dart';
import 'package:pmsn20232/screens/pr4_add_profe.dart';

class CardProfeWidget extends StatefulWidget {
  CardProfeWidget({
    super.key,
    required this.profeModel,
    this.agendaDB,
  });

  final ProfeModel profeModel;
  final AgendaDB? agendaDB;

  @override
  _CardProfeWidgetState createState() => _CardProfeWidgetState();
}

class _CardProfeWidgetState extends State<CardProfeWidget> {
  List<CarreraModel> carreras = [];

  @override
  void initState() {
    super.initState();
    _loadCarreras();
  }

  Future<void> _loadCarreras() async {
    final carrerasList = await widget.agendaDB?.GETALLCARRERAS();
    if (carrerasList != null) {
      setState(() {
        carreras = carrerasList;
      });
    }
  }

  String getCarreraName(int idCarrera) {
    final carrera = carreras.firstWhere(
      (carrera) => carrera.idCarrera == idCarrera,
      orElse: () => CarreraModel(nomCarrera: 'Carrera no encontrada'),
    );
    return carrera.nomCarrera!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.green,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  widget.profeModel.nomProfe!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.profeModel.email!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  getCarreraName(widget.profeModel.idCarrera!),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PR4AddProfe(profeModel: widget.profeModel),
                  ),
                ),
                child: Icon(Icons.border_color_rounded),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Mensaje del sistema'),
                        content: Text('¿Deseas borrar el profesor?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              widget.agendaDB!.DELETE4('tblProfesor', 'idProfe', widget.profeModel.idProfe!).then((value) {
                                Navigator.pop(context);
                                GlobalValues.flagPR4Profe.value = !GlobalValues.flagPR4Profe.value;
                              });
                            },
                            child: Text('Si'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('No'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
