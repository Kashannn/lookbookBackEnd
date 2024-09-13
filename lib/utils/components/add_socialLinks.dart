import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lookbook/controllers/add_social_link_controller.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';
import 'package:lookbook/utils/components/reusedbutton.dart';
import 'package:lookbook/utils/components/textfield.dart';

class AddSociallinks extends StatelessWidget {
  final Function(String title, String link) onAdd;

  AddSociallinks({super.key, required this.onAdd});

  final AddSocialLinkController controller = Get.put(AddSocialLinkController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
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
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            Text(
              "Add Social Links",
              style: tSStyleBlack16400,
            ),
            15.ph,
            textfield(
              text: 'Title',
              toHide: false,
              controller: controller.titleController,
              focusNode: controller.titleFocusNode,
            ),
            15.ph,
            textfield(
              text: 'Link',
              toHide: false,
              controller: controller.linkController,
              focusNode: controller.linkFocusNode,
            ),
            25.ph,
            SizedBox(
              height: 58.h,
              child: reusedButton(
                text: 'ADD',
                ontap: () {
                  String title = controller.titleController.text;
                  String link = controller.linkController.text;

                  if (title.isNotEmpty && link.isNotEmpty) {
                    onAdd(title, link); // Send data back to the parent widget
                    Get.back(); // Close the modal
                  }
                },
                color: AppColors.secondary,
                icon: Icons.add_circle_outline_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


