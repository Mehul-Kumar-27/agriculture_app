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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            "Your products for ${widget.model.categoryTitle}",
            style: GoogleFonts.poppins(),
          ),
        ),
        bottomNavigationBar:
            BottomNavigationBar(backgroundColor: Colors.white70, items: [
          const BottomNavigationBarItem(
              icon: InkWell(
                child: Icon(
                  Icons.edit,
                  size: 32,
                  color: Colors.deepPurpleAccent,
                ),
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
          BottomNavigationBarItem(
              icon: InkWell(
                child: const Icon(
                  Icons.delete,
                  size: 32,
                  color: Colors.deepPurpleAccent,
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DeleteDialog(model: widget.model);
                      }).then((value) {
                    Navigator.pop(context);
                  });
                },
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
                        : ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              Item model = Item.fromJson(
                                  snapshot.data.docs[index].data()!
                                      as Map<String, dynamic>);

                              return ItemDesign(model: model, context: context);
                            });
                  }),
            )
          ],
        ));
  }
}

class DeleteDialog extends StatelessWidget {
  DeleteDialog({Key? key, required this.model}) : super(key: key);

  Category model;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("Delete ${model.categoryTitle} category"),
      actions: [
        ElevatedButton(
          child: const Center(
            child: Text("OK"),
          ),
          onPressed: () {
            FirebaseFirestore.instance
                .collection("seller")
                .doc(sharedPreferences!.getString("uid"))
                .collection("category")
                .doc(model.categoryId)
                .delete()
                .then((value) {
              Navigator.pop(context);
            });
          },
        )
      ],
    );
  }
}
