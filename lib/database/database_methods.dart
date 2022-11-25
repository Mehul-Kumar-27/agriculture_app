import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getCategories(String uid) async {
    return FirebaseFirestore.instance
        .collection("seller")
        .doc(uid)
        .collection("category")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getItems(String uid, String categoryId) async {
    return FirebaseFirestore.instance
        .collection("seller")
        .doc(uid)
        .collection("category")
        .doc(categoryId)
        .collection("items")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getTreandingProducts() async {
    return FirebaseFirestore.instance.collection("items").orderBy("publishedDate", descending: true).snapshots();
  }
}
