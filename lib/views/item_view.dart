import 'package:agriculture_app/database/database_methods.dart';
import 'package:agriculture_app/models/category.dart';
import 'package:agriculture_app/models/item_model.dart';
import 'package:agriculture_app/views/auth_screen.dart';
import 'package:agriculture_app/views/global/global.dart';
import 'package:agriculture_app/views/category_upload_view.dart';
import 'package:agriculture_app/views/items_upload_screen.dart';
import 'package:agriculture_app/widgets/drawer.dart';
import 'package:agriculture_app/widgets/item_display_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemView extends StatefulWidget {
  ItemView({super.key, required this.model});

  Category model;

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  Stream? itemsStream;
  DatabaseMethods databaseMethods = DatabaseMethods();

  getCategoryProducts() async {
    databaseMethods
        .getItems(sharedPreferences!.getString("uid")!, widget.model.categoryId)
        .then((value) {
      setState(() {
        itemsStream = value;
      });
    });
  }

  @override
  void initState() {
    getCategoryProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Your products for ${widget.model.categoryTitle}",
            style: GoogleFonts.poppins(),
          ),
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
                        builder: (context) => ProductUploadScreen(
                              model: widget.model,
                            )));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: [Colors.indigoAccent, Colors.purple])),
                child: const Icon(
                  Icons.upload_rounded,
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
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: itemsStream,
                  builder: (context, AsyncSnapshot snapshot) {
                    return !snapshot.hasData
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(itemCount: snapshot.data.docs.length ,itemBuilder: (context, index) {
                            Item model = Item.fromJson(snapshot
                                .data.docs[index].data()! as Map<String, dynamic>);
            
                            return ItemDesign(model: model, context: context);
                          });
                  }),
            )
          ],
        ));
  }
}
