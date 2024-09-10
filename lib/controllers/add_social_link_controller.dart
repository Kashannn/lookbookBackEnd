import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSocialLinkController extends GetxController {
  final titleController = TextEditingController();
  final linkController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode linkFocusNode = FocusNode();

  @override
  void onClose() {
    titleController.dispose();
    linkController.dispose();
    super.onClose();
  }
}
