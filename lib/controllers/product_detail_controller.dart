import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lookbook/controllers/sign_up_screen_controller.dart';
import 'package:lookbook/views/Admin/admin_main_screen.dart';

import '../Notification/notification.dart';
import '../utils/components/constant/snackbar.dart';

class ProductDetailController extends GetxController {
  var isLoading = false.obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();

  var currentIndex = 0.obs;

  void onDotTap(int index) {
    carouselSliderController.animateToPage(index);
    currentIndex.value = index;
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  Future<void> deleteProduct(String productId, String designerId) async {
    isLoading.value = true;
    print(designerId);

    try {
      final SignUpController signUpController = Get.put(SignUpController());
      String? deviceToken =
          await signUpController.getDeviceTokenByUserId(designerId);
      if (deviceToken != null) {
        NotificationService notificationService = NotificationService();
        await notificationService.chatSendPushNotification(
          'Product Deleted',
          deviceToken,
          'Admin deleted your product',
          designerId,
          "delete",
          productId,
          productId,
        );
      }

      CollectionReference photographerRef = FirebaseFirestore.instance
          .collection('DesignerProducts')
          .doc(productId)
          .collection('photographers');
      QuerySnapshot photographersSnapshot = await photographerRef.get();

      for (QueryDocumentSnapshot doc in photographersSnapshot.docs) {
        await doc.reference.delete();
      }

      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('products',
              arrayContains: FirebaseFirestore.instance
                  .collection('DesignerProducts')
                  .doc(productId))
          .get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        List<DocumentReference> products =
            List<DocumentReference>.from(userDoc['products']);
        products.removeWhere((ref) => ref.id == productId);

        await userDoc.reference.update({'products': products});
      }
      await FirebaseFirestore.instance
          .collection('DesignerProducts')
          .doc(productId)
          .delete();

      CustomSnackBars.instance.showSuccessSnackbar(
          title: 'Success',
          message: 'Product and its photographers deleted successfully!');
      Get.offAll(() => AdminMainScreen());
    } catch (e) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Error',
          message: 'Failed to delete product and photographers');
    } finally {
      isLoading.value = false;
    }
  }
}
