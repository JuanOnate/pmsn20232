import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalValues {
  static ValueNotifier<bool> flagTheme = ValueNotifier<bool>(true);

  static late SharedPreferences prefs;

  static Future<void> configPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
}