import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/profe_model.dart';
import 'package:pmsn20232/widgets/CardProfeWidget.dart';

class ProfePR4Screen extends StatefulWidget {
  const ProfePR4Screen({super.key});

  @override
  State<ProfePR4Screen> createState() => _ProfePR4ScreenState();
}

class _ProfePR4ScreenState extends State<ProfePR4Screen> {

  AgendaDB? agendaDB;
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin de Profesores'),
        actions: [
          IconButton(
            onPressed: ()=>Navigator.pushNamed(context, '/addProfe').then((value){setState((){});}), 
            icon: const Icon(Icons.hdr_plus_outlined)
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value){
                setState(() {
                  searchTerm = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar profesor...',
              ),
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: GlobalValues.flagPR4Profe,
        builder: (context, value, _){
          return FutureBuilder(
            future: agendaDB!.searchProfesores(searchTerm), 
            builder: (BuildContext context, AsyncSnapshot<List<ProfeModel>> snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index){
                    return CardProfeWidget(
                      profeModel: snapshot.data![index],
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