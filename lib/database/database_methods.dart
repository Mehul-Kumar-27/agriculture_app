import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getCategories(String uid) async {
    return FirebaseFirestore.instance
        .collection("seller")
        .doc(uid)
        .collection("category")
        .snapshots();
  }

  
}
