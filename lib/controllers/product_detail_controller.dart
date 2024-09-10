import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';

class ProductDetailController extends GetxController {
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
}
