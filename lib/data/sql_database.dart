import 'dart:convert';

import 'package:birthday_reminder/data/shared_prefs.dart';
import 'package:birthday_reminder/main.dart';
import 'package:birthday_reminder/model/birthday_model.dart';
import 'package:birthday_reminder/repository/birthday_main.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';

const String TABLE_NAME = "birthdays";
const String DATABASE_NAME = "birthday_reminder.db";
const String COLUMN_NAME_OF_PERSON = "nameOfPerson";
const String COLUMN_DATE_OF_BIRTHDAY = "dateOfBirthday";
const String COLUMN_A_MESSAGE_FOR_PERSON = "aMessageForPerson";
const String COLUMN_UNIQUE_ID = "uniqueId";

class SQLDataBase {
  Database _database;

  Future<void> initDatabase() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), DATABASE_NAME),
        version: 1,
        onCreate: (db, version) {
          return db.execute(
              "CREATE TABLE $TABLE_NAME($COLUMN_UNIQUE_ID INTEGER, $COLUMN_A_MESSAGE_FOR_PERSON TEXT, $COLUMN_NAME_OF_PERSON TEXT, $COLUMN_DATE_OF_BIRTHDAY TEXT)");
        },
      );
    }
  }

  Future<void> insertBirthDay(BirthDay birthDay) async {
    await initDatabase();
    int index = await _database.insert(
      TABLE_NAME,
      birthDay.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Got index for the Birthday : $index");
    BirthDay newBirthDay = BirthDay(
        uniqueId: index,
        aMessageForPerson: birthDay.aMessageForPerson,
        dateOfBirthday: birthDay.dateOfBirthday,
        nameOfPerson: birthDay.nameOfPerson);

    await updateBirthDay(newBirthDay);
  }

  Future<void> updateBirthDay(BirthDay birthDay) async {
    localAppState.addItemToLocalAppState(birthDay);
    await _database.update(
      TABLE_NAME,
      birthDay.toMap(),
      where: "$COLUMN_DATE_OF_BIRTHDAY = ? and $COLUMN_NAME_OF_PERSON = ?",
      conflictAlgorithm: ConflictAlgorithm.replace,
      whereArgs: [
        birthDay.dateOfBirthday.millisecondsSinceEpoch,
        birthDay.nameOfPerson
      ],
    );

    mainPlatform
        .invokeMethod("addBirthDay", {'map': json.encode(birthDay.toMap())});

        await sharedPrefsObject.initDataBase();
        sharedPrefsObject.setBoolFromSharedPrefs("showDemo", false);
  }

  addBirthdayFromIndex(BirthDay birthDay) async {
    localAppState.addItemToLocalAppState(birthDay);
    await _database.insert(
      TABLE_NAME,
      birthDay.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteBirthDay(int uniqueId) async {
    localAppState.removeItemFromLocalAppState(uniqueId);
    int val = await _database.delete(
      TABLE_NAME,
      where: "$COLUMN_UNIQUE_ID = ?",
      whereArgs: [uniqueId],
    );

    return val;
  }

  void deletePermanently(int uniqueId) {
    deleteBirthDay(uniqueId);
    mainPlatform.invokeMethod("disableAlarm", {"uniqueId": uniqueId});
  }

  Future<List<BirthDay>> getDataForDisplaying() async {
    List<BirthDay> finalList = List();
    List<Map<String, dynamic>> list = await _database.query(TABLE_NAME);
    print(list.toString());
    for (var a in list) {
      finalList.add(BirthDay.fromJson(a));
    }
    return finalList;
  }

  Future<List> getDataForRestartingTimers() {
    return _database.query(TABLE_NAME);
  }
}

SQLDataBase dataBase = SQLDataBase();
