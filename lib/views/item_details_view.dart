// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:agriculture_app/views/item_edit_view.dart';
import 'package:agriculture_app/views/item_view.dart';

import '../models/item_model.dart';

class ItemDetailView extends StatelessWidget {
  final Item model;
  bool istrending;
   ItemDetailView({
    Key? key,
    required this.model,
    required this.istrending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      bottomNavigationBar: istrending ? null : BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: InkWell(
                child: const Icon(
                  Icons.edit,
                  size: 32,
                  color: Colors.deepPurpleAccent,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditProductScreen(model: model)));
                },
              ),
              label: ""),
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
                        return ItemDeleteDialog(model: model);
                      }).then((value) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                },
              ),
              label: ""),
        ],
      ),
      body: Container(
        color: Colors.black12,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Hero(
                      tag: Key(model.productId.toString()),
                      child: Image.network(model.thumbnailUrl))
                  .h40(context),
              Expanded(
                  child: VxArc(
                height: 30.0,
                arcType: VxArcType.CONVEY,
                edge: VxEdge.TOP,
                child: Container(
                  width: context.screenWidth,
                  color: Colors.white70,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        model.productTitle.text
                            .textStyle(GoogleFonts.lato(fontSize: 30))
                            .bold
                            .make(),
                        const Divider(
                          color: Colors.grey,
                        ),
                        10.heightBox,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Description -: ${model.productDescription}"
                                .text
                                .textStyle(context.captionStyle)
                                .size(15)
                                .bold
                                .make(),
                            50.heightBox,
                            Row(
                              children: [
                                "Price : \$${model.priceTitle}"
                                    .text
                                    .color(Colors.red)
                                    .textStyle(
                                        GoogleFonts.openSans(fontSize: 15))
                                    .bold
                                    .make(),
                                40.widthBox,
                                "Quantity available : ${model.quantity}"
                                    .text
                                    .textStyle(
                                        GoogleFonts.openSans(fontSize: 15))
                                    .bold
                                    .color(Colors.black)
                                    .make()
                              ],
                            ),
                          ],
                        ),
                      ],
                    ).py64().px12(),
                  ),
                ),
              ))
            ],
          ).py2(),
        ),
      ),
    );
  }
}

class ItemDeleteDialog extends StatelessWidget {
  ItemDeleteDialog({Key? key, required this.model}) : super(key: key);

  Item model;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: const Text("Are you sure you want to delete this item"),
      actions: [
        ElevatedButton(
          child: const Center(
            child: Text("Delete"),
          ),
          onPressed: () {
            FirebaseFirestore.instance
                .collection("seller")
                .doc(model.sellerUID)
                .collection("category")
                .doc(model.categoryId)
                .collection("items")
                .doc(model.productId)
                .delete()
                .then((value) {
              FirebaseFirestore.instance
                  .collection("items")
                  .doc(model.productId)
                  .delete();
            }).then((value) {
              Navigator.pop(context);
            });
          },
        )
      ],
    );
  }
}
