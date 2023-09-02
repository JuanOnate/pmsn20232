import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pmsn20232/screens/card_itc.dart';

class AboutITC extends StatelessWidget {
  const AboutITC({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget{
   Home({super.key});
  
  final data =  [
    CardITCData(
      title: "ITCelaya", 
      subtitle: "La mejor institución", 
      image: const AssetImage("assets/images/img-1.png"), 
      backgroundColor: const Color.fromARGB(255, 71, 220, 124), 
      titleColor: const Color.fromARGB(255, 220, 71, 168), 
      subtitleColor: const Color.fromARGB(255, 220, 71, 168),
      fondo: LottieBuilder.asset("assets/animation/animation-1.json")
      ),
    CardITCData(
      title: "Ingeniería en Sistemas Computacionales", 
      subtitle: "La mejor carrera", 
      image: const AssetImage("assets/images/img-2.png"), 
      backgroundColor: const Color.fromARGB(255, 209, 220, 71), 
      titleColor: const Color.fromARGB(255, 81, 71, 220), 
      subtitleColor: const Color.fromARGB(255, 81, 71, 220),
      fondo: LottieBuilder.asset("assets/animation/animation-1.json")
      ),
    CardITCData(
      title: "Instalaciones", 
      subtitle: "Las mejores de Celaya", 
      image: const AssetImage("assets/images/img-3.png"), 
      backgroundColor: const  Color.fromARGB(255, 220, 103, 71), 
      titleColor: const Color.fromARGB(255, 71, 188, 220), 
      subtitleColor: const Color.fromARGB(255, 71, 188, 220),
      fondo: LottieBuilder.asset("assets/animation/animation-1.json")
      ),
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