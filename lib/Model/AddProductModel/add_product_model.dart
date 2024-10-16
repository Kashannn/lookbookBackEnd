import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductModel {
  String? id;
  String? userId;
  String? designerName;
  List<String>? category;
  String? dressTitle;
  String? price;
  String? productDescription;
  List<String>? colors;
  List<String>? sizes;
  String? minimumOrderQuantity;
  final List<Map<String, String?>> socialLinks;
  List<String>? images;
  String? barCode;
  String? email;
  String? event;
  String? phone;
  DateTime? eventDate;
  DateTime? createdAt;
  DateTime? addedAt;

  AddProductModel({
    this.id,
    this.userId,
    this.designerName,
    this.category,
    this.dressTitle,
    this.price,
    this.productDescription,
    this.colors,
    this.sizes,
    this.minimumOrderQuantity,
    required this.socialLinks,
    this.images,
    this.barCode,
    this.email,
    this.event,
    this.phone,
    this.createdAt,
    this.eventDate,
    this.addedAt
  });

  factory AddProductModel.fromMap(Map<String, dynamic> map, String docId) {
    return AddProductModel(
      id: docId,
      userId: map['userId'],
      designerName: map['designerName'],
      category: List<String>.from(map['category'] ?? []),
      dressTitle: map['dressTitle'] ?? '',
      price: map['price'] ?? '',
      productDescription: map['productDescription'] ?? '',
      colors: List<String>.from(map['colors'] ?? []),
      sizes: List<String>.from(map['sizes'] ?? []),
      minimumOrderQuantity: map['minimumOrderQuantity'] ?? '',
      socialLinks: List<Map<String, String?>>.from(
          map['socialLinks']?.map((item) => Map<String, String?>.from(item)) ??
              []),
      images: List<String>.from(map['images'] ?? []),
      barCode: map['barCode'] ?? '',
      email: map['email'] ?? '',
      event: map['event'] ?? '',
      phone: map['phone'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      eventDate: (map['eventDate'] as Timestamp?)?.toDate(),
      addedAt: (map['addedAt'] as Timestamp?)?.toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'designerName': designerName,
      'category': category,
      'dressTitle': dressTitle,
      'price': price,
      'productDescription': productDescription,
      'colors': colors,
      'sizes': sizes,
      'minimumOrderQuantity': minimumOrderQuantity,
      'socialLinks': socialLinks,
      'images': images,
      'barCode': barCode,
      'email': email,
      'event': event,
      'phone': phone,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'eventDate': eventDate != null ? Timestamp.fromDate(eventDate!) : null,
      'addedAt': addedAt != null ? Timestamp.fromDate(addedAt!) : null,
    };
  }
}

class ImageModel {
  final File? file;
  final String? url;
  ImageModel({this.file, this.url});
  bool get isLocal => file != null;
}