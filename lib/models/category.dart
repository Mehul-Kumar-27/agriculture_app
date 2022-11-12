// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  late String categoryId;
  late String sellerUID;
  late String categoryDescription;
  late String categoryTitle;
  late String thumbnailUrl;
  late String status;
  late Timestamp publishedDate;
  Category({
    required this.categoryId,
    required this.sellerUID,
    required this.categoryDescription,
    required this.categoryTitle,
    required this.thumbnailUrl,
    required this.status,
    required this.publishedDate,
  });

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json["categoryId"];
    sellerUID = json["sellerUID"];
    categoryDescription = json["categoryDescription"];
    categoryTitle = json["categoryTitle"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
    publishedDate = json["publishedDate"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();

    data["categoryId"] = categoryId;
    data["sellerUID"] = sellerUID;
    data["categoryDescription"] = categoryDescription;
    data["categoryTitle"] = categoryTitle;
    data["thumbnailUrl"] = thumbnailUrl;
    data["status"] = status;
    data["publishedDate"] = publishedDate;

    return data;
  }
}
