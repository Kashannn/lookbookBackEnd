import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Firebase/firebase_customerEnd_services.dart';
import '../Model/AddProductModel/add_product_model.dart';

class AdminProductController extends GetxController {
  final FirebaseCustomerEndServices firebaseCustomerEndServices =
      FirebaseCustomerEndServices();

  var eventMap = <String, List<AddProductModel>>{}.obs;
  TextEditingController searchController = TextEditingController();
  var filteredEventMap = <String, List<AddProductModel>>{}.obs;
  var allProducts = <AddProductModel>[];

  @override
  void onInit() {
    super.onInit();
    fetchUserProductsStream().listen((products) {
      allProducts = products;
      groupProductsByEvent(products);
    });
    searchController.addListener(() {
      filterProductsByEvent(searchController.text);
    });
  }

  Stream<List<AddProductModel>> fetchUserProductsStream() async* {
    try {
      CollectionReference designerProductsRef =
          FirebaseFirestore.instance.collection('DesignerProducts');
      await for (QuerySnapshot designerProductsSnapshot
          in designerProductsRef.snapshots()) {
        List<AddProductModel> designerProducts =
            designerProductsSnapshot.docs.map((doc) {
          return AddProductModel.fromMap(
              doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        yield designerProducts;
      }
    } catch (e) {
      print('Error fetching designer products: $e');
      yield [];
    }
  }

  void groupProductsByEvent(List<AddProductModel> products) {
    final Map<String, List<AddProductModel>> groupedProducts = {};

    for (var product in products) {
      final event = (product.event ?? 'No Event').trim().toLowerCase();
      if (!groupedProducts.containsKey(event)) {
        groupedProducts[event] = [];
      }
      groupedProducts[event]!.add(product);
    }

    eventMap.value = groupedProducts;
    filteredEventMap.value = groupedProducts;
  }

  // Filter products by event name
  void filterProductsByEvent(String searchText) {
    if (searchText.isEmpty) {
      filteredEventMap.value = eventMap;
    } else {
      final Map<String, List<AddProductModel>> filteredMap = {};
      eventMap.forEach((event, products) {
        if (event.contains(searchText.toLowerCase())) {
          filteredMap[event] = products;
        }
      });
      filteredEventMap.value = filteredMap; // Update filtered event map
    }
  }
}
