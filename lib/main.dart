import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Excel_Work_Page.dart';
import 'package:flutter_app2/Home_page.dart';
import 'package:flutter_app2/Other.dart';

void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    final initialSize = Size(850, 720);
    final minSize = Size(850, 720);
    final maxSize = Size(850, 720);
    appWindow.maxSize = maxSize;
    appWindow.minSize = minSize;
    appWindow.size = initialSize; //default size
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 1;
  List<Widget> page = const [Excel_Work(), HomePage(), Other()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentPage != 1
          ? null
          : AppBar(
              title: const Text("Excel Uygulama"),
            ),
      body: page[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.work), label: "Excel İşlem"),
          NavigationDestination(icon: Icon(Icons.home), label: "Ana Sayfa"),
          NavigationDestination(
              icon: Icon(Icons.compare), label: "Karşılaştırma"),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
