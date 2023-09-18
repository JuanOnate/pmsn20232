/*import 'package:flutter/material.dart';

void main() {
  runApp( MainApp());
}

class MainApp extends StatefulWidget { //ctrl + .   = cambiar stateless widget a stateful widget
   MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState(); //el atributo/clase/elemento es privado con un guion bajo
}

class _MainAppState extends State<MainApp> {
  int contador = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //backgroundColor: Colors.green,
        //body: Center(
        //  child: Text('Hello World!' , style: TextStyle(fontSize: 30, color: Colors.black)),
        body: Center(
          child: Text('Contador de Clicks $contador', style: TextStyle(fontSize: 30),) //interpolacion con $variable ó ${objeto.propiedad}
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.plus_one, color: Color.fromARGB(255, 123, 83, 131),), //manera de accesar a los iconos predetermiandos
          onPressed: (){
            contador++;
            print(contador);
            setState(() {}); //esta linea indica que todo lo de build se vuelve a renderizar
          }
        ),
      ),
    );
  }
}
*/
//en pub.dev hay muchas cosas que se pueden implementar a las aplicaciones son widgets que van dentro del scaffold

/* STATELESS WIDGET
void main() {
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
   MainApp({super.key});

  int contador = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //backgroundColor: Colors.green,
        //body: Center(
        //  child: Text('Hello World!' , style: TextStyle(fontSize: 30, color: Colors.black)),
        body: Center(
          child: Text('Contador de Clicks $contador', style: TextStyle(fontSize: 30),) //interpolacion con $variable ó ${objeto.propiedad}
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.plus_one, color: Color.fromARGB(255, 123, 83, 131),), //manera de accesar a los iconos predetermiandos
          onPressed: (){
            contador++;
            print(contador);
          }
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/assets/styles_app.dart';
import 'package:pmsn20232/routes.dart';
import 'package:pmsn20232/screens/dashboard_screen.dart';
import 'package:pmsn20232/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalValues.configPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    GlobalValues.flagTheme.value = GlobalValues.prefsTema.getBool('tema') ?? false;
    return ValueListenableBuilder(
      valueListenable: GlobalValues.flagTheme,
      builder: (context, value, _) {
        return MaterialApp(
          home: GlobalValues.prefsSesion.getBool('cbSesion') ?? false
            ? DashboardScreen()
            : const LoginScreen(),
          routes: getRoutes(),
          //theme: ThemeData.dark(),
          theme: value 
            ? StylesApp.darkTheme(context)
            : StylesApp.lightTheme(context)
        );
      }
    );
  }
}