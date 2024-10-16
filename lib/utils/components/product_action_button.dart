import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/utils/components/reusedbutton.dart';

import '../../Firebase/firebase_customerEnd_services.dart';
import '../../Model/AddProductModel/add_product_model.dart';
import 'constant/app_colors.dart';

class ProductActionButton extends StatefulWidget {
  final AddProductModel product; // Product to add/remove
  ProductActionButton({required this.product});

  @override
  _ProductActionButtonState createState() => _ProductActionButtonState();
}

class _ProductActionButtonState extends State<ProductActionButton> {
  bool isProductInHome = false; // To track if the product is already in home
  bool isLoading = false; // To manage loading state
  final FirebaseCustomerEndServices firebaseCustomerEndServices =
      FirebaseCustomerEndServices();

  @override
  void initState() {
    super.initState();
    checkIfProductInHome(); // Check if product is already in home on init
  }

  Future<bool> isProductHome(String productId) async {
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

  // Function to check if the product is already in the user's home list
  Future<void> checkIfProductInHome() async {
    setState(() {
      isLoading = true;
    });

    bool result =
        await isProductHome(widget.product.id!); // Check if product is in home
    setState(() {
      isProductInHome = result;
      isLoading = false;
    });
  }

  // Function to add or remove product from home
  Future<void> toggleProductInHome() async {
    setState(() {
      isLoading = true;
    });

    if (isProductInHome) {
      // If product is already in home, remove it
      await firebaseCustomerEndServices.removeProductFromHome(widget.product);
    } else {
      // If product is not in home, add it
      await firebaseCustomerEndServices.addProductToHome(widget.product);
    }

    setState(() {
      isProductInHome = !isProductInHome;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: AppColors.secondary,
            ))
          : reusedButton(
              text: isProductInHome ? 'REMOVE FROM HOME' : 'ADD TO HOME',
              ontap: () {
                toggleProductInHome(); // Toggle add/remove on tap
              },
              color: AppColors.secondary,
              icon: isProductInHome ? Icons.remove : Icons.east,
            ),
    );
  }
}
