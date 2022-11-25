import 'package:flutter/material.dart';

import '../database/database_methods.dart';
import '../models/category.dart';
import '../widgets/menu_display_design.dart';
import 'category_upload_view.dart';
import 'global/global.dart';

class Category_Display extends StatefulWidget {
  const Category_Display({super.key});

  @override
  State<Category_Display> createState() => _Category_DisplayState();
}

class _Category_DisplayState extends State<Category_Display> {
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
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Welcome  ${sharedPreferences!.getString("name")!}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
