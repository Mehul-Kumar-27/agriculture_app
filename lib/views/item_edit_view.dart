import 'dart:io';

import 'package:agriculture_app/models/item_model.dart';
import 'package:agriculture_app/views/home_screen.dart';
import 'package:agriculture_app/widgets/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../models/category.dart';
import 'global/global.dart';

class EditProductScreen extends StatefulWidget {
  EditProductScreen({super.key, required this.model});

  Item model;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  XFile? imageXFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool upload = false;
  bool changeImage = false;

  late String productId;
  late String downloadUrl;

  late TextEditingController titleController;
  late TextEditingController shortDescriptionController;
  late TextEditingController priceController;
  late TextEditingController quantityController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      titleController = TextEditingController(text: widget.model.productTitle);
      shortDescriptionController =
          TextEditingController(text: widget.model.productDescription);

      priceController =
          TextEditingController(text: widget.model.priceTitle.toString());
      quantityController = TextEditingController(text: widget.model.quantity);

      productId = widget.model.productId;
      downloadUrl = widget.model.thumbnailUrl;
    });
  }

  capatureImageWithCamera() async {
    imageXFile = await _imagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680, maxWidth: 970);

    setState(() {
      imageXFile;
    });
  }

  chooseImageFromGalary() async {
    imageXFile = await _imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 680, maxWidth: 970);

    setState(() {
      imageXFile;
    });
  }

  linearProgressBar() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 12),
      child: const LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.indigoAccent)),
    );
  }

  uploadImageToFirebase(image) async {
    fStorage.Reference reference =
        fStorage.FirebaseStorage.instance.ref().child("productImage");

    fStorage.UploadTask uploadTask =
        reference.child("${widget.model.productId}.jpg").putFile(image);

    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    await taskSnapshot.ref.getDownloadURL().then((url) {
      downloadUrl = url;
    });
  }

  saveInfoToCategoryFirestore() {
    final reference = FirebaseFirestore.instance
        .collection("seller")
        .doc(sharedPreferences!.getString("uid"))
        .collection("category")
        .doc(widget.model.categoryId)
        .collection("items");

    reference.doc(widget.model.productId).update({
      "productId": widget.model.productId,
      "categoryId": widget.model.categoryId,
      "sellerUID": sharedPreferences!.getString("uid"),
      "sellerName": sharedPreferences!.getString("name"),
      "productDescription": shortDescriptionController.text.toString(),
      "productTitle": titleController.text.toString(),
      "priceTitle": int.parse(priceController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "quantity": quantityController.text.toString(),
    });
  }

  saveInfoToFirestore() {
    final reference = FirebaseFirestore.instance.collection("items");

    reference.doc(widget.model.productId).update({
      "productId": widget.model.productId,
      "categoryId": widget.model.categoryId,
      "sellerUID": sharedPreferences!.getString("uid"),
      "sellerName": sharedPreferences!.getString("name"),
      "productDescription": shortDescriptionController.text.toString(),
      "productTitle": titleController.text.toString(),
      "priceTitle": int.parse(priceController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "quantity": quantityController.text.toString(),
    }).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  validateForm() async {
    if (changeImage == true) {
      if (imageXFile != null) {
        if (shortDescriptionController.text.isNotEmpty &&
            titleController.text.isNotEmpty &&
            priceController.text.isNotEmpty &&
            quantityController.text.isNotEmpty) {
          setState(() {
            upload = true;
          });

          /// Upoading Image to firebase database
          await uploadImageToFirebase(File(imageXFile!.path));

          // Saving data to firestore category

          await saveInfoToCategoryFirestore();

          await saveInfoToFirestore();

          //
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return const ErrorDialog(
                  message: "Please fill in all the fields to continue",
                );
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                message: "Please select an image",
              );
            });
      }
    } else {
      if (shortDescriptionController.text.isNotEmpty &&
          titleController.text.isNotEmpty &&
          priceController.text.isNotEmpty &&
          quantityController.text.isNotEmpty) {
        setState(() {
          upload = true;
        });

        downloadUrl = widget.model.thumbnailUrl;

        await saveInfoToCategoryFirestore();

        await saveInfoToFirestore();

        //
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                message: "Please fill in all the fields to continue",
              );
            });
      }
    }
  }

  uploadingItemScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Edit ${widget.model.productTitle}",
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              clearCategoryForm();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: ListView(
          children: [
            upload == true ? linearProgressBar() : const Text(""),
            SizedBox(
              height: 300,
              child: imageXFile == null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        widget.model.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(
                      height: 300,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                                image: FileImage(File(imageXFile!.path)),
                                fit: BoxFit.cover)),
                      ),
                    ),
            ).px8(),
            10.heightBox,
            Container(
              width: 400,
              height: 40,
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    changeImage = true;
                  });
                  chooseImageFromGalary();
                },
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                label: "Change image".text.make(),
                style: ElevatedButton.styleFrom(
                    elevation: 4,
                    backgroundColor: Colors.deepPurple[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40))),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.title_outlined,
                color: Colors.black,
              ),
              title: TextField(
                controller: titleController,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  fillColor: Colors.blue[100],
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.black54, fontSize: 17),
                  contentPadding: const EdgeInsets.only(left: 20, right: 20),
                ),
              ),
            ),
            const Divider(
              thickness: 3,
              color: Colors.white60,
            ),
            ListTile(
              leading: const Icon(
                Icons.description_rounded,
                color: Colors.black,
              ),
              title: TextField(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
                controller: shortDescriptionController,
                decoration: InputDecoration(
                  hintText: "Write short description of this category",
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
                ),
              ),
            ),
            const Divider(
              thickness: 3,
              color: Colors.white70,
            ),
            ListTile(
              leading: const Icon(
                Icons.monetization_on,
                color: Colors.black,
              ),
              title: TextField(
                keyboardType: TextInputType.number,
                controller: priceController,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Price of this item",
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
                  contentPadding: const EdgeInsets.only(left: 20, right: 20),
                ),
              ),
            ),
            const Divider(
              thickness: 3,
              color: Colors.white60,
            ),
            ListTile(
              leading: const Icon(
                Icons.balance_rounded,
                color: Colors.black,
              ),
              title: TextField(
                controller: quantityController,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Quantity of this item you have",
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
                  contentPadding: const EdgeInsets.only(left: 20, right: 20),
                ),
              ),
            ),
            const Divider(
              thickness: 3,
              color: Colors.white60,
            ),
            SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                  onPressed: upload ? null : () => validateForm(),
                  icon: const Icon(Icons.upload),
                  label: "Update item details".text.make()),
            )
          ],
        ),
      ),
    );
  }

  clearCategoryForm() {
    setState(() {
      titleController.clear();
      shortDescriptionController.clear();
      priceController.clear();
      quantityController.clear();
      imageXFile = null;

      upload = false;
      //downloadUrl = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return uploadingItemScreen();
  }

  // Widget description(TextEditingController textEditingController) {
  //   return Container(
  //     height: 155,
  //     width: MediaQuery.of(context).size.width,
  //     decoration: BoxDecoration(
  //       color: Color.fromARGB(255, 56, 47, 47),
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: TextFormField(
  //       controller: textEditingController,
  //       maxLines: null,
  //       style: const TextStyle(
  //         color: Colors.white70,
  //         fontSize: 17,
  //       ),
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         hintText: "Description",
  //         hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
  //         contentPadding: EdgeInsets.only(left: 20, right: 20),
  //       ),
  //     ),
  //   ).py12();
  // }
}
