import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookbook/utils/validations/validator.dart';
import '../Firebase/firebase_authentication_services.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmFocusNode = FocusNode();

  final isButtonActive = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  final RxString _emailErrorText = ''.obs;
  final RxString _passwordErrorText = ''.obs;
  final RxString _nameErrorText = ''.obs;
  final RxString _confirmErrorText = ''.obs;

  String? get emailErrorText =>
      _emailErrorText.value.isEmpty ? null : _emailErrorText.value;
  String? get passwordErrorText =>
      _passwordErrorText.value.isEmpty ? null : _passwordErrorText.value;
  String? get nameErrorText =>
      _nameErrorText.value.isEmpty ? null : _nameErrorText.value;
  String? get confirmErrorText =>
      _confirmErrorText.value.isEmpty ? null : _confirmErrorText.value;

  final FirebaseAuthenticationServices _authService = FirebaseAuthenticationServices();

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateEmail);
    passwordController.addListener(_validatePassword);
    nameController.addListener(_validateName);
    confirmController.addListener(_validateConfirmPassword);
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
      final user = await _authService.signUpWithEmailAndPassword(
        fullName: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        role: role,
      );

      if (user != null) {
        Get.toNamed('signin');
      } else {
        Get.snackbar('Error', 'Failed to sign up');
      }
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
}
