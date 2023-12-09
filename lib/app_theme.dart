import 'package:flutter/material.dart';
import './data/shared_prefs.dart';

ValueNotifier<bool> appTheme = ValueNotifier(false);

toggleDarkTheme(value) {
  appTheme.value = value;
  saveToSharedPrefs(value);
}

saveToSharedPrefs(bool value) {
  sharedPrefsObject.setBoolFromSharedPrefs("isDarkMode", value);
}

getFromSharedPrefs() {
  sharedPrefsObject.initDataBase();
  if (sharedPrefsObject.checkIfExists("isDarkMode")) {
    if (sharedPrefsObject.getBoolFromSharedPrefs("isDarkMode")) {
      return true;
    }
    return false;
  }
  return false;
}
