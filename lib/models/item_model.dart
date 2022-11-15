// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  late String categoryId;
  late String productDescription;
  late String productTitle;
  late int priceTitle;
  late String productId;
  late Timestamp publishedDate;
  late String sellerName;
  late String sellerUID;
  late String status;
  late String thumbnailUrl;
  late String quantity;

  Item(
      {required this.categoryId,
      required this.productDescription,
      required this.productTitle,
      required this.priceTitle,
      required this.productId,
      required this.publishedDate,
      required this.sellerName,
      required this.sellerUID,
      required this.status,
      required this.thumbnailUrl,
      required this.quantity});

  Item.fromJson(Map<String, dynamic> json) {
    categoryId = json["categoryId"];
    productDescription = json["productDescription"];
    productTitle = json["productTitle"];
    priceTitle = json["priceTitle"];
    productId = json["productId"];
    publishedDate = json["publishedDate"];
    sellerName = json["sellerName"];
    sellerUID = json["sellerUID"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
    quantity = json["quantity"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();

    data["categoryId"] = categoryId;
    data["productDescription"] = productDescription;
    data["productTitle"] = productTitle;
    data["priceTitle"] = priceTitle;
    data["productId"] = productId;
    data["publishedDate"] = publishedDate;
    data["sellerName"] = sellerName;
    data["sellerUID"] = sellerUID;
    data["status"] = status;
    data["thumbnailUrl"] = thumbnailUrl;
    data["quantity"] = quantity;

    return data;
  }
}
