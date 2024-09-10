import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lookbook/utils/validations/validator.dart';

class AddPhotographerController extends GetxController {
  final nameController = TextEditingController();
  final socialController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final isFormComplete = false.obs;
  final RxString _emailErrorText = ''.obs;
  final RxString selectedImagePath = ''.obs;

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode socialFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  String? get emailErrorText =>
      _emailErrorText.value.isEmpty ? null : _emailErrorText.value;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateEmail);
  }

  void _validateEmail() {
    _emailErrorText.value =
        ValidationService.validateEmail(emailController.text) ?? '';
    _validateForm();
  }

  void _validateForm() {
    isFormComplete.value = nameController.text.isNotEmpty &&
        socialController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        selectedImagePath.isNotEmpty &&
        _emailErrorText.value.isEmpty;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    }
    _validateForm(); // Revalidate form after image selection
  }

  @override
  void onClose() {
    nameController.dispose();
    socialController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
