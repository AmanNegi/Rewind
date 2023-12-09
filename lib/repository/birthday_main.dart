import 'package:birthday_reminder/data/sql_database.dart';
import 'package:birthday_reminder/model/birthday_model.dart';
import 'package:flutter/cupertino.dart';

class LocalAppState extends ChangeNotifier {
  ValueNotifier<List<BirthDay>> mainList = ValueNotifier(List());

  LocalAppState() {
    initList();
  }

  initList() async {
    await dataBase.initDatabase();
    mainList.value = await dataBase.getDataForDisplaying();
    mainList.value.sort((a, b) {
      return a.dateOfBirthday.compareTo(b.dateOfBirthday);
    });
    mainList.notifyListeners();
  }

  addItemToLocalAppState(BirthDay birthDay) {
    mainList.value.add(birthDay);
    mainList.value.sort((a, b) {
      return a.dateOfBirthday.compareTo(b.dateOfBirthday);
    });
    mainList.notifyListeners();
  }

  removeItemFromLocalAppState(int index) {
    print(" in removeAppFromLocalState : \n" + mainList.value.toString());
    for (int i = 0; i < mainList.value.length; i++) {
      if (mainList.value[i].uniqueId == index) {
        mainList.value.removeAt(i);
      }
    }
    mainList.notifyListeners();
  }
}

LocalAppState localAppState = LocalAppState();
