import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lookbook/controllers/add_category_controller.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';
import 'package:lookbook/utils/components/reusedbutton.dart';
import 'package:lookbook/utils/components/textfield.dart';

import '../../controllers/add_product_controller.dart';

class AddCategoryBottomsheet extends StatelessWidget {
  AddCategoryBottomsheet({super.key});
  final AddCategoryController controller =
      Get.put(AddCategoryController()); // Getting the AddCategoryController
  final AddProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.0.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 150.0.w,
                child: const Divider(
                  thickness: 3,
                  color: AppColors.black,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                )
              ],
            ),
            Text(
              'Add Category',
              style: tSStyleBlack16400,
            ),
            10.ph,
            textfield(
              text: 'Type Category',
              toHide: false,
              controller: controller.categoryController,
              focusNode: controller.categoryFocusNode,
            ),
            20.ph,
            SizedBox(
              height: 58.h,
              child: reusedButton(
                text: 'ADD',
                ontap: () {
                  if (controller.categoryController.text.isNotEmpty) {
                    controller.addCategoryToFirebase(
                        controller.categoryController.text);
                    controller.categoryController.clear();
                    Get.back();
                  } else {
                    Get.snackbar('Error', 'Please enter a category');
                  }
                },
                color: AppColors.secondary,
                icon: Icons.add_circle_outline_outlined,
              ),
            ),
            20.ph,
          ],
        ),
      ),
    );
  }
}
