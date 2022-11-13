// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  late String category;
  late String categoryDescription;
  late String categoryTitle;
  late int priceTitle;
  late String productId;
  late Timestamp publishedDate;
  late String sellerName;
  late String sellerUID;
  late String status;
  late String thumbnailUrl;

  Item({
    required this.category,
    required this.categoryDescription,
    required this.categoryTitle,
    required this.priceTitle,
    required this.productId,
    required this.publishedDate,
    required this.sellerName,
    required this.sellerUID,
    required this.status,
    required this.thumbnailUrl,
  });

  Item.fromJson(Map<String, dynamic> json) {
    category = json["category"];
    categoryDescription = json["categoryDescription"];
    categoryTitle = json["categoryTitle"];
    priceTitle = json["priceTitle"];
    productId = json["productId"];
    publishedDate = json["publishedDate"];
    sellerName = json["sellerName"];
    sellerUID = json["sellerUID"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();

    data["category"] = category;
    data["categoryDescription"] = categoryDescription;
    data["categoryTitle"] = categoryTitle;
    data["priceTitle"] = priceTitle;
    data["productId"] = productId;
    data["publishedDate"] = publishedDate;
    data["sellerName"] = sellerName;
    data["sellerUID"] = sellerUID;
    data["status"] = status;
    data["thumbnailUrl"] = thumbnailUrl;

    return data;
  }
}
