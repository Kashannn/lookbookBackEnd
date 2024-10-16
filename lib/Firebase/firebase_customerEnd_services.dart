import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/views/Customer/customer_dashboard_screen.dart';
import 'package:lookbook/views/Customer/customer_main_screen.dart';
import 'package:lookbook/views/Customer/customer_message_chat_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Model/AddProductModel/add_product_model.dart';
import '../Model/Chat/chat_room_model.dart';
import '../Model/user/user_model.dart';
import '../views/Customer/customer_product_detail_screen.dart';

class FirebaseCustomerEndServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> fetchUser(String userId) async {
    try {
      // Fetch the user document from Firestore
      final userSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        // Convert the snapshot data to a UserModel instance
        return UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
      } else {
        print("User not found for userId: $userId");
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  Stream<QuerySnapshot> fetchDesignerProducts() {
    return FirebaseFirestore.instance
        .collection('DesignerProducts')
        .snapshots();
  }

  Future<AddProductModel?> fetchSingleProduct(String scannedCode) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('DesignerProducts')
        .where('barCode',
            isEqualTo:
                scannedCode) // Assuming barcode is stored in 'barCode' field
        .limit(1) // Fetch only one product
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document
      final doc = querySnapshot.docs.first;
      return AddProductModel.fromMap(
          doc.data() as Map<String, dynamic>, doc.id);
    } else {
      // Return null if no product is found
      return null;
    }
  }

  String barcode = '';
  Future<void> _scanBarcode() async {
    try {
      // Scan the barcode
      ScanResult scanResult = await BarcodeScanner.scan();
      String scannedCode = scanResult.rawContent;
      print('Scanned Code: $scannedCode'); // Log the scanned code for debugging

      if (scannedCode.isNotEmpty) {
        // Fetch the product from Firestore
        AddProductModel? product = await fetchSingleProduct(scannedCode);

        if (product != null) {
          // Navigate to ProductDetailPage with product details
          print('Product found: ${product.dressTitle}'); // Log product details
          try {
            Get.to(
              CustomerProductDetailScreen(),
              arguments: product,
            );
            print('Navigation to product detail screen successful');
          } catch (e) {
            print('Error navigating to product detail screen: $e');
          }
        } else {
          // Product is not found, show a snackbar message
          print('Product not found in database'); // Log for debugging
          Get.snackbar('Error', 'Product not found in database!');
        }
      } else {
        // If scanned code is empty, log it
        print('Scanned code is empty');
        Get.snackbar('Error', 'No barcode detected.');
      }
    } catch (e) {
      // Catch and handle any error that occurs
      print('Error scanning barcode: $e'); // Log the error
      Get.snackbar('Error', 'Failed to scan barcode: $e');
    }
  }

  Future<void> requestCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      print('Camera permission granted');
      _scanBarcode();
    } else {
      print('Camera permission denied');
    }
  }

  Future<void> addProductToHome(AddProductModel product) async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Reference to the product document (DesignerProducts collection)
      DocumentReference productDocRef = FirebaseFirestore.instance
          .collection('DesignerProducts')
          .doc(product.id);

      // Update the product's document to add or update the 'addedAt' field with the current timestamp
      await productDocRef.set(
          {
            'addedAt': FieldValue
                .serverTimestamp(), // Use Firestore's server timestamp
          },
          SetOptions(
              merge:
                  true)); // Merge: true ensures only 'addedAt' is updated/added

      // Add the product reference to the 'products' field in the user's document
      await userDocRef.update({
        'products': FieldValue.arrayUnion(
            [productDocRef]) // Add product reference to the list
      });

      // Success message
      Get.snackbar('Success', 'Product added to home successfully!');
      Get.offAll(CustomerMainScreen());
    } catch (e) {
      // Handle errors here
      print('Error adding product to home: $e');
      Get.snackbar('Error', 'Failed to add product to home.');
    }
  }

  Future<void> removeProductFromHome(AddProductModel product) async {
    try {
      // Get the current user's ID
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the current user's document in Firestore
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Reference to the product document (DesignerProducts collection)
      DocumentReference productDocRef = FirebaseFirestore.instance
          .collection('DesignerProducts')
          .doc(product.id);

      // Add the product reference to the 'products' field in the user's document
      await userDocRef.update({
        'products': FieldValue.arrayRemove(
            [productDocRef]) // Add product reference to the list
      });

      // Success message
      Get.snackbar('Success', 'Product removed from home successfully!');
      Get.offAll(CustomerMainScreen());
    } catch (e) {
      // Handle errors here
      print('Error removing product: $e');
      Get.snackbar('Error', 'Failed to remove product.');
    }
  }

  Future<bool> isProductInHome(String productId) async {
    try {
      // Get the current user's ID
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the user's document in Firestore
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Fetch the user's document snapshot
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        // Get the 'products' field from the user's document (it's a list of DocumentReferences)
        List products =
            (userDocSnapshot.data() as Map<String, dynamic>)['products'] ?? [];

        // Create a DocumentReference for the product
        DocumentReference productDocRef = FirebaseFirestore.instance
            .collection('DesignerProducts')
            .doc(productId);

        // Check if the product reference is in the list
        return products.contains(productDocRef);
      } else {
        return false; // User document doesn't exist, so product can't be in home
      }
    } catch (e) {
      print('Error checking product in home: $e');
      return false; // Return false if there's an error
    }
  }

  void checkProductInHome(String productId) async {
    bool isInHome = await isProductInHome(productId);
    if (isInHome) {
      print('Product is already in home.');
    } else {
      print('Product is not in home.');
    }
  }

  Stream<List<String>> fetchEvents() {
    return _firestore
        .collection('DesignerProducts')
        .snapshots()
        .map((snapshot) {
      // Extract unique events from all documents in the collection
      Set<String> eventSet = {};

      for (var doc in snapshot.docs) {
        AddProductModel product =
            AddProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);

        // Add the event to the set if it exists
        if (product.event != null && product.event!.isNotEmpty) {
          eventSet.add(product.event!);
        }
      }

      // Return the list of unique events
      return eventSet.toList();
    });
  }
}
