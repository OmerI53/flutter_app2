import 'package:flutter/material.dart';

class Unmatched extends StatefulWidget {
  Unmatched(this.systemList, this.bankList, {super.key});
  List systemList;
  List bankList;
  @override
  State<Unmatched> createState() => _UnmatchedState();
}

class _UnmatchedState extends State<Unmatched> {
  List bankColor = [];
  List systemColor = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bulunamayan"),
        automaticallyImplyLeading: true,
      ),
      body: Row(
        children: [
          Flexible(
              child: Container(
            child: ListView.builder(
              itemCount: widget.bankList.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                title: Text("${widget.bankList[index]}"),
                trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: bankColor.contains(index)
                            ? Colors.green
                            : Colors.red),
                    onPressed: () {
                      setState(() {
                        if (bankColor.contains(index)) {
                          bankColor.remove(index);
                        } else {
                          bankColor.add(index);
                        }
                      });
                    },
                    child: bankColor.contains(index)
                        ? const Icon(Icons.check)
                        : const Icon(Icons.close)),
              ),
            ),
          )),
          Flexible(
              child: Container(
            child: ListView.builder(
              itemCount: widget.systemList.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                  title: Text("${widget.systemList[index]}"),
                  trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: systemColor.contains(index)
                              ? Colors.green
                              : Colors.red),
                      onPressed: () {
                        setState(() {
                          if (systemColor.contains(index)) {
                            systemColor.remove(index);
                          } else {
                            systemColor.add(index);
                          }
                        });
                      },
                      child: systemColor.contains(index)
                          ? const Icon(Icons.check)
                          : const Icon(Icons.close))),
            ),
          ))
        ],
      ),
    );
  }
}
