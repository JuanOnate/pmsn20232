import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //bool isDarkModeEnabled = true;

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
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/333'),
            ),
            accountName: Text('D4FT'), 
            accountEmail: Text('d4ftl0l@gmail.com')
          ),
          ListTile(
            //leading: Image.network('https://cdn0.iconfinder.com/data/icons/delicious-food-here-nolan-style/100/a-15-512.png'),
            leading: Image.asset('assets/icon_orange.png'),
            trailing: Icon(Icons.chevron_right),
            title: Text('FruitApp'),
            subtitle: Text('Carrusel'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.task_alt_outlined),
            trailing: Icon(Icons.chevron_right),
            title: Text('Admin de tareas'),
            onTap: () => Navigator.pushNamed(context, '/tarea'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: DayNightSwitcher(    
              isDarkModeEnabled: GlobalValues.flagTheme.value,
              onStateChanged: (isDarkModeEnabled) {
                GlobalValues.prefs.setBool('tema', isDarkModeEnabled);
                GlobalValues.flagTheme.value = isDarkModeEnabled;
              },
            ),
          ),
        ],
      ),
    );
  }
}