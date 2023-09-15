import 'package:flutter/material.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/tarea_model.dart';

class TareaScreen extends StatefulWidget {
  const TareaScreen({super.key});

  @override
  State<TareaScreen> createState() => _TareaScreenState();
}

class _TareaScreenState extends State<TareaScreen> {

  AgendaDB? agendaDB;

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin de Tareas'),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon(Icons.task))
        ],
      ),
      body: FutureBuilder(
        future: agendaDB!.GETALLTAREAS(), 
        builder: (BuildContext context,
        AsyncSnapshot<List<TareaModel>> snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, index){
                return const Text('Hola');
              });
          }else{
            if(snapshot.hasError){
              return const Center(
                child: Text('Algo malió sal!'),
              );
            }else{
              return CircularProgressIndicator();
            }
          }
        }
      ),
    );
  }
}