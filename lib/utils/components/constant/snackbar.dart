import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'app_colors.dart';

class CustomSnackBars {
  // Private constructor
  CustomSnackBars._privateConstructor();

  // Singleton instance variable
  static CustomSnackBars? _instance;
  static CustomSnackBars get instance {
    _instance ??= CustomSnackBars._privateConstructor();
    return _instance!;
  }

  // Method to show success snackbar
  void showSuccessSnackbar({
    required String title,
    required String message,
    int duration = 3,
  }) {
    Get.snackbar(
      title,
      message,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      backgroundColor: AppColors.secondary,
      colorText: Colors.white,
      leftBarIndicatorColor: const Color(0xFFFF9F00),
      progressIndicatorBackgroundColor: AppColors.primaryColor,
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 800),
      snackPosition: SnackPosition.TOP,
      borderRadius: 10.0,
      borderWidth: 2.0,
      borderColor: AppColors.primaryColor,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'Dismiss',
          style: TextStyle(
              color: AppColors.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      icon: Icon(Icons.check_circle_rounded,
          color: AppColors.primaryColor, size: 30.0),
      shouldIconPulse: true,
      messageText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      titleText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Method to show failure snackbar
  void showFailureSnackbar({
    required String title,
    required String message,
    int duration = 3,
  }) {
    Get.snackbar(
      title,
      message,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      backgroundColor: AppColors.secondary,
      colorText: Colors.white,
      leftBarIndicatorColor: AppColors.primaryColor,
      progressIndicatorBackgroundColor: AppColors.secondary,
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 800),
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 10.0,
      borderWidth: 2.0,
      borderColor: AppColors.primaryColor,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'Dismiss',
          style: TextStyle(
              color: AppColors.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      icon: Icon(Icons.warning, color: AppColors.primaryColor, size: 30.0),
      shouldIconPulse: true,
      messageText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      titleText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  SnackbarController customSnackBar(
      {required String message, required Color color}) {
    return Get.showSnackbar(GetSnackBar(
      backgroundColor: color,
      message: message,
      duration: const Duration(seconds: 2),
    ));
  }

  void showToast({required String message}) {
    Fluttertoast.showToast(
      msg: message,
      fontSize: 14,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
