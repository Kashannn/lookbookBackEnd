import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId, fullName, email, role, imageUrl, phone, deviceToken, about;
  List<Map<String, String?>> socialLinks;
  List<DocumentReference>? products;
  bool isBlocked;
  UserModel({
    this.userId,
    this.email,
    this.fullName,
    this.role,
    this.imageUrl,
    this.deviceToken,
    this.phone,
    this.about,
    List<Map<String, String?>>? socialLinks,
    this.products,
    this.isBlocked = false,
  }) : socialLinks = socialLinks ?? [];
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'role': role,
      'profileImageUrl': imageUrl,
      'phone': phone,
      'about': about,
      'deviceToken': deviceToken,
      'socialLinks': socialLinks,
      'products': products?.map((ref) => ref.path).toList(),
      'isBlocked': isBlocked,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      deviceToken: map['deviceToken'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      imageUrl: map['profileImageUrl'] ?? '',
      phone: map['phone'] ?? '',
      about: map['about'] ?? '',
      socialLinks: List<Map<String, String?>>.from(
          map['socialLinks']?.map((item) => Map<String, String?>.from(item)) ??
              []),
      products: (map['products'] as List<dynamic>?)
          ?.map((item) {
            if (item is DocumentReference) {
              return item;
            } else if (item is String) {
              return FirebaseFirestore.instance.doc(item);
            }
            return null;
          })
          .where((ref) => ref != null)
          .cast<DocumentReference>()
          .toList(),
      isBlocked: map['isBlocked'] ?? false,
    );
  }
}
