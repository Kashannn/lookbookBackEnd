import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Model/user/user_model.dart';

class AllCustomerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<UserModel> customerList = RxList<UserModel>([]);
  RxList<UserModel> filteredCustomerList = RxList<UserModel>([]);
  RxBool isLoading = true.obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
    searchController.addListener(() {
      filterCustomers(searchController.text);
    });
  }

  void fetchCustomers() {
    try {
      _firestore
          .collection('users')
          .where('role', isEqualTo: 'CUSTOMER')
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          customerList.clear();
          for (var doc in snapshot.docs) {
            UserModel customer =
            UserModel.fromMap(doc.data() as Map<String, dynamic>);
            customerList.add(customer); // Add customers to the list
          }
          filteredCustomerList.assignAll(customerList); // Show all customers by default
        } else {
          customerList.clear();
          filteredCustomerList.clear();
        }
        isLoading.value = false;
      });
    } catch (e) {
      print("Error fetching customers: $e");
      isLoading.value = false;
    }
  }
  void filterCustomers(String query) {
    if (query.isEmpty) {
      filteredCustomerList.assignAll(customerList);
    } else {
      filteredCustomerList.assignAll(customerList.where((customer) {
        return customer.fullName?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList());
    }
  }
}


