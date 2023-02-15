import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: [
        const Padding(padding: EdgeInsets.all(10.0)),
        const Text(
          "Exceli 'Excel Çalışma Dosyası' olarak kaydedin, çalıştırın",
          style: TextStyle(fontSize: 25),
        ),
        Image.asset(
          "Images/luks-karadeniz.png",
          height: 500,
          width: 500,
        )
      ]),
    ));
  }
}
