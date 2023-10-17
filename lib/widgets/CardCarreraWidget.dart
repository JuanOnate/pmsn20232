import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/carrera_model.dart';
import 'package:pmsn20232/screens/pr4_add_carrera.dart';

class CardCarreraWidget extends StatelessWidget {
  CardCarreraWidget(
    {super.key, required this.carreraModel, this.agendaDB}
  );

  CarreraModel carreraModel;
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
          Expanded(
            child: 
              Column(
                children: [
                  Text(carreraModel.nomCarrera!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,)
                ],
              ),
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
                    builder: (context) => PR4AddCarrera(carreraModel: carreraModel)
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
                        content: Text('¿Deseas borrar la carrera?'),
                        actions: [
                          TextButton(
                            onPressed: (){
                              agendaDB!.DELETE4('tblCarrera', 'idCarrera',carreraModel.idCarrera!).then((value){
                                Navigator.pop(context);
                                GlobalValues.flagPR4Carrera.value = !GlobalValues.flagPR4Carrera.value;
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