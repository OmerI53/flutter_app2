import 'dart:ffi';
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter_app2/Backend_func.dart';

class Excel_Work extends StatefulWidget {
  const Excel_Work({super.key});

  @override
  State<Excel_Work> createState() => _Excel_WorkState();
}

class _Excel_WorkState extends State<Excel_Work> {
  bool toDest = true;
  bool isCommison = false;
  bool isToEnd = false;
  bool isSevice = false;
  bool isRead = false;

  String sourceFile = "";
  String destFile = "";

  int format = 0;
  String dropdownValue = "Özel";
  var formats = ["Özel", "Yazhane", "Otobüs", "İkram"];

  final a1 = TextEditingController();
  final b1 = TextEditingController();

  final a2 = TextEditingController();
  final b2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const Padding(padding: EdgeInsets.all(5.0)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Visibility(
                  visible: sourceFile != "",
                  child: const Icon(
                    Icons.folder,
                    size: 60,
                  )),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                child: Center(child: Text(sourceFile)),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();
                        if (result != null &&
                            result.files.single.path != null) {
                          PlatformFile file = result.files.first;
                          print(file.path);
                          setState(() {
                            sourceFile = file.path!;
                          });
                        } else {
                          // User canceled the picker
                        }
                      },
                      child: const Text("Nerden")),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        sourceFile = "";
                      });
                    },
                    child: Icon(Icons.close),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                  )
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 60,
                  height: 30,
                  child: TextField(
                    controller: a1,
                    readOnly: false,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "A1",
                      border: OutlineInputBorder(),
                      labelText: "A1",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 60,
                  height: 30,
                  child: TextField(
                    controller: b1,
                    decoration: const InputDecoration(
                        hintText: "B1",
                        border: OutlineInputBorder(),
                        labelText: "B1"),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ]),
              Visibility(
                visible: toDest,
                child: Visibility(
                    visible: destFile != "",
                    child: const Icon(
                      Icons.folder,
                      size: 60,
                    )),
              ),
              Visibility(
                  visible: toDest,
                  child: SizedBox(
                    width: 200,
                    child: Center(child: Text(destFile)),
                  )),
              const SizedBox(
                height: 5,
              ),
              Visibility(
                  visible: toDest,
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();
                            if (result != null &&
                                result.files.single.path != null) {
                              PlatformFile file = result.files.first;
                              setState(() {
                                destFile = file.path!;
                              });
                            } else {
                              // User canceled the picker
                            }
                          },
                          child: const Text("Nereye")),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            destFile = "";
                          });
                        },
                        child: Icon(Icons.close),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                      )
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Visibility(
                    visible: toDest,
                    child: SizedBox(
                      width: 60,
                      height: 35,
                      child: TextField(
                        controller: a2,
                        decoration: const InputDecoration(
                            hintText: "A2",
                            border: OutlineInputBorder(),
                            labelText: "A2"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Visibility(
                    visible: toDest,
                    child: SizedBox(
                      width: 60,
                      height: 35,
                      child: TextField(
                        controller: b2,
                        decoration: const InputDecoration(
                            hintText: "B2",
                            border: OutlineInputBorder(),
                            labelText: "B2"),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Column(
            children: [
              const Padding(padding: EdgeInsets.all(5.0)),
              const Text(
                "Format",
                style: TextStyle(height: 00, fontSize: 15),
              ),
              DropdownButton(
                value: dropdownValue,
                items: formats.map((String items) {
                  return DropdownMenuItem(
                    child: Text(items),
                    value: items,
                  );
                }).toList(),
                onChanged: (String? newstr) {
                  setState(() {
                    dropdownValue = newstr!;
                    if (dropdownValue == "Özel") {
                      isRead = false;
                    } else {
                      isRead = true;
                      a1.clear();
                      b1.clear();
                    }
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Var Olan Dosya"),
              Switch(
                  value: toDest,
                  onChanged: (bool? newbool) {
                    setState(() {
                      toDest = newbool!;
                    });
                  }),
              const Text("Yeni Dosya"),
              Switch(
                  value: !toDest,
                  onChanged: (bool? newbool) {
                    setState(() {
                      toDest = !newbool!;
                    });
                  }),
              /*
              const Text("Komisyon Alma"),
              Checkbox(
                  value: isCommison,
                  onChanged: (bool? newbool) {
                    setState(() {
                      isCommison = newbool!;
                    });
                  }),
              const Text("Seris"),
              Checkbox(
                  value: isSevice,
                  onChanged: (bool? newbool) {
                    setState(() {
                      isSevice = newbool!;
                    });
                  }),
              const Text("Sona Yaz"),
              Checkbox(
                  value: isToEnd,
                  onChanged: (bool? newbool) {
                    setState(() {
                      isToEnd = newbool!;
                    });
                  }),
              */
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (sourceFile != "" && destFile != "") {
                      if (a2.text.isEmpty || b2.text.isEmpty) {
                        showAlerDialog(context, "Hedef Adresler Boş",
                            const Icon(Icons.error));
                      } else {
                        var data = {};

                        if (dropdownValue == "Özel") {
                          print("here");
                          if (a1.text.isEmpty || b1.text.isEmpty) {
                            showAlerDialog(context, "Kaynak Adresler boş",
                                const Icon(Icons.error));
                          } else {
                            data =
                                excelReadManuel(sourceFile, a1.text, b1.text);
                          }
                        } else {
                          data = excelReadAuto(sourceFile, dropdownValue);
                        }
                        excelWriteManuel(
                          destFile,
                          data,
                          a2.text,
                          b2.text,
                        );
                        showAlerDialog(
                            context, "tamam", const Icon(Icons.done));

                        setState(() {
                          a1.clear();
                          b1.clear();
                          a2.clear();
                          b2.clear();
                        });
                      }
                    } else {
                      showAlerDialog(
                          context, "dosya seçilmedi", const Icon(Icons.error));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: isCommison ? Colors.red : Colors.blue),
                  child: isCommison ? const Text("Devam") : const Text("Aktar"))
            ],
          )
        ]),
      ),
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
