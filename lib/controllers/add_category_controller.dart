import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCategoryController extends GetxController {
  final categoryController = TextEditingController();
  var categories = <String>[].obs;
  final FocusNode categoryFocusNode = FocusNode();
  String get currentUserId {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }
  @override
  void onInit() {
    super.onInit();
    fetchCategoriesFromFirebase();
  }
  Future<void> addCategoryToFirebase(String category) async {
    String userId = currentUserId;

    if (userId.isEmpty) {
      Get.snackbar('Error', 'User is not logged in');
      return;
    }

    CollectionReference categoriesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('categories');
    try {
      await categoriesRef.add({
        'categoryName': category,
      });
      categories.add(category);
      Get.snackbar('Success', 'Category added to Firebase');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add category to Firebase: $e');
    }
  }
  Future<void> fetchCategoriesFromFirebase() async {
    String userId = currentUserId;

    if (userId.isEmpty) {
      Get.snackbar('Error', 'User is not logged in');
      return;
    }

    CollectionReference categoriesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('categories');

    try {
      QuerySnapshot querySnapshot = await categoriesRef.get();
      categories.clear();
      for (var doc in querySnapshot.docs) {
        categories.add(doc['categoryName']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories: $e');
    }
  }

  @override
  void onClose() {
    categoryController.dispose();
    super.onClose();
  }
}
