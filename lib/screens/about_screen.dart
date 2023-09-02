import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:pmsn20232/screens/card_itc.dart';

class AboutITC extends StatelessWidget {
  const AboutITC({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget{
  const Home({super.key});
  
  final data = const [
    CardITCData(
      title: "ITCelaya", 
      subtitle: "La mejor institución", 
      image: AssetImage("assets/images/img-1.png"), 
      backgroundColor:  Color.fromARGB(255, 71, 220, 124), 
      titleColor: Color.fromARGB(255, 220, 71, 168), 
      subtitleColor: Color.fromARGB(255, 220, 71, 168)),
    CardITCData(
      title: "Ingeniería en Sistemas Computacionales", 
      subtitle: "La mejor carrera", 
      image: AssetImage("assets/images/img-2.png"), 
      backgroundColor:  Color.fromARGB(255, 209, 220, 71), 
      titleColor:  Color.fromARGB(255, 81, 71, 220), 
      subtitleColor:  Color.fromARGB(255, 81, 71, 220)),
    CardITCData(
      title: "Instalaciones", 
      subtitle: "Las mejores de Celaya", 
      image: AssetImage("assets/images/img-3.png"), 
      backgroundColor:  Color.fromARGB(255, 220, 103, 71), 
      titleColor:  Color.fromARGB(255, 71, 188, 220), 
      subtitleColor:  Color.fromARGB(255, 71, 188, 220))
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ConcentricPageView(
        itemCount: 3,
       colors: data.map((e) => e.backgroundColor).toList(),
       itemBuilder: (int index) {
         return CardITC(
          data: data[index],
         );},
      ),
    );
  }
}