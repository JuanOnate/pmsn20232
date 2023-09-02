import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ConcentricPageView(
        itemCount: 3,
       colors: const [Colors.white, Colors.blue, Colors.red],
       physics: NeverScrollableScrollPhysics(),
       itemBuilder: (int index) {
         return Container(
         );},
      ),
    );
  }
}