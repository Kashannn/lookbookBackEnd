import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lookbook/utils/validations/validator.dart';
import 'package:path/path.dart';

import '../Firebase/firebase_addproduct_services.dart';
import '../Model/AddProductModel/add_product_model.dart';

class AddProductController extends GetxController {
  final FirebaseAddProductServices addProductServices =
      FirebaseAddProductServices();
  final RxList<Color> selectedColors = <Color>[].obs;
  final RxString selectedSize = ''.obs;
  final categoryController = TextEditingController();
  final dressController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final socialController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final colorController = TextEditingController();
  final sizeController = TextEditingController();

  var categories = <String>[].obs;
  final isButtonActive = false.obs;
  final RxString _emailErrorText = ''.obs;
  final RxString _phoneErrorText = ''.obs;
  final RxString _categoryErrorText = ''.obs;
  final RxString _descriptionErrorText = ''.obs;
  final RxString _priceErrorText = ''.obs;
  final RxString selectedImagePath = ''.obs;
  final List<File> selectedImages = <File>[].obs;
  var selectedCategory = ''.obs;

  final FocusNode categoryFocusNode = FocusNode();
  final FocusNode dressFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode colorFocusNode = FocusNode();
  final FocusNode sizeFocusNode = FocusNode();
  final FocusNode quantityFocusNode = FocusNode();
  final FocusNode socialFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  Color pickerColor = Colors.blue;

  String? get emailErrorText =>
      _emailErrorText.value.isEmpty ? null : _emailErrorText.value;
  String? get phoneErrorText =>
      _phoneErrorText.value.isEmpty ? null : _phoneErrorText.value;
  String? get categoryErrorText =>
      _categoryErrorText.value.isEmpty ? null : _categoryErrorText.value;
  String? get descriptionErrorText =>
      _descriptionErrorText.value.isEmpty ? null : _descriptionErrorText.value;
  String? get priceErrorText =>
      _priceErrorText.value.isEmpty ? null : _priceErrorText.value;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateField);
    phoneController.addListener(_validateField);
    priceController.addListener(_validateField);
    descriptionController.addListener(_validateField);
    categoryController.addListener(_validateField);
  }

  void _validateField() {
    final errors = ValidationService.validateFields(
      category: categoryController.text,
      price: priceController.text,
      description: descriptionController.text,
      phone: phoneController.text,
      email: emailController.text,
    );

    _priceErrorText.value = errors['price'] ?? '';
    _descriptionErrorText.value = errors['description'] ?? '';
    _phoneErrorText.value = errors['phone'] ?? '';
    _emailErrorText.value = errors['email'] ?? '';

    _validateForm();
  }

  void _validateForm() {
    isButtonActive.value = _emailErrorText.value.isEmpty &&
        _phoneErrorText.value.isEmpty &&
        _priceErrorText.value.isEmpty &&
        _descriptionErrorText.value.isEmpty &&
        selectedCategory.value.isNotEmpty &&
        selectedImages.isNotEmpty;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      int remainingSlots = 5 - selectedImages.length;
      if (pickedFiles.length > remainingSlots) {
        Get.snackbar(
            'Limit Reached', 'You can only select a total of 5 images.');
        for (var i = 0; i < remainingSlots; i++) {
          selectedImages.add(File(pickedFiles[i].path));
        }
      } else {
        for (var pickedFile in pickedFiles) {
          selectedImages.add(File(pickedFile.path));
        }
      }
    }
    _validateForm();
  }

  Future<String> uploadImageToFirebase(String imagePath) async {
    File file = File(imagePath);
    String fileName = basename(file.path);

    try {
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('Products/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image');
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    _validateForm();
  }

  void addColor(Color color) {
    selectedColors.add(color);
  }

  void removeColor(int index) {
    selectedColors.removeAt(index);
  }

  void pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (Color color) {
              pickerColor = color;
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Select'),
            onPressed: () {
              addColor(pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<String?> saveProductData() async {
    try {
      if (selectedCategory.value.isEmpty) {
        Get.snackbar('Error', 'Please select a category');
        return null;
      }
      List<String> imageUrls = [];
      for (var image in selectedImages) {
        String imageUrl = await uploadImageToFirebase(image.path);
        imageUrls.add(imageUrl);
      }
      final AddProductModel product = AddProductModel(
        userId: FirebaseAuth.instance.currentUser!.uid,
        category: [selectedCategory.value],
        dressTitle: dressController.text,
        price: priceController.text,
        productDescription: descriptionController.text,
        colors: selectedColors
            .map((color) => color.value.toRadixString(16))
            .toList(),
        sizes: [selectedSize.value],
        minimumOrderQuantity: quantityController.text,
        socialLinks: [socialController.text],
        images: imageUrls,
        phone: phoneController.text,
        email: emailController.text,
      );
      DocumentReference docRef = await addProductServices.saveProduct(product);
      String docId = docRef.id;
      Get.snackbar('Success', 'Product saved successfully!');
      return docId;
    } catch (e) {
      Get.snackbar('Error', 'Failed to save product: $e');
      return null;
    }
  }

  @override
  void onClose() {
    categoryController.dispose();
    categoryFocusNode.dispose();
    dressController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    socialController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
