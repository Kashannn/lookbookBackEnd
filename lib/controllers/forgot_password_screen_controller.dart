import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Firebase/firebase_authentication_services.dart';
import '../utils/validations/validator.dart';

class ForgotPasswordController extends GetxController {
  final forgotPasswordController = TextEditingController();
  final emailErrorText = ''.obs;
  final isButtonActive = false.obs;
  final FirebaseAuthenticationServices _authService =
      Get.put(FirebaseAuthenticationServices());

  @override
  void onInit() {
    super.onInit();
    forgotPasswordController.addListener(_validateEmail);
  }

  @override
  void onReady() {
    super.onReady();
    _resetFields();
  }

  void _validateEmail() {
    emailErrorText.value =
        ValidationService.validateEmail(forgotPasswordController.text) ?? '';
    _validateForm();
  }

  void _validateForm() {
    isButtonActive.value = emailErrorText.value.isEmpty;
  }

  void _resetFields() {
    forgotPasswordController.clear();
    emailErrorText.value = '';
    isButtonActive.value = false;
  }

  @override
  void onClose() {
    forgotPasswordController.dispose();
    super.onClose();
  }

  void submit() async {
    if (isButtonActive.value) {
      bool result = await _authService .forgetPassword(forgotPasswordController.text.trim());
      clearForm();
      if (result) {
        Get.back();
        Get.toNamed('signin');
      }
    }
  }

  void clearForm() {
    forgotPasswordController.clear();
    emailErrorText.value = '';
    isButtonActive.value = false;
  }
}
