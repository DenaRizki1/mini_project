// ignore_for_file: file_names

import 'package:mini_project/utils/constans.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setPrefrence(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

//prefrence string get using this function
Future<String?> getPrefrence(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

//prefrence boolean set using this function
setPrefrenceBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

//prefrence boolean get using this function
Future<bool> getPrefrenceBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key) ?? false;
}

Future<void> clearUserSession() async {
  final waitList = <Future<void>>[];

  SharedPreferences prefs = await SharedPreferences.getInstance();
  waitList.add(prefs.setBool(IS_LOGIN, false));
  waitList.add(prefs.remove(HASH_USER));
  waitList.add(prefs.remove(NAMA));

  await prefs.clear();
}
