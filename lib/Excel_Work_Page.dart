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
        appBar: AppBar(
          title: const Text("Bilgi Yazma"),
        ),
        body: SingleChildScrollView(
          child: Row(children: [
            //file selecters Row
            Row(
              children: [
                //main Row Left padding
                const SizedBox(
                  width: 100,
                ),
                //Collum for source file
                Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    IconTheme(
                        data: IconThemeData(
                            color:
                                sourceFile != "" ? Colors.green : Colors.red),
                        child: const Icon(
                          Icons.folder,
                          size: 75,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 200,
                      height: 15,
                      child: Center(child: Text(sourceFile)),
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
                            child: const Text(
                              "Nerden",
                              style: TextStyle(fontSize: 16),
                            )),
                        const SizedBox(
                          width: 8,
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
                    const SizedBox(
                      height: 6,
                    ),
                    Row(children: [
                      SizedBox(
                        width: 61,
                        height: 36,
                        child: TextField(
                          controller: a1,
                          readOnly: dropdownValue != "Özel",
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "A1",
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: 61,
                        height: 36,
                        child: TextField(
                          controller: b1,
                          readOnly: dropdownValue != "Özel",
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: "B1"),
                        ),
                      ),
                    ]),
                  ],
                ),
                //dest file left padding
                const SizedBox(
                  width: 50,
                ),
                //Collum for destination file
                Visibility(
                  visible: toDest,
                  maintainAnimation: true,
                  maintainSize: true,
                  maintainState: true,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      IconTheme(
                          data: IconThemeData(
                              color:
                                  destFile != "" ? Colors.green : Colors.red),
                          child: const Icon(
                            Icons.folder,
                            size: 75,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 200,
                        height: 15,
                        child: Center(child: Text(destFile)),
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
                              child: const Text("Nereye",
                                  style: TextStyle(fontSize: 16))),
                          const SizedBox(
                            width: 8,
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
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 61,
                            height: 36,
                            child: TextField(
                              controller: a2,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "A2"),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: 61,
                            height: 36,
                            child: TextField(
                              controller: b2,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "B2"),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            //Left Bar toleft padding
            const SizedBox(
              width: 75,
            ),
            //Left Bar
            Column(
              children: [
                //Left Bar downwards padding
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  "Format",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 3,
                ),
                DropdownButton(
                  value: dropdownValue,
                  items: formats.map((String items) {
                    return DropdownMenuItem(
                      child: Text(items, style: TextStyle(fontSize: 18)),
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
                  height: 38,
                ),
                const Text("Var Olan Dosya", style: TextStyle(fontSize: 18)),
                Switch(
                    value: toDest,
                    onChanged: (bool? newbool) {
                      setState(() {
                        toDest = newbool!;
                      });
                    }),
                const SizedBox(
                  height: 4,
                ),
                const Text("Yeni Dosya", style: TextStyle(fontSize: 18)),
                Switch(
                    value: !toDest,
                    onChanged: (bool? newbool) {
                      setState(() {
                        toDest = !newbool!;
                      });
                    }),
              ],
            )
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (toDest) {
              if (sourceFile != "" && destFile != "") {
                if (a2.text.isEmpty || b2.text.isEmpty) {
                  showAlerDialog(
                      context, "Hedef Adresler Boş", const Icon(Icons.error));
                } else {
                  var data = {};

                  if (dropdownValue == "Özel") {
                    print("here");
                    if (a1.text.isEmpty || b1.text.isEmpty) {
                      showAlerDialog(context, "Kaynak Adresler boş",
                          const Icon(Icons.error));
                    } else {
                      data = excelReadManuel(sourceFile, a1.text, b1.text);
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
                  showAlerDialog(context, "tamam", const Icon(Icons.done));

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
            } else {
              if (sourceFile != "") {
                var data = {};
                String? selectedDirectory =
                    await FilePicker.platform.getDirectoryPath();

                if (dropdownValue == "Özel") {
                  if (a1.text.isEmpty || b1.text.isEmpty) {
                    showAlerDialog(context, "Kaynak Adresler boş",
                        const Icon(Icons.error));
                  } else {
                    data = excelReadManuel(sourceFile, a1.text, b1.text);
                  }
                } else {
                  data = excelReadAuto(sourceFile, dropdownValue);
                }
                excelNewFile(
                  selectedDirectory!,
                  data,
                );
                showAlerDialog(context, "tamam", const Icon(Icons.done));

                setState(() {
                  a1.clear();
                  b1.clear();
                });
              } else {
                showAlerDialog(
                    context, "dosya seçilmedi", const Icon(Icons.error));
              }
            }
          },
          child: const Icon(Icons.start),
        ));
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
