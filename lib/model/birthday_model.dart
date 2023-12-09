import 'package:flutter/material.dart';

class BirthDay {
  final String nameOfPerson;
  final DateTime dateOfBirthday;
  final String aMessageForPerson;
  final int uniqueId;

  BirthDay(
      {@required this.nameOfPerson,
      @required this.dateOfBirthday,
      @required this.aMessageForPerson,
      @required this.uniqueId,});

  Map<String, dynamic> toMap() {
    return {
      'nameOfPerson': nameOfPerson,
      'dateOfBirthday': dateOfBirthday.millisecondsSinceEpoch,
      'aMessageForPerson': aMessageForPerson,
      'uniqueId': uniqueId,
    };
  }

  factory BirthDay.fromJson(Map json) {
    return BirthDay(
        aMessageForPerson: json['aMessageForPerson'],
        dateOfBirthday: DateTime.fromMillisecondsSinceEpoch(
            int.parse(json['dateOfBirthday'])),
        nameOfPerson: json['nameOfPerson'],
        uniqueId: json['uniqueId'],);
  }
}
