import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:lookbook/Model/AddProductModel/add_product_model.dart';
import 'package:lookbook/Model/AddProductModel/product_reported_model.dart';

import '../Model/Chat/reports_model.dart';
import '../Model/user/user_model.dart';

class AllBuyerCustomerReportController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  var selectedIndex = 0.obs;
  final TextEditingController searchController = TextEditingController();

  RxList<ReportsModel> customerReportsList = RxList<ReportsModel>([]);
  RxList<ReportsModel> designerReportsList = RxList<ReportsModel>([]);
  RxList<ProductReportedModel> productReports =
      RxList<ProductReportedModel>([]);
  RxList<UserModel> reportedUsersList = RxList<UserModel>([]);
  RxList<ReportsModel> filteredCustomerReportsList = RxList<ReportsModel>([]);
  RxList<ReportsModel> filteredDesignerReportsList = RxList<ReportsModel>([]);
  RxList<ProductReportedModel> filteredProductReports =
      RxList<ProductReportedModel>([]); // For search
  RxString searchQuery = ''.obs; // For search query
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      selectedIndex.value = tabController.index;
    });

    fetchReports();
    fetchReportedProducts();
    fetchReportedUsers();
    filterReports();
    searchQuery.listen((query) {
      filterReports();
    });
  }

  void filterReports() {
    if (searchQuery.isEmpty) {
      // When there's no search query, show all the data
      filteredDesignerReportsList.value = designerReportsList;
      filteredCustomerReportsList.value = customerReportsList;
      filteredProductReports.value = productReports;
    } else {
      // Apply filtering only when the user types something in the search bar
      filteredDesignerReportsList.value = designerReportsList
          .where((report) =>
              report.reportedByUser?.fullName
                  ?.toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ??
              false)
          .toList();

      filteredCustomerReportsList.value = customerReportsList
          .where((report) =>
              report.reportedByUser?.fullName
                  ?.toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ??
              false)
          .toList();

      filteredProductReports.value = productReports.where((report) {
        final userFullName =
            report.reportedByUser?.fullName?.toLowerCase() ?? '';
        final productName = report.productName?.toLowerCase() ?? '';
        return userFullName.contains(searchQuery.value.toLowerCase()) ||
            productName.contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  Future<void> fetchReports() async {
    isLoading.value = true;

    try {
      var reportsSnapshot =
          await FirebaseFirestore.instance.collection('reports').get();
      for (var doc in reportsSnapshot.docs) {
        var report = ReportsModel.fromMap(doc.data(), doc.id);
        var userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(report.reportedBy)
            .get();

        var userData = userSnapshot.data();
        if (userData != null) {
          var role = userData['role'];
          var userModel = UserModel.fromMap(userData);
          report.reportedByUser = userModel;
          if (role == 'DESIGNER') {
            designerReportsList.add(report);
          } else if (role == 'CUSTOMER') {
            customerReportsList.add(report);
          }
        }
      }
    } catch (e) {
      print('Error fetching reports: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<AddProductModel?> fetchProduct(String productId) async {
    try {
      // Fetch the user document from Firestore
      final productSnapshot = await FirebaseFirestore.instance
          .collection('DesignerProducts')
          .doc(productId)
          .get();

      if (productSnapshot.exists) {
        // Convert the snapshot data to a UserModel instance
        return AddProductModel.fromMap(
            productSnapshot.data() as Map<String, dynamic>, productId);
      } else {
        print("User not found for userId: $productId");
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  Future<void> fetchReportedProducts() async {
    isLoading.value = true;

    try {
      var reportsSnapshot =
          await FirebaseFirestore.instance.collection('ProductReported').get();
      for (var doc in reportsSnapshot.docs) {
        var report = ProductReportedModel.fromMap(doc.data(), doc.id);
        var userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(report.reportedBy)
            .get();

        var userData = userSnapshot.data();
        if (userData != null) {
          var role = userData['role'];
          var userModel = UserModel.fromMap(userData);
          report.reportedByUser = userModel;
          productReports.add(report);
        }
      }
    } catch (e) {
      print('Error fetching reports: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchReportedUsers() async {
    isLoading.value = true;
    try {
      var reportedSnapshot =
          await FirebaseFirestore.instance.collection('ProductReported').get();

      reportedUsersList.clear();
      for (var doc in reportedSnapshot.docs) {
        var reportedById = doc['reportedBy'];
        var userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(reportedById)
            .get();

        if (userSnapshot.exists) {
          var userData = userSnapshot.data();
          if (userData != null) {
            var userModel = UserModel.fromMap(userData);
            reportedUsersList.add(userModel);
          }
        }
      }
    } catch (e) {
      print('Error fetching reported users: $e');
    } finally {
      isLoading.value = false; // Hide the loading spinner
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
    tabController.animateTo(index);
  }
}
