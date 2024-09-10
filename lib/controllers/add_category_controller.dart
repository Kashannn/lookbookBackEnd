import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCategoryController extends GetxController {
  final categoryController = TextEditingController();

  final FocusNode categoryFocusNode = FocusNode();

  @override
  void onClose() {
    categoryController.dispose();

    super.onClose();
  }
}
