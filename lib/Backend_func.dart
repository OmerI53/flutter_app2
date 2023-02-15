import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui';

Map excelReadManuel(var file, String p1, String p2) {
  //Rows -> X ; Collums ->Y

  var Data = new Map();
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  var sheet = excel[excel.getDefaultSheet()!];

  var c1 = sheet.cell(CellIndex.indexByString(p1));
  var c2 = sheet.cell(CellIndex.indexByString(p2));

  int a1 = c1.colIndex;
  int b1 = c2.colIndex;
  int y = c1.rowIndex;

  for (int i = y; i < sheet.maxRows; i++) {
    var cell1 = sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: a1, rowIndex: i))
        .value;

    var cell2 = sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: b1, rowIndex: i))
        .value;
    //print("$cell1: $cell2");
    if (cell1 != null) {
      Data.update(
        cell1,
        (value) => Data[cell1] + cell2,
        ifAbsent: () => cell2,
      );
    }
  }
  return Data;
}

Map excelReadManuelCord(var file, int a1, int b1, int y1) {
  //Rows -> X ; Collums ->Y

  var Data = new Map();
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  var sheet = excel[excel.getDefaultSheet()!];
  for (int i = y1; i < sheet.maxRows; i++) {
    var cell1 = sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: a1, rowIndex: i))
        .value;

    var cell2 = sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: b1, rowIndex: i))
        .value;
    //print("$cell1: $cell2");
    if (cell1 != null) {
      Data.update(
        cell1,
        (value) => Data[cell1] + cell2,
        ifAbsent: () => cell2,
      );
    }
  }
  return Data;
}

void PrintData(Map data) {
  for (var key in data.keys) {
    var val = data[key];
    print("$key : $val");
  }
}

void excelWriteManuel(var file, Map data, String p1, String p2) {
  //Rows -> X ; Collums ->Y

  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  var sheet = excel[excel.getDefaultSheet()!];

  var c1 = sheet.cell(CellIndex.indexByString(p1));

  int a2 = c1.colIndex;
  int a22 = c1.rowIndex;

  var c2 = sheet.cell(CellIndex.indexByString(p2));

  int b2 = c2.colIndex;
  int b22 = c2.rowIndex;

  for (var key in data.keys) {
    //print("$key: ${data[key]}");
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: a2, rowIndex: a22))
        .value = key.toString();
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: b2, rowIndex: b22))
        .value = data[key];
    a22++;
    b22++;
  }

  List<int>? saved = excel.save(); //can use excel.encode() at write as byte
  if (saved != null) {
    File(join(file))
      ..createSync(recursive: true)
      ..writeAsBytesSync(saved);
  }
}

Map excelReadAuto(var file, String format) {
  var data = {};

  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  var sheet = excel[excel.getDefaultSheet()!];

  int durakIndex = 0;
  int komisyonIndex = 0;

  int plakaIndex = 0;
  int biletIndex = 0;
  int servisIndex = 0;

  for (int i = 0; i < sheet.maxCols; i++) {
    var cell0 = sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        .value;

    //print("$i:$cell0");
    if (cell0 == "Durak") {
      durakIndex = i;
    }
    if (cell0 == "Kom.Tutarı") {
      komisyonIndex = i;
    }
    if (cell0 == "Plaka") {
      plakaIndex = i;
    }
    if (cell0 == "Bilet Tutarı") {
      biletIndex = i;
    }
    if (cell0 == "Servis") {
      servisIndex = i;
    }
  }
  if (format == "Yazhane") {
    //print("durak index :$durakIndex, komisyonindex : $komisyonIndex");
    data = excelReadManuelCord(file, durakIndex, komisyonIndex - 1, 1);
  }
  if (format == "Otobüs") {
    //var data2 = Map();
    for (int i = 1; i < sheet.maxRows; i++) {
      bool isSamsun = false;
      var plaka = sheet
          .cell(
              CellIndex.indexByColumnRow(columnIndex: plakaIndex, rowIndex: i))
          .value;

      var bilet = sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: biletIndex - 1, rowIndex: i))
          .value;
      var durak = sheet
          .cell(
              CellIndex.indexByColumnRow(columnIndex: durakIndex, rowIndex: i))
          .value;
      var servis = sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: servisIndex - 2, rowIndex: i))
          .value;
      if (durak == "SAMSUN") {
        isSamsun = true;
      }

      //print("$plaka: $servis");

      if (plaka != null) {
        data.update(
          plaka,
          (value) => isSamsun
              ? data[plaka] + (bilet * 0.75 - servis)
              : data[plaka] + (bilet * 0.80 - servis),
          ifAbsent: () =>
              isSamsun ? bilet * 0.75 - servis : bilet * 0.80 - servis,
        );
      }
      //data = data2;
    }
  }
  return data;
}

