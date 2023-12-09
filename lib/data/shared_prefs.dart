import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences sharedPrefs;

  Future initDataBase() async {
    if (sharedPrefs == null) {
      sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  getBoolFromSharedPrefs(String key) {
    return sharedPrefs.getBool(key);
  }

  setBoolFromSharedPrefs(String key, bool value) {
    sharedPrefs.setBool(key, value);
  }

  bool checkIfExists(String key) {
    return sharedPrefs.containsKey(key);
  }
}

SharedPrefs sharedPrefsObject = SharedPrefs();
