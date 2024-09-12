import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/controllers/add_product_controller.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';
import 'package:lookbook/utils/components/custom_app_bar.dart';
import 'package:lookbook/utils/components/reusedbutton.dart';
import 'package:lookbook/utils/components/textfield.dart';
import '../../controllers/add_category_controller.dart';
import '../../utils/components/add_category_bottomSheet.dart';
import '../../utils/components/add_socialLinks.dart';
import '../../utils/components/colorPicker.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/size_Selector.dart';

class AddproductScreen1 extends StatelessWidget {
  AddproductScreen1({super.key});

  final AddProductController controller = Get.put(AddProductController());
  final AddCategoryController categoryController =
      Get.put(AddCategoryController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(),
              30.ph,
              Center(
                child: Text(
                  'A D D  P R O D U C T',
                  style: tSStyleBlack18600,
                ),
              ),
              10.ph,
              Center(
                child: SvgPicture.asset(
                  AppImages.line,
                  color: AppColors.text1,
                ),
              ),
              30.ph,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        if (controller.selectedImages.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: controller.pickImage,
                                  child: Container(
                                    color: const Color(0xFFF6F9FB),
                                    child: DottedBorder(
                                      color: AppColors.secondary,
                                      dashPattern: const [6, 3],
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(10),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 90.0.w,
                                          vertical: 55.0.h,
                                        ),
                                        child: SvgPicture.asset(
                                          AppImages.img,
                                          color: AppColors.greylight,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                15.ph,
                                Text(
                                  'Add Product Images',
                                  style: tSStyleBlack18400.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                Text(
                                  '(Max 5 images)',
                                  style: oStyleBlack12400.copyWith(
                                    color: const Color(0xFF717171),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 250.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(
                                        controller.selectedImages.first),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              15.ph,
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10.w,
                                  mainAxisSpacing: 10.h,
                                  childAspectRatio: 1.0,
                                ),
                                itemCount: controller.selectedImages.length < 5
                                    ? controller.selectedImages.length + 1
                                    : controller.selectedImages.length,
                                itemBuilder: (context, index) {
                                  if (index ==
                                          controller.selectedImages.length &&
                                      controller.selectedImages.length < 5) {
                                    return GestureDetector(
                                      onTap: controller.pickImage,
                                      child: Container(
                                        color: const Color(0xFFF6F9FB),
                                        child: DottedBorder(
                                          color: AppColors.secondary,
                                          dashPattern: const [6, 3],
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(10),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              AppImages.plus,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Stack(
                                      children: [
                                        Image.file(
                                          controller.selectedImages[index],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () =>
                                                controller.removeImage(index),
                                            child: const Icon(
                                              Icons.remove_circle,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        }
                      }),
                      30.ph,
                      Text(
                        'Category',
                        style: tSStyleBlack16600.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.ph,
                      Obx(() {
                        if (categoryController.categories.isEmpty) {
                          return Text("Loading categories...");
                        }
                        return DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                color: AppColors.greylight,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                color: AppColors.greylight,
                              ),
                            ),
                          ),
                          hint: Text("Select a Category",
                              style: TextStyle(
                                color: AppColors.greylight,
                              )

                          ),
                          value: controller.selectedCategory.value.isNotEmpty
                              ? controller.selectedCategory.value
                              : null,
                          items: categoryController.categories
                              .map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            controller.selectedCategory.value = newValue ?? '';
                            print('Selected category: $newValue');
                          },
                        );
                      }),
                      10.ph,
                      Row(
                        children: [
                          Text(
                            'Add Category',
                            style: tSStyleBlack14400.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          10.pw,
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                clipBehavior: Clip.antiAlias,
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return DraggableScrollableSheet(
                                    expand: false,
                                    initialChildSize: 0.4,
                                    minChildSize: 0.3,
                                    maxChildSize: 0.8,
                                    builder: (_, controller) {
                                      return GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30.r),
                                                topRight: Radius.circular(30.r),
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15.w,
                                              vertical: 10.h,
                                            ),
                                            child: SingleChildScrollView(
                                              controller: controller,
                                              child: AddCategoryBottomsheet(),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: SvgPicture.asset(
                              AppImages.add,
                            ),
                          ),
                        ],
                      ),
                      15.ph,
                      Text(
                        'Dress Title',
                        style: tSStyleBlack16600.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.ph,
                      textfield(
                        text: 'Type',
                        toHide: false,
                        controller: controller.dressController,
                        focusNode: controller.dressFocusNode,
                        nextFocusNode: controller.priceFocusNode,
                      ),
                      15.ph,
                      Text(
                        'Price',
                        style: tSStyleBlack16600.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.ph,
                      textfield(
                        isNumeric: true,
                        text: 'Type',
                        toHide: false,
                        controller: controller.priceController,
                        focusNode: controller.priceFocusNode,
                        nextFocusNode: controller.descriptionFocusNode,
                        errorText: controller.priceErrorText,
                      ),
                      15.ph,
                      Text(
                        'Product Description',
                        style: tSStyleBlack16600.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.ph,
                      textfield(
                        text: 'Type',
                        toHide: false,
                        controller: controller.descriptionController,
                        focusNode: controller.descriptionFocusNode,
                        nextFocusNode: controller.colorFocusNode,
                        errorText: controller.descriptionErrorText,
                      ),
                      15.ph,
                      ColorPickerWidget(controller: controller),
                      15.ph,
                      SizeSelector(controller: controller),
                      15.ph,
                      Text(
                        'Minimum Order Quantity',
                        style: tSStyleBlack16600.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.ph,
                      textfield(
                        isNumeric: true,
                        text: 'Type',
                        toHide: false,
                        controller: controller.quantityController,
                        focusNode: controller.quantityFocusNode,
                        nextFocusNode: controller.socialFocusNode,
                      ),
                      15.ph,
                      Text(
                        'Social Links',
                        style: tSStyleBlack16600.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.ph,
                      textfield(
                        text: 'Instagram.com',
                        toHide: false,
                        controller: controller.socialController,
                        focusNode: controller.socialFocusNode,
                        nextFocusNode: controller.phoneFocusNode,
                      ),
                      10.ph,
                      Row(
                        children: [
                          Text(
                            'Add Social Links',
                            style: tSStyleBlack14400.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          10.pw,
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return DraggableScrollableSheet(
                                    expand: false,
                                    initialChildSize: 0.4,
                                    builder: (_, controller) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30.r),
                                            topRight: Radius.circular(30.r),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0.w, vertical: 0.h),
                                        child: AddSociallinks(),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: SvgPicture.asset(
                              AppImages.add,
                            ),
                          ),
                        ],
                      ),
                      10.ph,
                      Text(
                        'Phone',
                        style: tSStyleBlack16600.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.ph,
                      textfield(
                        isNumeric: true,
                        text: '0305 7878686 33',
                        toHide: false,
                        controller: controller.phoneController,
                        focusNode: controller.phoneFocusNode,
                        nextFocusNode: controller.emailFocusNode,
                        errorText: controller.priceErrorText,
                      ),
                      10.ph,
                      Text(
                        'Email',
                        style: tSStyleBlack16600.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.ph,
                      textfield(
                        text: 'Type',
                        toHide: false,
                        controller: controller.emailController,
                        focusNode: controller.emailFocusNode,
                        nextFocusNode: controller.emailFocusNode,
                        errorText: controller.priceErrorText,
                      ),
                      25.ph,
                      Obx(
                        () => SizedBox(
                          height: 58.h,
                          child: reusedButton(
                            icon: Icons.arrow_forward_outlined,
                            text: 'NEXT',
                            ontap: controller.isButtonActive.value
                                ? () async {
                                    await controller.saveProductData();
                                    Get.toNamed('addPhotographer');
                                  }
                                : null,
                            color: controller.isButtonActive.value
                                ? AppColors.secondary
                                : AppColors.greylight,
                          ),
                        ),
                      ),
                      20.ph,
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