List getSistemFile(String sistemFile) {
  var bytes = File(sistemFile).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  var sheet = excel[excel.getDefaultSheet()!];

  List infoList = [];
  int userIndex = 0;
  int durakIndex = 0;
  int dateIndex = 0;
  int infoIndex = 0;
  int totalIndex = 0;

  for (int i = 0; i < sheet.row(0).length; i++) {
    var cell1 = sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1))
        .value;
    //print(cell1);
    if (cell1 == "Şube") {
      durakIndex = i;
    }
    if (cell1 == "Tarih") {
      dateIndex = i;
    }
    if (cell1 == "Tutar") {
      totalIndex = i;
    }
    if (cell1 == "Kullanıcı") {
      userIndex = i;
    }
    if (cell1 == "Açıklama") {
      infoIndex = i;
    }
  }
  for (int i = 0; i < sheet.maxRows; i++) {
    String infoString = "";
    var userCell = sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: userIndex, rowIndex: i))
        .value;
    //print(userCell);
    if (userCell == "MUHARREM" || userCell == "ÇİĞDEM 20") {
      String infoCell = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: infoIndex, rowIndex: i))
          .value;
      var durakCell = sheet
          .cell(
              CellIndex.indexByColumnRow(columnIndex: durakIndex, rowIndex: i))
          .value;
      var dateCell = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: dateIndex, rowIndex: i))
          .value;

      var totalCell = sheet
          .cell(
              CellIndex.indexByColumnRow(columnIndex: totalIndex, rowIndex: i))
          .value;

      infoString += "$durakCell - $dateCell - $totalCell - $infoCell";
      //print(infoString + "\n");
      infoList.add(infoString);
    }
  }
  return infoList;
}

List getBankFile(String bankFile) {
  var bytes = File(bankFile).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  var sheet = excel[excel.getDefaultSheet()!];

  List infoList = [];
  int dateTimeIndex = 0;
  int totalIndex = 0;
  int infoIndex = 0;

  for (int i = 0; i < sheet.row(0).length; i++) {
    var cell1 = sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        .value;

    if (cell1 == "Tarih/Saat") {
      dateTimeIndex = i;
    }
    if (cell1 == "İşlem Tutarı*") {
      totalIndex = i;
    }
    if (cell1 == "Açıklama") {
      infoIndex = i;
    }
  }

  print("$dateTimeIndex - $totalIndex - $infoIndex");

  for (int i = 1; i < sheet.maxRows; i++) {
    String infoString = "";

    var dateTimeCell = sheet
        .cell(
            CellIndex.indexByColumnRow(columnIndex: dateTimeIndex, rowIndex: i))
        .value;
    var totalCell = sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: totalIndex, rowIndex: i))
        .value;
    var infoCell = sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: infoIndex, rowIndex: i))
        .value;

    final date = DateTime.parse(totalCell);
    final diffDays = date.difference(DateTime(1899, 12, 30)).inDays;
    final diffMillis = date.difference(DateTime(1899, 12, 30)).inMilliseconds;
    final partDelta = diffDays * 24 * 3600 * 1000;
    final remainder = diffMillis - partDelta;
    final millisInDay = 24 * 3600 * 1000;
    double fractionalPart = remainder / millisInDay;
    var result = diffDays + fractionalPart;

    infoString = "$dateTimeCell - $result - $infoCell";
    //print(infoString + "\n");
    infoList.add(infoString);
  }

  return infoList;
}

