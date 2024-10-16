import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookbook/utils/validations/validator.dart';
import '../Firebase/firebase_authentication_services.dart';
import '../Model/user/user_model.dart';

class SignUpController extends GetxController {
  final isLoading = false.obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final phoneController = TextEditingController();
  final aboutController = TextEditingController();

  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final aboutFocusNode = FocusNode();

  final isButtonActive = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  final RxString _emailErrorText = ''.obs;
  final RxString _passwordErrorText = ''.obs;
  final RxString _nameErrorText = ''.obs;
  final RxString _confirmErrorText = ''.obs;
  final RxString _phoneErrorText = ''.obs;

  String? get emailErrorText =>
      _emailErrorText.value.isEmpty ? null : _emailErrorText.value;
  String? get passwordErrorText =>
      _passwordErrorText.value.isEmpty ? null : _passwordErrorText.value;
  String? get nameErrorText =>
      _nameErrorText.value.isEmpty ? null : _nameErrorText.value;
  String? get confirmErrorText =>
      _confirmErrorText.value.isEmpty ? null : _confirmErrorText.value;
  String? get phoneErrorText =>
      _phoneErrorText.value.isEmpty ? null : _phoneErrorText.value;

  final FirebaseAuthenticationServices _authService =
      FirebaseAuthenticationServices();

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateEmail);
    passwordController.addListener(_validatePassword);
    nameController.addListener(_validateName);
    confirmController.addListener(_validateConfirmPassword);
    phoneController.addListener(_validateForm);
  }

  //email verification link
  Future<void> sendEmailVerification() async {
    await _authService.sendEmailVerification();
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

  void _validateName() {
    _nameErrorText.value =
        ValidationService.validateName(nameController.text) ?? '';
    _validateForm();
  }

  void _validateConfirmPassword() {
    _confirmErrorText.value = ValidationService.validateConfirmPassword(
            passwordController.text, confirmController.text) ??
        '';
    _validateForm();
  }

  void _validateForm() {
    isButtonActive.value = _emailErrorText.value.isEmpty &&
        _passwordErrorText.value.isEmpty &&
        _nameErrorText.value.isEmpty &&
        _confirmErrorText.value.isEmpty;
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> signUp(String role) async {
    if (isButtonActive.value) {
      isLoading.value = true;

      try {
        final user = await _authService.signUpWithEmailAndPassword(
          fullName: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          phone: phoneController.text.trim(),
          role: role,
        );

        if (user != null) {
          String? deviceToken = await FirebaseMessaging.instance.getToken();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.userId)
              .set({
            'userId': user.userId,
            'fullName': nameController.text.trim(),
            'email': emailController.text.trim(),
            'phone': phoneController.text.trim(),
            'role': role,
            'deviceToken': deviceToken,
            'about': aboutController.text.trim(),
            'isBlocked': false,
          });
          sendEmailVerification();
          Get.toNamed('signin');
        } else {
          Get.snackbar('Error', 'Failed to sign up');
        }
      } catch (error) {
        Get.snackbar('Error', 'Something went wrong: $error');
      } finally {
        clearForm();
        isLoading.value = false;
      }
    }
  }

  Future<String?> getDeviceTokenByUserId(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['deviceToken'] as String?;
      } else {
        print("User with userId: $userId not found.");
        return null;
      }
    } catch (error) {
      print("Failed to get device token: $error");
      return null;
    }
  }

  //get user by UserId
  Future<UserModel?> getUserByUserId(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      } else {
        print("User with userId: $userId not found.");
        return null;
      }
    } catch (error) {
      print("Failed to get user: $error");
      return null;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmFocusNode.dispose();
    super.onClose();
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmController.clear();
    phoneController.clear();
    aboutController.clear();
    super.onClose();
  }
}
