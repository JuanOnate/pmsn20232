//en el dir 'lib' se crean más directorios para ubicar archivos, estos son: assets, models y screens
//al generar un nuevo archivo escribir 'state' y seleccionar statefulwidget y ponerle el nombre del archivo
//luego mostrará un error que se soluciona haciendo el import de 'material.dart' con ctrl + .

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {

    TextEditingController txtConUser = TextEditingController(); //este es el controlador para recuperar datos de un TextField
    TextEditingController txtConPass = TextEditingController();

    final txtUser = TextField(
      controller: txtConUser, //para recuperar los datos de una caja de texto se usa un controlador
      decoration: const InputDecoration(
        border: OutlineInputBorder()
      ),
    );

    final txtPass = TextField(
      controller: txtConPass,
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder()
        ),
    );

    final imgLogo = Container( //las imagenes de fondo se haecn con un container, estos equivalen a un DIV de web
      width: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://cdn141.picsart.com/284257859018211.png')
        )
      ),
    );

   final btnEntrar = FloatingActionButton.extended(
    backgroundColor: Color.fromARGB(255, 167, 70, 86),
    icon: Icon(Icons.login),
    label: Text('Entrar'),
    onPressed: () => Navigator.pushNamed(context, '/dash')
    );

    return Scaffold( //si la pantalla de la app se muestra en negro es porque no está un Scaffold
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage('https://i.pinimg.com/564x/6e/95/8c/6e958cdf594e661a91b6f50979221269.jpg')
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 200,
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                //color: Colors.grey,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(100, 167, 70, 86),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                    children: [
                    txtUser,
                    const SizedBox(height: 10),
                    txtPass
                  ],
                ),
              ),
              imgLogo,
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: btnEntrar, //para el body se trabaja con stack, poner elementos arriba de otros, el inicial va hasta abajo
    );
  }
}