import 'package:agriculture_app/views/auth_screen.dart';
import 'package:agriculture_app/views/global/global.dart';
import 'package:agriculture_app/views/upload_view.dart';
import 'package:agriculture_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Welcome  ${sharedPreferences!.getString("name")!}"),
      ),
      bottomNavigationBar:
          BottomNavigationBar(backgroundColor: Colors.black87, items: [
        const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
              color: Colors.white,
            ),
            label: ""),
        BottomNavigationBarItem(
          icon: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProductUploadScreen()));
            },
            child: Container(
              height: 52,
              width: 52,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Colors.indigoAccent, Colors.purple])),
              child: const Icon(
                Icons.add,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
          label: "",
        ),
        const BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 32,
              color: Colors.white,
            ),
            label: ""),
      ]),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.black,
          Colors.black87,
        ])),
      ),
    );
  }
}
