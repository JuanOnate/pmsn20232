import 'package:flutter/widgets.dart';
import 'package:pmsn20232/screens/add_task.dart';
import 'package:pmsn20232/screens/dashboard_screen.dart';
import 'package:pmsn20232/screens/popular_screen.dart';
import 'package:pmsn20232/screens/tarea_pr4_screen.dart';
import 'package:pmsn20232/screens/tarea_screen.dart';

Map<String, WidgetBuilder> getRoutes(){
  return{
    '/dash' : (BuildContext context) => DashboardScreen(),
    '/tarea' : (BuildContext context) => TareaScreen(),
    '/add' : (BuildContext context) => AddTask(),
    '/popular' : (BuildContext context) => PopularScreen(),
    '/pr4' : (BuildContext context) => TareaPR4Screen(),
  };
}