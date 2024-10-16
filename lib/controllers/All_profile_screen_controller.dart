import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../utils/components/constant/snackbar.dart';

class AllProfileScreenController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final aboutController = TextEditingController();
  var socialLinks = <Map<String, String>>[].obs;
  File? selectedProfileImage;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  String? userId;
  String? originalPhone;
  String? originalName;
  String? originalEmail;
  String? profileImageUrl;
  String? originalAbout;
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  void getUserData() {
    final User? user = auth.currentUser;
    if (user != null) {
      userId = user.uid;
      fetchUserData();
    } else {
      print("No user is logged in");
    }
  }

  // Function to add social links to the list
  void addSocialLink(String title, String link) {
    socialLinks.add({'title': title, 'link': link});
  }

  Future<void> fetchUserData() async {
    if (userId != null) {
      isLoading.value = true;
      try {
        DocumentSnapshot userSnapshot =
            await firestore.collection('users').doc(userId).get();
        if (userSnapshot.exists) {
          var userData = userSnapshot.data() as Map<String, dynamic>;
          nameController.text = userData['fullName'] ?? '';
          phoneController.text = userData['phone'] ?? '';
          emailController.text = userData['email'] ?? '';
          profileImageUrl = userData['profileImageUrl'] ?? '';
          aboutController.text = userData['about'] ?? '';
          originalName = userData['fullName'] ?? '';
          originalPhone = userData['phone'] ?? '';
          originalEmail = userData['email'] ?? '';

          // Fetch social links if they exist
          List<dynamic>? socialLinksData = userData['socialLinks'];
          if (socialLinksData != null) {
            socialLinks.value = List<Map<String, String>>.from(
                socialLinksData.map((link) => Map<String, String>.from(link)));
          }
        } else {
          print('User not found');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<bool> updateEmail(String newEmail) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    try {
      await user!.verifyBeforeUpdateEmail(newEmail);
      return true;
    } catch (e) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: 'Error',
        message: '$e',
      );
      return false;
    }
  }

  Future<void> updateUserData() async {
    if (userId != null) {
      bool hasChanges = false;
      Map<String, dynamic> updatedData = {};
      if (nameController.text != originalName) {
        updatedData['fullName'] = nameController.text;
        hasChanges = true;
      }

      if (phoneController.text != originalPhone) {
        updatedData['phone'] = phoneController.text;
        hasChanges = true;
      }

      if (emailController.text != originalEmail) {
        updatedData['email'] = emailController.text;
        hasChanges = true;
      }

      if (aboutController.text.isNotEmpty) {
        updatedData['about'] = aboutController.text;
        hasChanges = true;
      }

      if (socialLinks.isNotEmpty) {
        updatedData['socialLinks'] = socialLinks
            .map((link) => {'title': link['title'], 'link': link['link']})
            .toList();
        hasChanges = true;
      }

      if (selectedProfileImage != null) {
        try {
          TaskSnapshot uploadTask = await storage
              .ref('profile_images/$userId')
              .putFile(selectedProfileImage!);
          String downloadUrl = await uploadTask.ref.getDownloadURL();
          updatedData['profileImageUrl'] = downloadUrl;
          hasChanges = true;
        } catch (e) {
          CustomSnackBars.instance.showFailureSnackbar(
            title: 'Error',
            message: "Error uploading profile picture: $e",
          );
        }
      }

      if (hasChanges) {
        try {
          isUpdating.value = true;
          if (emailController.text != originalEmail) {
            User? user = auth.currentUser;
            if (user != null) {
              await user.verifyBeforeUpdateEmail(emailController.text);
              await firestore
                  .collection('users')
                  .doc(userId)
                  .update(updatedData);
              CustomSnackBars.instance.showSuccessSnackbar(
                title: 'Email Verification',
                message:
                    'A verification email has been sent to ${emailController.text}. Please verify it.',
              );
            }
          } else {
            await firestore.collection('users').doc(userId).update(updatedData);
            CustomSnackBars.instance.showSuccessSnackbar(
              title: 'Success',
              message: "Profile updated successfully.",
            );
          }

          Get.offAll(() => AuthWrapper());
        } catch (e) {
          CustomSnackBars.instance.showFailureSnackbar(
            title: 'Error',
            message: "Error updating profile: $e",
          );
        } finally {
          isUpdating.value = false;
        }
      } else {
        CustomSnackBars.instance.showSuccessSnackbar(
          title: 'No Changes',
          message: "No changes made.",
        );
      }
    }
  }

  Future<void> uploadProfilePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedProfileImage = File(pickedFile.path);
      update();
    }
  }

  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0] + nameParts[1][0];
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0];
    }
    return '';
  }

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    aboutController.dispose();
    super.onClose();
  }
}
