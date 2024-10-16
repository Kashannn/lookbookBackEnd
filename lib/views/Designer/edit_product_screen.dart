import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/Model/AddProductModel/add_product_model.dart';
import 'package:lookbook/controllers/add_product_controller.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_images.dart';
import 'package:lookbook/utils/components/reusedbutton.dart';
import 'package:lookbook/utils/components/textfield.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../Firebase/firebase_addproduct_services.dart';
import '../../controllers/add_category_controller.dart';
import '../../utils/components/add_category_bottomSheet.dart';
import '../../utils/components/add_socialLinks.dart';
import '../../utils/components/colorPicker.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/custom_app_bar.dart';
import '../../utils/components/edit_size_selector.dart';
import '../designer/home_screnn.dart';
import 'addproduct_screen1.dart';

class EditProductScreen extends StatelessWidget {
  final AddProductModel productModel;
  final String productId;
  final AddProductController controller = Get.put(AddProductController());
  final AddCategoryController categoryController =
      Get.put(AddCategoryController());
  final FirebaseAddProductServices services = FirebaseAddProductServices();
  EditProductScreen(
      {super.key, required this.productId, required this.productModel});

  @override
  Widget build(BuildContext context) {
    controller.fetchProductData(productId);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomAppBar(),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.ph,
              Center(
                child: Text(
                  'E D I T  P R O D U C T',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        if (controller.selectedImages.isEmpty &&
                            controller.editSelectedImages.isEmpty) {
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
                          final List<String> imageList = controller
                              .editSelectedImages
                              .map((imageModel) => imageModel.url!)
                              .toList();

                          return Column(
                            children: [
                              // Display images fetched from Firebase
                              if (imageList.isNotEmpty) ...[
                                Container(
                                  width: double.infinity,
                                  height: 250.h,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(imageList.first),
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
                                  itemCount: imageList.length,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        Image.network(
                                          imageList[index],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => controller
                                                .removeFirebaseImage(index),
                                            child: const Icon(
                                              Icons.remove_circle,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                              if (controller.selectedImages.isNotEmpty) ...[
                                Container(
                                  width: double.infinity,
                                  height: 250.h,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(controller.selectedImages
                                          .first), // First selected image
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
                                  itemCount:
                                      controller.selectedImages.length < 5
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
                                                  AppImages.plus),
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
                            ],
                          );
                        }
                      }),
                      30.ph,
                      // _buildTextField(
                      //   'Designer Name',
                      //   controller.designerNameController,
                      //   controller.designerNameFocusNode,
                      // ),
                      // 15.ph,
                      15.ph,
                      Text(
                        'Category',
                        style: tSStyleBlack16600.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.ph,
                      Obx(() {
                        if (categoryController.categories.isEmpty) {
                          return Text("No categories available");
                        }

                        // Get the selected category or default to the value from Firebase
                        String? selectedCategoryValue =
                            controller.selectedCategory.value.isNotEmpty
                                ? controller.selectedCategory.value
                                : productModel.category?.isNotEmpty == true
                                    ? productModel.category![0]
                                    : null; // Set Firebase value as default

                        // Ensure the Firebase value is part of the list (add it if not present)
                        List<String> dropdownItems =
                            List.from(categoryController.categories);

                        if (productModel.category?.isNotEmpty == true &&
                            !dropdownItems
                                .contains(productModel.category![0])) {
                          dropdownItems.insert(
                              0,
                              productModel.category![
                                  0]); // Insert the Firebase value at the top
                        }

                        // Debugging prints
                        print("Selected Category: $selectedCategoryValue");
                        print("Dropdown Items: $dropdownItems");

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
                          hint: Text(
                            "Select a Category",
                            style: TextStyle(
                              color: AppColors.greylight,
                            ),
                          ),

                          // Set the default or selected value
                          value: selectedCategoryValue,

                          selectedItemBuilder: (BuildContext context) {
                            return dropdownItems.map<Widget>((String category) {
                              return Text(category);
                            }).toList();
                          },

                          items: dropdownItems.map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(category),
                                ],
                              ),
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
                                        child: Wrap(children: [
                                          AddCategoryBottomsheet()
                                        ]),
                                      ),
                                    ),
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
                      _buildTextField(
                        'Dress Title',
                        controller.dressController,
                        controller.dressFocusNode,
                      ),
                      15.ph,
                      _buildTextField(
                        'Price',
                        controller.priceController,
                        controller.priceFocusNode,
                        isNumeric: true,
                      ),
                      15.ph,
                      _buildTextField(
                        'Product Description',
                        controller.descriptionController,
                        controller.descriptionFocusNode,
                      ),
                      15.ph,
                      ColorPickerWidget(controller: controller),
                      15.ph,
                      EditSizeSelector(
                        controller: controller,
                        sizes: productModel.sizes,
                      ),
                      15.ph,
                      _buildTextField(
                        'Minimum Order Quantity',
                        controller.quantityController,
                        controller.quantityFocusNode,
                        isNumeric: true,
                      ),
                      15.ph,
                      _buildTextField(
                        'Bar Code',
                        controller.barCodeController,
                        controller.barCodeFocusNode,
                        isNumeric: false,
                      ),
                      15.ph,
                      Obx(
                        () => Column(
                          children: List.generate(
                            controller.socialLinks.length,
                            (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.socialLinks[index]['title'] ?? '',
                                  style: tSStyleBlack16600.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                5.ph,
                                textfield(
                                  text: controller.socialLinks[index]['link'] ??
                                      '',
                                  toHide: false,
                                  controller: TextEditingController(
                                    text: controller.socialLinks[index]
                                            ['link'] ??
                                        '',
                                  ),
                                ),
                                10.ph,
                              ],
                            ),
                          ),
                        ),
                      ),
                      15.ph,
                      Text(
                        'Social Links',
                        style: tSStyleBlack16600.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.ph,
                      Obx(
                        () => Column(
                          children: List.generate(
                            controller.socialLinks.length,
                            (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.socialLinks[index]['title'] ?? '',
                                  style: tSStyleBlack16600.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                5.ph,
                                textfield(
                                  text: controller.socialLinks[index]['link'] ??
                                      '',
                                  toHide: false,
                                  controller: TextEditingController(
                                    text: controller.socialLinks[index]
                                            ['link'] ??
                                        '',
                                  ),
                                ),
                                10.ph,
                              ],
                            ),
                          ),
                        ),
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
                                clipBehavior: Clip.antiAlias,
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
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
                                        child: Wrap(children: [
                                          AddSociallinks(
                                            onAdd: (title, link) {
                                              controller.addSocialLink(
                                                  title, link);
                                            },
                                          ),
                                        ]),
                                      ),
                                    ),
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
                      _buildTextField(
                        'Event',
                        controller.eventController,
                        controller.eventFocusNode,
                        isNumeric: false,
                      ),
                      15.ph,
                      _buildDateField(
                        'Event Date',
                        controller,
                        context,
                      ),
                      25.ph,
                      Obx(
                        () => controller.isLoading.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(
                                      0xFFE47F46)),
                                ),
                              )
                            : SizedBox(
                                height: 58.h,
                                child: reusedButton2(
                                  text: controller.isLoading.value
                                      ? 'Updating...'
                                      : 'UPDATE',
                                  ontap: controller.isLoading.value
                                      ? null
                                      : () async {
                                          await controller
                                              .updateProductData(productId);
                                        },
                                  color: AppColors.secondary,
                                ),
                              ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        height: 58.h,
                        child: reusedButton2(
                          text: 'DELETE PRODUCT',
                          ontap: () async {
                            await services.deleteProduct(productId);
                          },
                          color: AppColors.red,
                        ),
                      ),
                      15.ph,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    FocusNode focusNode, {
    bool isNumeric = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tSStyleBlack16600.copyWith(color: AppColors.primaryColor),
        ),
        10.ph,
        textfield(
          isNumeric: isNumeric,
          text: label,
          toHide: false,
          controller: controller,
          focusNode: focusNode,
        ),
      ],
    );
  }

  Widget _buildDateField(
      String label, AddProductController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tSStyleBlack16600.copyWith(color: AppColors.primaryColor),
        ),
        10.ph,
        GestureDetector(
          onTap: () {
            showCalendar(context, controller.selectedDate,
                controller.eventDateController);
          },
          child: AbsorbPointer(
            child: textfield(
              optionalIcon: Icons.calendar_month,
              text: label,
              toHide: false,
              controller: controller.eventDateController,
              focusNode: FocusNode(),
            ),
          ),
        ),
      ],
    );
  }
}
