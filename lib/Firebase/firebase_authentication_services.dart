import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Model/user/user_model.dart';
import '../utils/components/constant/snackbar.dart';
import '../views/Admin/admin_main_screen.dart';
import '../views/Customer/customer_main_screen.dart';
import '../views/Designer/designer_main_screen.dart';
import '../views/authentication/sign_in_screen.dart';

class FirebaseAuthenticationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Get the signed-in user
      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (!userDoc.exists) {
          // If user doesn't exist in Firestore, create a new record
          await FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser.uid)
              .set({
            'userId': firebaseUser.uid,
            'email': firebaseUser.email,
            'name': firebaseUser.displayName,
            'photoURL': firebaseUser.photoURL,
            // Add other fields you want to store
          });
        }

        // Create and return your UserModel instance
        return UserModel(
          userId: firebaseUser.uid,
          email: firebaseUser.email,
          fullName: firebaseUser.displayName,
          imageUrl: firebaseUser.photoURL,
        );
      }
    } catch (e) {
      print('Error during Google sign-in: $e');
      return null;
    }
    return null;
  }

  Future<void> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      _logError('sendEmailVerification', e);
    }
  }

  Future<UserModel?> signUpWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
    required String phone,
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
          phone: phone,
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
          if (userModel.isBlocked == true) {
            CustomSnackBars.instance.showSuccessSnackbar(
              title: 'Blocked',
              message: "You are temporarily blocked.",
            );
            return null;
          }

          String role = userModel.role ?? 'user';
          _navigateBasedOnRole(role);
          return userModel;
        } else {
          CustomSnackBars.instance.showSuccessSnackbar(
            title: 'Error',
            message: "User document does not exist.",
          );
          _logError(
              'signInWithEmailAndPassword', 'User document does not exist');
          return null;
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CustomSnackBars.instance.showSuccessSnackbar(
          title: 'Error',
          message: "No user found for this email.",
        );
      } else if (e.code == 'wrong-password') {
        CustomSnackBars.instance.showSuccessSnackbar(
          title: 'Error',
          message: "Incorrect password.",
        );
      } else {
        CustomSnackBars.instance.showSuccessSnackbar(
          title: 'Error',
          message: "An error occurred. Please try again.",
        );
      }
      _logError('signInWithEmailAndPassword', e.message ?? 'Unknown error');
      return null;
    } catch (e) {
      _logError('signInWithEmailAndPassword', e);
      CustomSnackBars.instance.showSuccessSnackbar(
        title: 'Error',
        message: "An unexpected error occurred.",
      );
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'deviceToken': FieldValue.delete()});
      }

      await _auth.signOut();
      _navigateBasedOnRole('user');
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
      CustomSnackBars.instance.showSuccessSnackbar(
        title: 'Success!',
        message: "Password reset email has been sent to $email.",
      );
      await Future.delayed(const Duration(seconds: 2));
      Get.to(
        () => SignInScreen(),
        transition: Transition.rightToLeft,
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
