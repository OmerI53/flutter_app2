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
      appBar: AppBar(title: const Text("title"), actions: [
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
              child: Icon(Icons.download)),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var flist1 = getSistemFile(sistemFile);
          var flist2 = getBankFile(bankaFile);
          allList = compareExcel(flist1, flist2);
          setState(() {});
        },
        child: const Icon(Icons.start),
      ),
      body: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 0,
            ),
            Visibility(
                visible: bankaFile != "",
                child: const Icon(
                  Icons.folder,
                  size: 60,
                )),
            const SizedBox(
              height: 0,
            ),
            SizedBox(
              width: 200,
              child: Center(child: Text(bankaFile)),
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
                    child: const Text("Banka")),
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
              child: const Text("Eşeleşen"),
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      allList.isNotEmpty ? Colors.green : Colors.blue),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 0,
            ),
            Visibility(
                visible: sistemFile != "",
                child: const Icon(
                  Icons.folder,
                  size: 60,
                )),
            const SizedBox(
              height: 0,
            ),
            SizedBox(
              width: 200,
              child: Center(child: Text(sistemFile)),
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
                    child: const Text("Sistem")),
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
              child: const Text("Bulunamayan"),
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
