import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookbook/utils/components/constant/snackbar.dart';

import '../views/Designer/edit_product_screen.dart';

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
      CustomSnackBars.instance.showFailureSnackbar(title: 'Error', message:  'User is not logged in');
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
      CustomSnackBars.instance.showSuccessSnackbar(title: 'Success', message: 'Category added');
    } catch (e) {
      CustomSnackBars.instance.showFailureSnackbar(title: 'Error', message:  'Failed to add category to Firebase: $e');
    }
  }

  Future<void> fetchCategoriesFromFirebase() async {
    String userId = currentUserId;

    if (userId.isEmpty) {
      CustomSnackBars.instance.showFailureSnackbar(title: 'Error', message:  'User is not logged in');
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
      CustomSnackBars.instance.showFailureSnackbar(title: 'Error', message:  'Failed to load categories: $e');

    }
  }

  Future<void> deleteCategory(String category) async {
    String userId = currentUserId;
    if (userId.isEmpty) {
      CustomSnackBars.instance.showFailureSnackbar(title: 'Error', message:  'User is not logged in');
      return;
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('categories')
          .where('categoryName', isEqualTo: category)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        CustomSnackBars.instance.showSuccessSnackbar(title: 'Success', message:  'Category deleted successfully!');

        fetchCategoriesFromFirebase();
        Get.back();
      } else {
        CustomSnackBars.instance.showFailureSnackbar(title: 'Error', message:  'Category not found in Firebase');
      }
    } catch (e) {
      CustomSnackBars.instance.showFailureSnackbar(title: 'Error', message:  'Failed to delete category: $e');

    }
  }

  @override
  void onClose() {
    categoryController.dispose();
    super.onClose();
  }
}
