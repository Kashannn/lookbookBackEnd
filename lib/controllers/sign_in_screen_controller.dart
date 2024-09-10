import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../Model/user/user_model.dart';
import '../Firebase/firebase_authentication_services.dart';
import '../utils/validations/validator.dart';

class SignInController extends GetxController {
  final FirebaseAuthenticationServices _authService = Get.put(FirebaseAuthenticationServices());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isButtonActive = false.obs;
  final isLoading = false.obs;
  final RxString _emailErrorText = ''.obs;
  final RxString _passwordErrorText = ''.obs;

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
      isLoading.value = true; // Start loading
      UserModel? user = await _authService.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      return user;
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
