import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class WelcomeController {
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();
  var currentIndex = 0.obs;

  void onDotTap(int index) {
    carouselSliderController.jumpToPage(index);
    currentIndex.value = index;
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}
