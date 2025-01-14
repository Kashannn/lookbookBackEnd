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
import '../utils/components/constant/snackbar.dart';
import '../views/Designer/designer_main_screen.dart';

class AddProductController extends GetxController {
  final FirebaseAddProductServices addProductServices =
      FirebaseAddProductServices();
  final RxList<Color> selectedColors = <Color>[].obs;
  final RxList<ImageModel> editSelectedImages = <ImageModel>[].obs;
  final List<File> selectedImages = <File>[].obs;
  final RxString selectedSize = ''.obs;
  var selectedDate = DateTime.now().obs;
  List<String> selectedSizes = <String>[].obs;
  var isLoading = false.obs;
  final designerNameController = TextEditingController();
  final categoryController = TextEditingController();
  final dressController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final socialController = TextEditingController();
  final barCodeController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final eventController = TextEditingController();
  final eventDateController = TextEditingController();
  final colorController = TextEditingController();
  final sizeController = TextEditingController();
  var categories = <String>[].obs;
  var socialLinks = <Map<String, String>>[].obs;
  final isButtonActive = false.obs;
  final RxString _emailErrorText = ''.obs;
  final RxString _barCodeErrorText = ''.obs;
  final RxString _categoryErrorText = ''.obs;
  final RxString _descriptionErrorText = ''.obs;
  final RxString _priceErrorText = ''.obs;
  final RxString selectedImagePath = ''.obs;
  var selectedCategory = ''.obs;

