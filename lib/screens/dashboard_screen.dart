import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  bool isDarkModeEnabled = true;

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
          DayNightSwitcher(
            isDarkModeEnabled: isDarkModeEnabled,
            onStateChanged: (isDarkModeEnabled) {
              setState(() {
                this.isDarkModeEnabled = isDarkModeEnabled;
              });
            },
          ),
        ],
      ),
    );
  }

}