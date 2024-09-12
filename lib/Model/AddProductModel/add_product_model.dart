import 'package:flutter/material.dart';

class AddProductModel {
  String? userId;
  List<String>? category;
  String? dressTitle;
  String? price;
  String? productDescription;
  List<String>? colors;
  List<String>? sizes;
  String? minimumOrderQuantity;
  List<String>? socialLinks;
  List<String>? images;
  String? phone;
  String? email;

  AddProductModel({
    this.userId,
    this.category,
    this.dressTitle,
    this.price,
    this.productDescription,
    this.colors,
    this.sizes,
    this.minimumOrderQuantity,
    this.socialLinks,
    this.images,
    this.phone,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'category': category,
      'dressTitle': dressTitle,
      'price': price,
      'productDescription': productDescription,
      'colors': colors,
      'sizes': sizes,
      'minimumOrderQuantity': minimumOrderQuantity,
      'socialLinks': socialLinks,
      'images': images,
      'phone': phone,
      'email': email,
    };
  }

  factory AddProductModel.fromMap(Map<String, dynamic> map) {
    return AddProductModel(
      userId: map['userId'] ?? '',
      category: List<String>.from(map['category'] ?? []),
      dressTitle: map['dressTitle'] ?? '',
      price: map['price'] ?? '',
      productDescription: map['productDescription'] ?? '',
      colors: List<String>.from(map['colors'] ?? []),
      sizes: List<String>.from(map['sizes'] ?? []),
      minimumOrderQuantity: map['minimumOrderQuantity'] ?? '',
      socialLinks: List<String>.from(map['socialLinks'] ?? []),
      images: List<String>.from(map['images'] ?? []),
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
    );
  }
}

