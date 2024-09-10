import 'package:get/get_utils/src/get_utils/get_utils.dart';

class ValidationService {
  // sign in  and sign up screens validations

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Email can't be empty";
    } else if (!GetUtils.isEmail(email)) {
      return "Enter a valid email";
    }
    return null;
  }

  static String? validateName(String name) {
    if (name.isEmpty) {
      return "Name can't be empty";
    } else if (name.length < 2) {
      return "Name must be at least 2 characters long";
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return "Name can only contain letters and spaces";
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Password can't be empty";
    } else if (password.length < 8) {
      return "Password must be at least 8 characters long";
    } else if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(password)) {
      return "Password must contain at least one uppercase letter";
      // } else if (!RegExp(r'^(?=.*?[a-z])').hasMatch(password)) {
      //   return "Password must contain at least one lowercase letter";
    } else if (!RegExp(r'^(?=.*?[0-9])').hasMatch(password)) {
      return "Password must contain at least one digit";
    } else if (!RegExp(r'^(?=.*?[!@#\$&*~.])').hasMatch(password)) {
      return "Password must contain at least one special character";
    }
    return null;
  }

  static String? validateConfirmPassword(
      String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return "Confirm password can't be empty";
    } else if (confirmPassword != password) {
      return "Passwords do not match";
    }
    return null;
  }

  // Add Product screen Field Validation
  static Map<String, String?> validateFields({
    required String category,
    required String price,
    required String description,
    required String phone,
    required String email,
  }) {
    final errors = <String, String?>{};

    if (category.isEmpty) {
      errors['category'] = "Category can't be empty";
    }
    if (price.isEmpty) {
      errors['price'] = "Price can't be empty";
    }
    if (description.isEmpty) {
      errors['description'] = "Product Description can't be empty";
    }
    if (phone.isEmpty) {
      errors['phone'] = "Phone Number can't be empty";
    }
    if (email.isEmpty) {
      errors['email'] = "Email can't be empty";
    }

    return errors;
  }
}
