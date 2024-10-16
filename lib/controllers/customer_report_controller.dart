import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookbook/Model/user/user_model.dart';
import 'package:lookbook/controllers/sign_up_screen_controller.dart';
import '../../Model/AddProductModel/add_product_model.dart';
import '../Model/AddProductModel/product_reported_model.dart';
import '../Model/Chat/reports_model.dart';
import '../Notification/notification.dart';
import '../utils/components/constant/snackbar.dart';

class CustomerReportController extends GetxController {
  late AddProductModel product;
  TextEditingController reasonController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments as AddProductModel;
  }

  Future<UserModel?> fetchAdmin() async {
    try {
      final adminSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'ADMIN')
          .limit(1)
          .get();
      if (adminSnapshot.docs.isNotEmpty) {
        // Convert the document data to a UserModel
        return UserModel.fromMap(adminSnapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      print("Error fetching admin: $e");
      return null;
    }
  }

  // Method to report product and send notification
  Future<void> reportProduct(BuildContext context) async {
    final NotificationService notificationService = NotificationService();

    // Fetch admin's device token
    String? deviceToken = await _getAdminDeviceToken();
    print("Admin device token: $deviceToken");

    String reason = reasonController.text.trim();
    if (reason.isNotEmpty) {
      // Report the product
      UserModel? admin = await fetchAdmin();
      await ReportService.reportProduct(product, reason);
      print('Product reported successfully.');
      if (deviceToken != null) {
        await notificationService.sendPushNotification(
          'Product Reported',
          deviceToken,
          'A user has reported a product. Please review the report and take action.',
          admin!.userId! ?? '',
          "report",
          product.id ?? '',
          product.id ?? '',
        );
        print('Notification sent to admin.');
      } else {
        print('No admin device token found.');
      }

      // Show success message
      Get.back();
      CustomSnackBars.instance.showSuccessSnackbar(
        title: 'Success',
        message:
            'Your report has been submitted successfully. We will take action shortly.',
      );
    } else {
      CustomSnackBars.instance.showFailureSnackbar(
        title: 'Error!',
        message: 'Please enter a reason for reporting.',
      );
    }
  }

  //get report by productID and reportedBy
  Future<ProductReportedModel?> getReportByProductIdAndReportedBy(
      String productId, String reportedBy) async {
    final reportsCollection =
        FirebaseFirestore.instance.collection('ProductReported');
    final querySnapshot = await reportsCollection
        .where('productId', isEqualTo: productId)
        .where('reportedBy', isEqualTo: reportedBy)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      return ProductReportedModel.fromMap(
          doc.data() as Map<String, dynamic>, doc.id);
    } else {
      return null;
    }
  }

  Future<String?> _getAdminDeviceToken() async {
    try {
      final adminSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'ADMIN')
          .limit(1)
          .get();

      if (adminSnapshot.docs.isNotEmpty) {
        String deviceToken = adminSnapshot.docs.first.get('deviceToken');
        print('Admin device token found: $deviceToken');
        return deviceToken;
      } else {
        print('No admin user found with role ADMIN');
        return null;
      }
    } catch (e) {
      print('Error fetching admin device token: $e');
      return null;
    }
  }
}

class ReportService {
  static Future<void> reportProduct(
      AddProductModel product, String reason) async {
    final reportCollection =
        FirebaseFirestore.instance.collection('ProductReported');
    final reportedProduct = ProductReportedModel(
      productId: product.id ?? 'Unknown Product',
      reason: reason.isNotEmpty ? reason : 'No reason provided',
      reportedBy: FirebaseAuth.instance.currentUser!.uid,
      reportedDesigner: product.userId!,
      reportedAt: DateTime.now(),
    );
    await reportCollection.add(reportedProduct.toMap());
  }
}
