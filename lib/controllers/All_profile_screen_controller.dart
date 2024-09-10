import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AllProfileScreenController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  String? userId;
  String? originalName;
  String? originalEmail;
  String? originalPassword;
  String? profileImageUrl;
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

  Future<void> fetchUserData() async {
    if (userId != null) {
      isLoading.value = true;
      try {
        DocumentSnapshot userSnapshot =
            await firestore.collection('users').doc(userId).get();
        if (userSnapshot.exists) {
          var userData = userSnapshot.data() as Map<String, dynamic>;
          nameController.text = userData['fullName'] ?? '';
          emailController.text = userData['email'] ?? '';
          passwordController.text = userData['password'] ?? '******';
          profileImageUrl = userData['profileImageUrl'] ?? '';

          originalName = userData['fullName'] ?? '';
          originalEmail = userData['email'] ?? '';
          originalPassword = userData['password'] ?? '******';
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

  // Function to update user data
  Future<void> updateUserData() async {
    if (userId != null) {
      bool hasChanges = false;
      Map<String, dynamic> updatedData = {};

      if (nameController.text != originalName) {
        updatedData['fullName'] = nameController.text;
        hasChanges = true;
      }

      if (emailController.text != originalEmail) {
        updatedData['email'] = emailController.text;
        hasChanges = true;
      }

      if (passwordController.text != originalPassword &&
          passwordController.text != '******') {
        updatedData['password'] = passwordController.text;
        hasChanges = true;
      }

      if (hasChanges) {
        try {
          isUpdating.value = true;
          await firestore.collection('users').doc(userId).update(updatedData);
          Get.snackbar('Success', 'Profile updated successfully',
              snackPosition: SnackPosition.BOTTOM);
        } catch (e) {
          Get.snackbar('Error', 'Error updating profile: $e',
              snackPosition: SnackPosition.BOTTOM);
        } finally {
          isUpdating.value = false;
        }
      } else {
        Get.snackbar('No Changes', 'No changes were made',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  Future<void> uploadProfilePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      try {
        isUpdating.value = true;
        TaskSnapshot uploadTask =
            await storage.ref('profile_images/$userId').putFile(imageFile);

        String downloadUrl = await uploadTask.ref.getDownloadURL();
        profileImageUrl = downloadUrl;
        await firestore.collection('users').doc(userId).update({
          'profileImageUrl': profileImageUrl,
        });

        Get.snackbar('Success', 'Profile picture updated successfully',
            snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar('Error', 'Error uploading profile picture: $e',
            snackPosition: SnackPosition.BOTTOM);
      } finally {
        isUpdating.value = false; // Stop loading indicator
      }
    }
  }

  // Get initials from full name
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
    passwordController.dispose();
    super.onClose();
  }
}
