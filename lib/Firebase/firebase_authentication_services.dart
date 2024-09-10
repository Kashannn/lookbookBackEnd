import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/user/user_model.dart';
import '../utils/components/constant/snackbar.dart';
import '../views/Admin/admin_main_screen.dart';
import '../views/Customer/customer_main_screen.dart';
import '../views/Designer/designer_main_screen.dart';

class FirebaseAuthenticationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> signUpWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        UserModel newUser = UserModel(
          userId: user.uid,
          fullName: fullName,
          email: email,
          role: role,
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        return newUser;
      }
      return null;
    } catch (e) {
      _logError('signUpWithEmailAndPassword', e);
      return null;
    }
  }

  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists && doc.data() != null) {
          UserModel userModel =
              UserModel.fromMap(doc.data() as Map<String, dynamic>);
          String role = userModel.role ?? 'user'; // Providing a default value
          _navigateBasedOnRole(role);
          return userModel;
        } else {
          _logError(
              'signInWithEmailAndPassword', 'User document does not exist');
        }
      }
      return null;
    } catch (e) {
      _logError('signInWithEmailAndPassword', e);
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _logError('signOut', e);
    }
  }

  void _navigateBasedOnRole(String role) {
    switch (role) {
      case 'ADMIN':
        Get.offAll(() => AdminMainScreen());
        break;
      case 'CUSTOMER':
        Get.offAll(() => const CustomerMainScreen());
        break;
      case 'DESIGNER':
        Get.offAll(() => const DesignerMainScreen());
        break;
      default:
        _logError('_navigateBasedOnRole', 'Unknown role: $role');
        Get.offAllNamed('/HomeScreen');
    }
  }

  void _logError(String methodName, Object e) {
    print('Error in $methodName: $e');
  }

  Future<bool> forgetPassword(String email) async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
    );
    try {
      final user = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (user.docs.isEmpty) {
        Get.back();
        CustomSnackBars.instance.showFailureSnackbar(
          title: 'Error!',
          message: "No user found for that email.",
        );
        return false;
      }

      Get.back();
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      CustomSnackBars.instance.showFailureSnackbar(
        title: 'Success!',
        message: "Password reset email sent. Please check your email.",
      );
      return true;
    } on FirebaseAuthException {
      Get.back();
      CustomSnackBars.instance.showFailureSnackbar(
        title: 'Error!',
        message:
            "An error occurred while sending the password reset email. Please try again.",
      );
      return false;
    } catch (e) {
      Get.back();
      CustomSnackBars.instance.showFailureSnackbar(
        title: 'Error!',
        message: "An unexpected error occurred. Please try again.",
      );
      return false;
    }
  }
}