String stringSub(String s) {
  if (s.contains("BOZAN TURİZM EMLAK YOLCU")) {
    return "ANTALYA";
  }
  if (s.contains("CUMHUR KÖSE")) {
    return "ANKARA";
  }
  if (s.contains("ÖZTÜRK İBRAHİM")) {
    return "ÇAYELİ";
  }
  if (s.contains("DİLEK KATİPOĞLU")) {
    return "ARDEŞEN";
  }
  if (s.contains("ETHEM CANPOLAT")) {
    return "BURSA";
  }
  if (s.contains("ESEN LUKUMCİ")) {
    return "KEMALPAŞA";
  }
  if (s.contains("AŞKIN ERİŞ")) {
    return "İZMİR";
  }
  if (s.contains("ALİ SEZGİN")) {
    return "VAKFIKEBİR";
  }
  if (s.contains("DURSUN ALİ KÖSE")) {
    return "BURSA";
  }
  if (s.contains("RECEP KOTİL")) {
    return "HOPA";
  }

  return s;
}

List compareExcel(List sistemList, List bankList) {
  List sistemCopy = [...sistemList];
  List bankCopy = [...bankList];
  List matchList = [];
  List allList = [];
  print(sistemList.length);
  print(bankList.length);

  //int counter = 0;

  for (String i in sistemList) {
    if (i.toLowerCase().contains("ordu")) {
      print(i);
    }
    final system = i.split(" - ");
    //print(s);

    for (String j in bankList) {
      final bank = j.split(" - ");
      //print(k);

      if (stringSub(bank[2]).toLowerCase().contains(system[0].toLowerCase()) &&
          double.parse(bank[1]).round() == int.parse(system[2])) {
        String r = "${system[0]},  ${system[2]} - ${bank[2]},  ${bank[1]} ";
        matchList.add(r);
        if (bank[2].toLowerCase().contains("ordu")) {
          print(j);
        }
        sistemCopy.remove(i);
        bankList.remove(j);
        bankCopy.remove(j);

        break;
      }
    }
    if (i.toLowerCase().contains("arası") ||
        i.toLowerCase().contains("arasi")) {
      sistemCopy.remove(i);
    }
  }

  print(
      "matchLenght :${matchList.length}, BankCompyLenght : ${bankCopy.length}, SistemCopyLenght: ${sistemCopy.length}");

  allList.add(matchList);
  allList.add(sistemCopy);
  allList.add(bankCopy);

  return allList;
}

Future<void> excelDownloadNotMatch(
    String path, List match, List systemnotMatch, List bankbotMatch) async {
  var excel = Excel.createExcel();
  var sheet = excel[excel.getDefaultSheet()!];

  int randanme = Random().nextInt(10000);
  String s = "$path/$randanme.xlsx";
  print("object");

  sheet.cell(CellIndex.indexByString("A1")).value = "Eşleşen";

  for (int i = 2; i < systemnotMatch.length; i++) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i)).value =
        systemnotMatch[i];
  }

  sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
      "OBİLET KONTÖR";

  sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0)).value =
      "HAVALELER";

  for (int i = 2; i < bankbotMatch.length; i++) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i)).value =
        bankbotMatch[i];
  }

  List<int>? fileBytes = excel.save();
  if (fileBytes != null) {
    File(join(s))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
  }
}

Future<void> excelNewFile(String path, Map data) async {
  var excel = Excel.createExcel();
  var sheet = excel[excel.getDefaultSheet()!];

  int randanme = Random().nextInt(10000);
  String s = "$path/$randanme.xlsx";

  int i = 0;
  for (var key in data.keys) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i)).value =
        key;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i)).value =
        data[key];
    i++;
  }

  List<int>? fileBytes = excel.save();
  if (fileBytes != null) {
    File(join(s))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
  }
}

void main(args) {
  String s = "/Users/omerislam/desktop/banka.xlsx";
  List a = getBankFile(s);
}
