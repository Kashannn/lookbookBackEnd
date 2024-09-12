import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lookbook/utils/validations/validator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

import '../Model/AddProductModel/add_photographer_model.dart';

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
    _validateForm();
  }

  Future<String> uploadImageToFirebase(String imagePath) async {
    File file = File(imagePath);
    String fileName = basename(file.path);

    try {
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('photographers/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL =
          await taskSnapshot.ref.getDownloadURL(); // Get the URL after upload
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image');
    }
  }

  Future<void> savePhotographerDetails() async {
    try {
      String imageUrl = await uploadImageToFirebase(selectedImagePath.value);
      final photographer = AddPhotographerModel(
        name: nameController.text,
        image: imageUrl,
        email: emailController.text,
        phone: phoneController.text,
        socialLinks: [socialController.text],
      );
      await FirebaseFirestore.instance
          .collection('DesignerProducts')
          .add(photographer.toMap());

      clearForm();
      Get.snackbar('Success', 'Photographer details added successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add photographer details: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    socialController.clear();
    phoneController.clear();
    emailController.clear();
    selectedImagePath.value = '';
    isFormComplete.value = false;
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
