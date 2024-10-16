import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../Model/user/user_model.dart';

class AllDesignerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<UserModel> designersList = RxList<UserModel>([]);
  RxList<UserModel> filteredDesignersList = RxList<UserModel>([]);
  RxBool isLoading = true.obs;
  final TextEditingController searchController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    fetchDesigners();
    searchController.addListener(() {
      filterDesigners(searchController.text);
    });
  }
  void fetchDesigners() {
    try {
      _firestore
          .collection('users')
          .where('role', isEqualTo: 'DESIGNER')
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          designersList.clear();
          for (var doc in snapshot.docs) {
            UserModel designer =
            UserModel.fromMap(doc.data() as Map<String, dynamic>);
            designersList.add(designer);
          }
          filteredDesignersList.assignAll(designersList);
        } else {
          designersList.clear();
          filteredDesignersList.clear();
        }
        isLoading.value = false;
      });
    } catch (e) {
      print("Error fetching designers: $e");
      isLoading.value = false;
    }
  }
  void filterDesigners(String query) {
    if (query.isEmpty) {
      filteredDesignersList.assignAll(designersList);
    } else {
      filteredDesignersList.assignAll(designersList.where((designer) {
        return designer.fullName?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList());
    }
  }



}
