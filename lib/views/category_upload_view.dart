import 'dart:io';

import 'package:agriculture_app/widgets/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import 'global/global.dart';

class CategoryUploadScreen extends StatefulWidget {
  const CategoryUploadScreen({super.key});

  @override
  State<CategoryUploadScreen> createState() => _CategoryUploadScreenState();
}

class _CategoryUploadScreenState extends State<CategoryUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool upload = false;

  String categoryId = "";
  String downloadUrl = "";

  TextEditingController titleController = TextEditingController();
  TextEditingController shortDescriptionController = TextEditingController();

  defaultUploadScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Add New Category",
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Center(
              child: Material(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(80)),
                elevation: 10,
                shadowColor: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: SizedBox(
                      height: 160,
                      width: 160,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.file_upload_outlined,
                            color: Colors.blue,
                            size: 50,
                          ))),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            "Please choose category image"
                .text
                .textStyle(
                    GoogleFonts.andadaPro(color: Colors.white70, fontSize: 25))
                .make(),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                  child: TextButton.icon(
                      onPressed: () => chooseImageFromGalary(),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text(
                        "Using Camera",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
                Container(
                  child: TextButton.icon(
                      onPressed: () => chooseImageFromGalary(),
                      icon: const Icon(Icons.folder),
                      label: const Text(
                        "Using Gallery",
                        style: TextStyle(fontSize: 20),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
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
    categoryId = DateTime.now().millisecondsSinceEpoch.toString();

    fStorage.Reference reference = fStorage.FirebaseStorage.instance
        .ref()
        .child("categoryImage")
        .child(categoryId);

    fStorage.UploadTask uploadTask =
        reference.child("$categoryId.jpg").putFile(image);

    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    await taskSnapshot.ref.getDownloadURL().then((url) {
      downloadUrl = url;
    });
  }

  saveInfoToFirestore() {
    final reference = FirebaseFirestore.instance
        .collection("seller")
        .doc(sharedPreferences!.getString("uid"))
        .collection("category");

    reference.doc(categoryId).set({
      "categoryId": categoryId,
      "sellerUID": sharedPreferences!.getString("uid"),
      "categoryDescription": shortDescriptionController.text.toString(),
      "categoryTitle": titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl
    });

    clearCategoryForm();
  }

  validateForm() async {
    if (imageXFile != null) {
      if (shortDescriptionController.text.isNotEmpty &&
          titleController.text.isNotEmpty) {
        setState(() {
          upload = true;
        });

        /// Upoading Image to firebase database
        await uploadImageToFirebase(File(imageXFile!.path));

        // Saving data to firestore

        saveInfoToFirestore();
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
  }

  uploadingMenuScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "New Category ",
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              clearCategoryForm();
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: ListView(
          children: [
            upload == true ? linearProgressBar() : const Text(""),
            SizedBox(
              height: 230,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(File(imageXFile!.path)),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.title_outlined,
                color: Colors.grey,
              ),
              title: TextField(
                controller: titleController,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: const Icon(
                Icons.description_rounded,
                color: Colors.grey,
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
            SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                  onPressed: upload ? null : () => validateForm(),
                  icon: const Icon(Icons.upload),
                  label: "Upload New Category".text.make()),
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
      imageXFile = null;
      categoryId = DateTime.now().millisecondsSinceEpoch.toString();
      upload = false;
      //downloadUrl = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultUploadScreen() : uploadingMenuScreen();
  }

  Widget description(TextEditingController textEditingController) {
    return Container(
      height: 155,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 56, 47, 47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: textEditingController,
        maxLines: null,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Description",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    ).py12();
  }
}
