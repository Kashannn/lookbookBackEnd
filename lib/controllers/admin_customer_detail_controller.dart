import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Model/user/user_model.dart';
import '../utils/components/constant/app_images.dart';
import '../utils/components/constant/snackbar.dart';

class AdminCustomerDetailController extends GetxController {
  final UserModel customer;
  AdminCustomerDetailController(this.customer);
  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0] + nameParts[1][0];
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0];
    }
    return '';
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

  Future<void> blockUser(UserModel customer) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(customer.userId)
          .update({'isBlocked': true});
      CustomSnackBars.instance.showSuccessSnackbar(
        title: "Blocked",
        message: "${customer.fullName} has been blocked successfully",
      );
    } catch (e) {
      print("Error blocking customer: $e");
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error",
        message: "Failed to block ${customer.fullName}",
      );
    }
  }



}