  final FocusNode designerNameFocusNode = FocusNode();
  final FocusNode categoryFocusNode = FocusNode();
  final FocusNode dressFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode colorFocusNode = FocusNode();
  final FocusNode sizeFocusNode = FocusNode();
  final FocusNode quantityFocusNode = FocusNode();
  final FocusNode socialFocusNode = FocusNode();
  final FocusNode barCodeFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode eventFocusNode = FocusNode();
  final FocusNode eventDateFocusNode = FocusNode();
  Color pickerColor = Colors.blue;
  String? get emailErrorText =>
      _emailErrorText.value.isEmpty ? null : _emailErrorText.value;
  String? get barCodeErrorText =>
      _barCodeErrorText.value.isEmpty ? null : _barCodeErrorText.value;
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
    barCodeController.addListener(_validateField);
    priceController.addListener(_validateField);
    descriptionController.addListener(_validateField);
    categoryController.addListener(_validateField);
  }

  void _validateField() {
    final errors = ValidationService.validateFields(
      category: categoryController.text,
      price: priceController.text,
      description: descriptionController.text,
      barCode: barCodeController.text,
    );

    _priceErrorText.value = errors['price'] ?? '';
    _descriptionErrorText.value = errors['description'] ?? '';

    _emailErrorText.value = errors['email'] ?? '';

    _validateForm();
  }

  void addSocialLink(String title, String link) {
    socialLinks.add({'title': title, 'link': link});
  }

  void _validateForm() {
    isButtonActive.value = _emailErrorText.value.isEmpty &&
        _barCodeErrorText.value.isEmpty &&
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
    isLoading.value = true;
    try {
      if (selectedCategory.value.isEmpty) {
        Get.snackbar('Error', 'Please select a category');
        isLoading.value = false;
        return null;
      }
      List<String> imageUrls = [];
      for (var image in selectedImages) {
        String imageUrl = await uploadImageToFirebase(image.path);
        imageUrls.add(imageUrl);
      }
      final AddProductModel product = AddProductModel(
        userId: FirebaseAuth.instance.currentUser!.uid,
        designerName: designerNameController.text,
        category: [selectedCategory.value],
        dressTitle: dressController.text,
        price: priceController.text,
        productDescription: descriptionController.text,
        colors: selectedColors
            .map((color) => color.value.toRadixString(16))
            .toList(),
        sizes: selectedSizes,
        minimumOrderQuantity: quantityController.text,
        socialLinks: socialLinks
            .map((link) => {
                  'title': link['title'],
                  'link': link['link'],
                })
            .toList(),
        images: imageUrls,
        barCode: barCodeController.text,
        email: emailController.text,
        phone: phoneController.text,
        event: eventController.text,
        eventDate: selectedDate.value,
        createdAt: DateTime.now(),
      );
      DocumentReference docRef = await addProductServices.saveProduct(product);
      String docId = docRef.id;
      CustomSnackBars.instance.showSuccessSnackbar(
        title: 'Success',
        message: 'Product saved successfully!',
      );
      return docId;
    } catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: 'Error saving product');
      return null;
    } finally {
      clearForm();
      isLoading.value = false;
    }
  }

  void clearForm() {
    designerNameController.clear();
    categoryController.clear();
    dressController.clear();
    dressController.clear();
    priceController.clear();
    descriptionController.clear();
    quantityController.clear();
    socialController.clear();
    barCodeController.clear();
    emailController.clear();
    selectedCategory.value = '';
    selectedColors.clear();
    selectedImages.clear();
    socialLinks.clear();
    selectedSize.value = '';
    _priceErrorText.value = '';
    _descriptionErrorText.value = '';
    _barCodeErrorText.value = '';
    _emailErrorText.value = '';
    eventController.clear();
    isButtonActive.value = false;
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
    barCodeController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> fetchProductData(String productId) async {
    try {
      editSelectedImages.clear();
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('DesignerProducts')
          .doc(productId)
          .get();
      if (productSnapshot.exists) {
        final data = productSnapshot.data() as Map<String, dynamic>;
        designerNameController.text = data['designerName'] ?? '';
        dressController.text = data['dressTitle'] ?? '';
        selectedCategory.value =
            data['category'] != null ? data['category'][0] ?? '' : '';
        priceController.text = data['price'] ?? '';
        descriptionController.text = data['productDescription'] ?? '';
        quantityController.text = data['minimumOrderQuantity'] ?? '';
        barCodeController.text = data['barCode'] ?? '';
        eventController.text = data['event'] ?? '';

        if (data['eventDate'] != null) {
          DateTime eventDate = (data['eventDate'] as Timestamp).toDate();
          selectedDate.value = eventDate;
          eventDateController.text = _formatDate(eventDate);
        } else {
          selectedDate.value = DateTime.now();
          eventDateController.text = _formatDate(DateTime.now());
        }

        selectedSize.value = data['sizes'] != null && data['sizes'].isNotEmpty
            ? data['sizes'][0]
            : '';

        selectedColors.value = List<Color>.from(data['colors']
                ?.map((color) => Color(int.parse(color, radix: 16))) ??
            []);

        List<String> imageUrls = List<String>.from(data['images']);
        for (String url in imageUrls) {
          if (!editSelectedImages.any((imageModel) => imageModel.url == url)) {
            editSelectedImages.add(ImageModel(url: url));
          }
        }
      }
    } catch (e) {
      print('Error fetching product data: $e');
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  Future<void> updateProductData(String productId) async {
    isLoading.value = true;
    try {
      List<String> newImageUrls = [];
      for (var image in selectedImages) {
        String imageUrl = await uploadImageToFirebase(image.path);
        newImageUrls.add(imageUrl);
      }
      List<String> finalImageUrls =
          editSelectedImages.map((img) => img.url!).toList();
      finalImageUrls.addAll(newImageUrls);
      await FirebaseFirestore.instance
          .collection('DesignerProducts')
          .doc(productId)
          .update({
        'designerName': designerNameController.text,
        'category': [selectedCategory.value],
        'colors': selectedColors
            .map((color) => color.value.toRadixString(16))
            .toList(),
        'sizes': selectedSizes,
        'minimumOrderQuantity': quantityController.text,
        'barCode': barCodeController.text,
        'dressTitle': dressController.text,
        'price': priceController.text,
        'productDescription': descriptionController.text,
        'email': emailController.text,
        'event': eventController.text,
        'eventDate': selectedDate.value,
        'phone': phoneController.text,
        'socialLinks': socialLinks
            .map((link) => {
                  'title': link['title'],
                  'link': link['link'],
                })
            .toList(),
        'images': finalImageUrls,
      });
      CustomSnackBars.instance.showSuccessSnackbar(
        title: 'Success',
        message: 'Product updated successfully!',
      );
      Get.offAll(DesignerMainScreen());
    } catch (e) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: 'Error',
        message: 'Error updating product: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void removeFirebaseImage(int index) {
    if (index >= 0 && index < editSelectedImages.length) {
      editSelectedImages.removeAt(index);
    }
  }
}
