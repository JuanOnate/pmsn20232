import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/profe_model.dart';
import 'package:pmsn20232/screens/pr4_add_profe.dart';

class CardProfeWidget extends StatelessWidget {
  CardProfeWidget(
    {super.key, required this.profeModel, this.agendaDB}
  );

  ProfeModel profeModel;
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
              Text(profeModel.nomProfe!)
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
                    builder: (context) => PR4AddProfe(profeModel: profeModel)
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
                        content: Text('¿Deseas borrar el profesor?'),
                        actions: [
                          TextButton(
                            onPressed: (){
                              agendaDB!.DELETE4('tblProfesor', 'idProfe',profeModel.idProfe!).then((value){
                                Navigator.pop(context);
                                GlobalValues.flagPR4Profe.value = !GlobalValues.flagPR4Profe.value;
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