import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Matched extends StatefulWidget {
  Matched(this.allList, {super.key});
  List allList;

  @override
  State<Matched> createState() => _MatchedState();
}

class _MatchedState extends State<Matched> {
  late List filt = widget.allList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eşleşen"),
        automaticallyImplyLeading: true,
      ),
      body: Column(children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          width: 400,
          height: 50,
          child: TextField(
            onChanged: (value) => filter(value),
            decoration: InputDecoration(
              hintText: "Arama ",
              suffixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.blue)),
            ),
          ),
        ),
        Flexible(
          child: Container(
            child: ListView.builder(
              itemCount: filt.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(filt[index]),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }

  void filter(String s) {
    final filtered = widget.allList.where((element) {
      final inf = element.toLowerCase();
      final key = s.toLowerCase();
      return inf.contains(key);
    }).toList();
    setState(() {
      if (s.isNotEmpty) {
        filt = filtered;
      } else {
        filt = widget.allList;
      }
    });
  }
}
