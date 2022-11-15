import 'package:agriculture_app/database/database_methods.dart';
import 'package:agriculture_app/models/category.dart';
import 'package:agriculture_app/views/auth_screen.dart';
import 'package:agriculture_app/views/global/global.dart';
import 'package:agriculture_app/views/category_upload_view.dart';
import 'package:agriculture_app/widgets/drawer.dart';
import 'package:agriculture_app/widgets/menu_display_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream? sellerCategories;

  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    getSellerCategories();
    super.initState();
  }

  getSellerCategories() async {
    databaseMethods
        .getCategories(sharedPreferences!.getString("uid")!)
        .then((value) {
      setState(() {
        sellerCategories = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Welcome  ${sharedPreferences!.getString("name")!}"),
      ),
      bottomNavigationBar:
          BottomNavigationBar(backgroundColor: Colors.white70, items: [
        const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
              color: Colors.deepPurpleAccent,
            ),
            label: ""),
        BottomNavigationBarItem(
          icon: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoryUploadScreen()));
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
              color: Colors.deepPurpleAccent,
            ),
            label: ""),
      ]),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: sellerCategories,
              builder: (context, AsyncSnapshot snapshot) {
                return !snapshot.hasData
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          Category model = Category.fromJson(
                              snapshot.data!.docs[index].data()!
                                  as Map<String, dynamic>);
                          return MenueDesign(model: model, context: context);
                        });
              },
            ),
          ),
        ],
      ),
    );
  }
}
