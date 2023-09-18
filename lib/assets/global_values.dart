import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalValues {
  static ValueNotifier<bool> flagTheme = ValueNotifier<bool>(true);

  static late SharedPreferences prefsTema;
  static late SharedPreferences prefsSesion;

  static Future<void> configPrefs() async {
    prefsTema = await SharedPreferences.getInstance();
    prefsSesion = await SharedPreferences.getInstance();
  }
}