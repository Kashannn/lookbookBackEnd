import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../Firebase/firebase_customerEnd_services.dart';
import '../../Model/AddProductModel/add_product_model.dart';

import 'package:get/get.dart';
import '../../Firebase/firebase_customerEnd_services.dart';
import '../../Model/AddProductModel/add_product_model.dart';

class CustomerDashboardController extends GetxController {
  final FirebaseCustomerEndServices firebaseCustomerEndServices =
      FirebaseCustomerEndServices();
  var eventMap = <String, List<AddProductModel>>{}.obs;
  TextEditingController searchController = TextEditingController();
  var filteredProducts = <AddProductModel>[].obs;
  var allProducts = <AddProductModel>[];
  @override
  void onInit() {
    super.onInit();
    fetchUserProductsStream().listen((products) {
      allProducts = products;
      filteredProducts.value = allProducts;
    });
    searchController.addListener(() {
      filterProductsByTitle(searchController.text);
    });
  }

  Stream<List<AddProductModel>> fetchUserProductsStream() async* {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      await for (DocumentSnapshot userDocSnapshot in userDocRef.snapshots()) {
        List<DocumentReference> productRefs =
            (userDocSnapshot.data() as Map<String, dynamic>)['products'] != null
                ? (userDocSnapshot.data() as Map<String, dynamic>)['products']
                    .cast<DocumentReference>()
                : [];

        List<AddProductModel> products = await Future.wait(
          productRefs.map((productRef) async {
            DocumentSnapshot productDocSnapshot = await productRef.get();
            return AddProductModel.fromMap(
                productDocSnapshot.data() as Map<String, dynamic>,
                productDocSnapshot.id);
          }).toList(),
        );

        yield products;
      }
    } catch (e) {
      print('Error fetching user products: $e');
      yield [];
    }
  }

  void filterProductsByEvent(String? selectedEvent, DateTime? selectedDate) {
    if (selectedEvent != null && selectedEvent.isNotEmpty) {
      final lowerCaseEvent = selectedEvent.toLowerCase();
      fetchUserProductsStream().listen((products) {
        List<AddProductModel> eventFilteredProducts = products
            .where((product) =>
                (product.event ?? '').toLowerCase() == lowerCaseEvent)
            .toList();

        if (selectedDate != null) {
          eventFilteredProducts = eventFilteredProducts.where((product) {
            return product.event != null &&
                isSameDay(product.addedAt!, selectedDate);
          }).toList();
        }
        filteredProducts.value = eventFilteredProducts;
      });
    } else {
      filteredProducts.clear();
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void filterProductsByTitle(String searchText) {
    if (searchText.isEmpty) {
      filteredProducts.value = allProducts;
    } else {
      filteredProducts.value = allProducts.where((product) {
        return product.dressTitle != null &&
            product.dressTitle!
                .toLowerCase()
                .contains(searchText.toLowerCase());
      }).toList();
    }
  }
}
