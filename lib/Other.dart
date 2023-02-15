import 'dart:ffi';
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter_app2/Backend_func.dart';
import 'package:flutter_app2/Unmatched.dart';

import 'Matched.dart';

class Other extends StatefulWidget {
  const Other({super.key});

  @override
  State<Other> createState() => _OtherState();
}

class _OtherState extends State<Other> {
  String bankaFile = "";
  String sistemFile = "";
  String downloadPath = "";

  List allList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bilgi Karşılaştırma"), actions: [
        GestureDetector(
          child: ElevatedButton(
              onPressed: () async {
                String? selectedDirectory =
                    await FilePicker.platform.getDirectoryPath();

                if (selectedDirectory == null) {
                  // User canceled the picker
                }
                setState(() {
                  excelDownloadNotMatch(
                      selectedDirectory!, allList[0], allList[1], allList[2]);
                });
              },
              child: const Icon(Icons.download)),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var flist1 = getSistemFile(sistemFile);
          var flist2 = getBankFile(bankaFile);
          allList = compareExcel(flist1, flist2);
          setState(() {});
        },
        child: const Icon(Icons.start_outlined),
      ),
      body: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(
          children: [
            const SizedBox(
              height: 175,
            ),
            IconTheme(
                data: IconThemeData(
                    color: bankaFile != "" ? Colors.green : Colors.red),
                child: const Icon(
                  Icons.folder,
                  size: 80,
                )),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 200,
              height: 15,
              child: Center(child: Text(bankaFile)),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result != null && result.files.single.path != null) {
                        PlatformFile file = result.files.first;
                        //print(file.path);
                        setState(() {
                          bankaFile = file.path!;
                        });
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: const Text("Banka", style: TextStyle(fontSize: 16))),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      bankaFile = "";
                    });
                  },
                  child: Icon(Icons.close),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                )
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
              onPressed: () {
                if (allList.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Matched(allList[0])));
                } else {
                  showAlerDialog(
                      context, "Liste Boş", const Icon(Icons.warning));
                }
              },
              child: const Text("Eşeleşen", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      allList.isNotEmpty ? Colors.green : Colors.blue),
            ),
          ],
        ),
        Column(
          children: [
            const SizedBox(
              height: 175,
            ),
            IconTheme(
                data: IconThemeData(
                    color: sistemFile != "" ? Colors.green : Colors.red),
                child: const Icon(
                  Icons.folder,
                  size: 80,
                )),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 200,
              height: 15,
              child: Center(child: Text(sistemFile)),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result != null && result.files.single.path != null) {
                        PlatformFile file = result.files.first;
                        //print(file.path);
                        setState(() {
                          sistemFile = file.path!;
                        });
                      } else {
                        // User canceled the picker
                      }
                    },
                    child:
                        const Text("Sistem", style: TextStyle(fontSize: 16))),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      sistemFile = "";
                    });
                  },
                  child: const Icon(Icons.close),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                )
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
              onPressed: () {
                if (allList.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Unmatched(allList[1], allList[2])));
                } else {
                  showAlerDialog(
                      context, "Liste Boş", const Icon(Icons.warning));
                }
              },
              child: const Text("Bulunamayan", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      allList.isNotEmpty ? Colors.red : Colors.blue),
            ),
          ],
        )
      ]),
    );
  }
}

showAlerDialog(BuildContext context, String message, Icon icon) {
  Widget okButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text("Tamam"));

  AlertDialog alert = AlertDialog(
    title: Text(message),
    content: icon,
    actions: [okButton],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
