import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Model/user/user_model.dart';
import '../utils/components/constant/app_images.dart';

class ReportProfileController extends GetxController {
  UserModel? userModel;
  var isLoading = true.obs;

  Future<void> fetchUserDetails(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        Get.snackbar("Error", "User not found.",
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user details: $e",
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  SvgPicture getSocialIcon(String url) {
    if (url.contains('facebook')) {
      return SvgPicture.asset(AppImages.facebook);
    } else if (url.contains('instagram')) {
      return SvgPicture.asset(AppImages.instagram);
    } else if (url.contains('whatsapp')) {
      return SvgPicture.asset(AppImages.whatsapp);
    } else if (url.contains('snapchat')) {
      return SvgPicture.asset(AppImages.snapchat);
    } else if (url.contains('tiktok')) {
      return SvgPicture.asset(AppImages.tiktok);
    } else if (url.contains('youtube')) {
      return SvgPicture.asset(AppImages.youTube);
    } else if (url.contains('linkedin')) {
      return SvgPicture.asset(AppImages.linkedIn);
    } else if (url.contains('twitter')) {
      return SvgPicture.asset(AppImages.twitter);
    } else if (url.contains('pinterest')) {
      return SvgPicture.asset(AppImages.pinterest);
    } else {
      return SvgPicture.asset(AppImages.social);
    }
  }
}
