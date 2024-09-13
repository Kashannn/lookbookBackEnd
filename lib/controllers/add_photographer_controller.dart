import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lookbook/utils/validations/validator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

import '../Model/AddProductModel/add_photographer_model.dart';
import '../views/Designer/designer_main_screen.dart';

class AddPhotographerController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  var socialLinks = <Map<String, String>>[].obs;
  final isFormComplete = false.obs;
  final RxString _emailErrorText = ''.obs;
  final RxString selectedImagePath = ''.obs;

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode socialFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final isLoading = false.obs;

  String? get emailErrorText =>
      _emailErrorText.value.isEmpty ? null : _emailErrorText.value;

  String get currentUserId {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  void addSocialLink(String title, String link) {
    if (title.isNotEmpty && link.isNotEmpty) {
      socialLinks.add({'title': title, 'link': link});
      _validateForm();
    }
  }

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

  // Validate the entire form
  void _validateForm() {
    isFormComplete.value = nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        selectedImagePath.isNotEmpty &&
        _emailErrorText.value.isEmpty &&
        socialLinks.isNotEmpty;
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
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image');
    }
  }

  Future<void> savePhotographerDetails(String productId) async {
    isLoading.value = true;
    String userId = currentUserId;
    if (userId.isEmpty) {
      Get.snackbar('Error', 'User is not logged in');
      return;
    }

    try {
      String imageUrl = await uploadImageToFirebase(selectedImagePath.value);
      final photographer = AddPhotographerModel(
        name: nameController.text,
        image: imageUrl,
        email: emailController.text,
        phone: phoneController.text,
        socialLinks: socialLinks
            .map((link) => {
                  'title': link['title'],
                  'link': link['link'],
                })
            .toList(),
      );

      CollectionReference photographerRef = FirebaseFirestore.instance
          .collection('DesignerProducts')
          .doc(productId)
          .collection('photographers');
      await photographerRef.add(photographer.toMap());
      clearForm();
      Get.snackbar('Success', 'Photographer details added successfully!');
      Get.to(() => DesignerMainScreen());
    } catch (e) {
      Get.snackbar('Error', 'Failed to add photographer details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    socialLinks.clear();
    selectedImagePath.value = '';
    isFormComplete.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
