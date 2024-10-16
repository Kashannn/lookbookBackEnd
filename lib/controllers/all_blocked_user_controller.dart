import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../Model/user/user_model.dart';
import '../utils/components/constant/snackbar.dart';

class AllBlockedUserController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  var selectedIndex = 0.obs;
  var blockedDesigners = <UserModel>[].obs;
  var blockedCustomers = <UserModel>[].obs;
  final TextEditingController searchController = TextEditingController();
  RxList<UserModel> customerList = RxList<UserModel>([]);
  RxList<UserModel> designersList = RxList<UserModel>([]);
  RxList<UserModel> filteredUsersList = RxList<UserModel>([]);
  RxBool isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedIndex.value = tabController.index;
    });
    fetchBlockedDesignersStream().listen((designers) {
      blockedDesigners.assignAll(designers);
      filteredUsersList.assignAll(blockedDesigners);
    });

    fetchBlockedCustomersStream().listen((customers) {
      blockedCustomers.assignAll(customers);
      filteredUsersList.assignAll(blockedCustomers);
    });
    searchController.addListener(() {
      filterUsers(searchController.text);
    });
  }

  Stream<List<UserModel>> fetchBlockedDesignersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'DESIGNER')
        .where('isBlocked', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
  }

  Stream<List<UserModel>> fetchBlockedCustomersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'CUSTOMER')
        .where('isBlocked', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      if (selectedIndex.value == 0) {
        filteredUsersList.assignAll(blockedDesigners);
      } else {
        filteredUsersList.assignAll(blockedCustomers);
      }
    } else {
      var filteredDesigners = blockedDesigners.where((designer) {
        return designer.fullName?.toLowerCase().contains(query.toLowerCase()) ??
            false;
      }).toList();

      var filteredCustomers = blockedCustomers.where((customer) {
        return customer.fullName?.toLowerCase().contains(query.toLowerCase()) ??
            false;
      }).toList();

      if (filteredDesigners.isNotEmpty) {
        filteredUsersList.assignAll(filteredDesigners);
        tabController.animateTo(0);
      } else if (filteredCustomers.isNotEmpty) {
        filteredUsersList.assignAll(filteredCustomers);
        tabController.animateTo(1);
      } else {
        filteredUsersList.clear();
      }
    }
  }

  Future<void> unblockCustomer(UserModel customer) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(customer.userId)
          .update({'isBlocked': false});
      CustomSnackBars.instance.showSuccessSnackbar(
        title: "Unblocked",
        message: "${customer.fullName} has been unblocked successfully",
      );
    } catch (e) {
      print("Error unblocking customer: $e");
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error",
        message: "Failed to unblock ${customer.fullName}",
      );
    }
  }

  Future<void> unblockDesigner(UserModel designer) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(designer.userId)
          .update({'isBlocked': false});
      CustomSnackBars.instance.showSuccessSnackbar(
        title: "Unblocked",
        message: "${designer.fullName} has been unblocked successfully",
      );
    } catch (e) {
      print("Error unblocking customer: $e");
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error",
        message: "Failed to unblock ${designer.fullName}",
      );
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
    tabController.animateTo(index);
  }
}
