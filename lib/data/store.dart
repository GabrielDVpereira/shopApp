import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<void> saveMap(String key, Map<String, dynamic> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  static Future<String> getString(
    String key,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String response = prefs.getString(key);
    return response;
  }

  static Future<Map<String, dynamic>> getMap(
    String key,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String response = prefs.getString(key);
    return json.decode(response);
  }

  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
