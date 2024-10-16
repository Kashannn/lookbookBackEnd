import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Firebase/firebase_customerEnd_services.dart';
import '../Model/user/user_model.dart';

class MessageReportController extends GetxController {
  var isLoading = false.obs;
  UserModel? reportedUserModel;
  Future<void> fetchReportedUser(String userId) async {
    try {
      isLoading.value = true;
      UserModel? user = await FirebaseCustomerEndServices().fetchUser(userId);
      if (user != null) {
        reportedUserModel = user;
      } else {
        Get.snackbar("Error", "No user found.",
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data: $e",
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> blockUser() async {
    if (reportedUserModel == null) {
      Get.snackbar("Error", "No user found to block.",
          snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      isLoading.value = true;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(reportedUserModel!.userId)
          .update({'isBlocked': true});
      Get.snackbar("Blocked",
          "${reportedUserModel!.fullName} has been blocked successfully",
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar("Error", "Failed to block the user: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
