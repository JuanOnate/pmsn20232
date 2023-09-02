import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido :)'),
      ),
      drawer: createDrawer(),
    );
  }

  Widget createDrawer(){
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 1.0,
                center: Alignment(-0.7,-0.35),
                colors: [Color.fromARGB(255, 167, 70, 86),Color.fromARGB(255, 46, 46, 46)]
              )
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://static-cdn.jtvnw.net/jtv_user_pictures/dbb60f44-33af-4214-947a-de80c93fb512-profile_image-70x70.png'),
            ),
            accountName: Text('Juan Yañez', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), 
            accountEmail: Text('19030179@itcelaya.edu.mx', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
          ),
          ListTile(
            leading: Image.network('https://www.iconsdb.com/icons/preview/white/peach-xxl.png'),
            trailing: Icon(Icons.chevron_right),
            title: Text('FruitApp'),
            subtitle: Text('Carrusel'),
            onTap: (){},
          ),
          ListTile(
            leading: Image.network('https://www.homestaynetwork.org/wp-content/uploads/2016/05/school-icon.png'),
            trailing: Icon(Icons.chevron_right),
            title: Text('Institución'),
            subtitle: Text('Acerca de'),
            onTap: (){},
          )
        ],
      ),
    );
  }

}