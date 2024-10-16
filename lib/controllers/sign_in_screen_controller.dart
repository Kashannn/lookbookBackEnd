import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../Model/user/user_model.dart';
import '../Firebase/firebase_authentication_services.dart';
import '../main.dart';
import '../utils/components/constant/snackbar.dart';
import '../utils/validations/validator.dart';

class SignInController extends GetxController {
  final FirebaseAuthenticationServices _authService =
      Get.put(FirebaseAuthenticationServices());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isButtonActive = false.obs;
  final isLoading = false.obs;
  final RxString _emailErrorText = ''.obs;
  final RxString _passwordErrorText = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String? get emailErrorText =>
      _emailErrorText.value.isEmpty ? null : _emailErrorText.value;
  String? get passwordErrorText =>
      _passwordErrorText.value.isEmpty ? null : _passwordErrorText.value;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateEmail);
    passwordController.addListener(_validatePassword);
  }

  void _validateEmail() {
    _emailErrorText.value =
        ValidationService.validateEmail(emailController.text) ?? '';
    _validateForm();
  }

  void _validatePassword() {
    _passwordErrorText.value =
        ValidationService.validatePassword(passwordController.text) ?? '';
    _validateForm();
  }

  void _validateForm() {
    isButtonActive.value =
        _emailErrorText.value.isEmpty && _passwordErrorText.value.isEmpty;
  }

  Future<UserModel?> signIn() async {
    try {
      isLoading.value = true;
      UserModel? user = await _authService.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (user != null) {
        String? deviceToken = await FirebaseMessaging.instance.getToken();
        if (deviceToken != null && deviceToken.isNotEmpty) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.userId)
              .get();

          if (userDoc.exists) {
            Map<String, dynamic> userData =
                userDoc.data() as Map<String, dynamic>;
            String? existingToken = userData['deviceToken'];

            if (existingToken == null || existingToken != deviceToken) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.userId)
                  .update({'deviceToken': deviceToken});
            }
          } else {
            Get.snackbar('Error', 'User data not found.');
          }
        }
        return user;
      } else {
        Get.snackbar('Error', 'Sign-in failed. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<UserModel?> signInWithGoogle(String role) async {
    try {
      isLoading.value = true; // Start loading indicator
      String? deviceToken = await FirebaseMessaging.instance.getToken();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
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
          await FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser.uid)
              .set({
            'userId': firebaseUser.uid,
            'email': firebaseUser.email,
            'fullName': firebaseUser.displayName,
            'profileImageUrl': firebaseUser.photoURL,
            'deviceToken': deviceToken,
            'role': role,
          });
        } else {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          if (userData.containsKey('role') && userData['role'] != null) {
            if (userData['role'] != role) {
              // Show a message indicating that the role is already selected
              CustomSnackBars.instance.showFailureSnackbar(
                title: 'Role Already Selected',
                message:
                    "You cannot change your role. Your role is already set to ${userData['role']}.",
              );
              isLoading.value = false;
              return null;
            }
          } else {
            // If the role is not set, update the role
            await FirebaseFirestore.instance
                .collection('users')
                .doc(firebaseUser.uid)
                .update({'role': role});
          }
        }

        // Stop loading and navigate to AuthWrapper
        isLoading.value = false;
        Get.offAll(() => AuthWrapper());

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
      isLoading.value = false;
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserModel?> loginWithGoogle() async {
    try {
      isLoading.value = true;
      String? deviceToken = await FirebaseMessaging.instance.getToken();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
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

      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          if (userData.containsKey('role') && userData['role'] != null) {
            // Role exists, log the user in
            isLoading.value = false;
            Get.offAll(() => AuthWrapper());

            return UserModel(
              userId: firebaseUser.uid,
              email: firebaseUser.email,
              fullName: firebaseUser.displayName,
              imageUrl: firebaseUser.photoURL,
            );
          } else {
            CustomSnackBars.instance.showFailureSnackbar(
              title: 'Sign Up Required',
              message: "Please complete the signup process before logging in.",
            );
            await _auth.signOut();
            return null;
          }
        } else {
          CustomSnackBars.instance.showFailureSnackbar(
            title: 'Sign Up Required',
            message: "Please sign up first to continue.",
          );
          await _auth.signOut();
          return null;
        }
      }
    } catch (e) {
      print('Error during Google login: $e');
      CustomSnackBars.instance.showFailureSnackbar(
        title: 'Login Error',
        message: 'An error occurred: $e',
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
