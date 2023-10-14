import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/carrera_model.dart';
import 'package:pmsn20232/widgets/CardCarreraWidget.dart';

class CarreraPR4Screen extends StatefulWidget {
  const CarreraPR4Screen({super.key});

  @override
  State<CarreraPR4Screen> createState() => _CarreraPR4ScreenState();
}

class _CarreraPR4ScreenState extends State<CarreraPR4Screen> {

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
        title: const Text('Admin de Carreras'),
        actions: [
          IconButton(
            onPressed: ()=>Navigator.pushNamed(context, '/addCarrera').then((value){setState((){});}), 
            icon: const Icon(Icons.hdr_plus_outlined)
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: GlobalValues.flagTask,
        builder: (context, value, _){
          return FutureBuilder(
            future: agendaDB!.GETALLCARRERAS(), 
            builder: (BuildContext context, AsyncSnapshot<List<CarreraModel>> snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index){
                    return CardCarreraWidget(
                      carreraModel: snapshot.data![index],
                      agendaDB: agendaDB,
                    );
                  },
                );
              }else{
                if(snapshot.hasError){
                  return const Center(
                    child: Text('Error!'),
                  );
                }else{
                  return CircularProgressIndicator();
                }
              }
            }
          );
        },
      ),
    );
  }
}