import 'package:flutter/material.dart';

class StylesApp{
  static ThemeData lightTheme(BuildContext context){
    final theme = ThemeData.light();
    return theme.copyWith(
      //primaryColor: Color.fromARGB(255, 131, 42, 72),
      colorScheme:Theme.of(context).colorScheme.copyWith(
        primary: const Color.fromARGB(255, 131, 42, 72)
      ) 
    );
  }
  static ThemeData darkTheme(BuildContext context){
    final theme = ThemeData.dark();
    return theme.copyWith(
      //primaryColor: Color.fromARGB(255, 131, 42, 72),
      colorScheme:Theme.of(context).colorScheme.copyWith(
        primary: const Color.fromARGB(255, 131, 42, 72)
      ) 
    );
  }
}