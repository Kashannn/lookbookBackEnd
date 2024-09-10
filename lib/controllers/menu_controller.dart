import 'package:get/get.dart';

class CustomMenuController extends GetxController {
  // Track the index of the currently selected menu item
  RxInt selectedIndex = (-1).obs;

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}
