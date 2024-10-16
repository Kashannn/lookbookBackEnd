import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/controllers/add_product_controller.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/add_size_selector.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';
import 'package:lookbook/utils/components/custom_app_bar.dart';
import 'package:lookbook/utils/components/reusedbutton.dart';
import 'package:lookbook/utils/components/textfield.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../controllers/add_category_controller.dart';
import '../../utils/components/add_category_bottomSheet.dart';
import '../../utils/components/add_socialLinks.dart';
import '../../utils/components/colorPicker.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/edit_size_selector.dart';
import '../designer/add_photographer_screen.dart';

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
        appBar: AppBar(
            title: CustomAppBar(),
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.ph,
              Center(
                child: Text(
                  'A D D  P R O D U C T',
                  style: tSStyleBlack18400,
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
                      // Text(
                      //   'Designer Name',
                      //   style: tSStyleBlack16600.copyWith(
                      //     color: AppColors.primaryColor,
                      //   ),
                      // ),
                      // 10.ph,
                      // textfield(
                      //   text: 'Type',
                      //   toHide: false,
                      //   controller: controller.designerNameController,
                      //   focusNode: controller.designerNameFocusNode,
                      //   nextFocusNode: controller.categoryFocusNode,
                      // ),
                      // 15.ph,
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
                          value: categoryController.categories
                                  .contains(controller.selectedCategory.value)
                              ? controller.selectedCategory.value
                              : null,
                          selectedItemBuilder: (BuildContext context) {
                            return categoryController.categories
                                .map<Widget>((String category) {
                              return Text(category);
                            }).toList();
                          },
                          items: categoryController.categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(category), // Display category name
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20.sp,
                                    ),
                                    onPressed: () {
                                      showDeleteConfirmation(context, category);
                                    },
                                  ),
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
                      15.ph,
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
                        minLines: 1,
                        maxLines: null,
                        controller: controller.descriptionController,
                        focusNode: controller.descriptionFocusNode,
                        nextFocusNode: controller.colorFocusNode,
                        errorText: controller.descriptionErrorText,
                      ),
                      15.ph,
                      ColorPickerWidget(controller: controller),
                      15.ph,
                      AddSizeSelector(controller: controller),
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
                      Text(
                        'Bar Code',
                        style: tSStyleBlack16600.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.ph,
                      textfield(
                        isNumeric: false,
                        text: 'BHK1234GT',
                        toHide: false,
                        controller: controller.barCodeController,
                        focusNode: controller.barCodeFocusNode,
                        nextFocusNode: controller.emailFocusNode,
                        errorText: controller.priceErrorText,
                      ),
                      10.ph,
                      Text(
                        'Event',
                        style: tSStyleBlack16600.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.ph,
                      textfield(
                        text: 'Type',
                        toHide: false,
                        controller: controller.eventController,
                        focusNode: controller.eventFocusNode,
                        nextFocusNode: controller.eventFocusNode,
                        errorText: controller.priceErrorText,
                      ),
                      10.ph,
                      Text(
                        'Event Date',
                        style: tSStyleBlack16600.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      10.ph,
                      GestureDetector(
                        onTap: () => showCalendar(
                            context,
                            controller.selectedDate,
                            controller.eventDateController),
                        child: AbsorbPointer(
                          child: textfield(
                            text: 'Select Date',
                            toHide: false,
                            optionalIcon: Icons.calendar_month,
                            controller: controller.eventDateController,
                            focusNode: controller.eventDateFocusNode,
                            nextFocusNode: controller.eventDateFocusNode,
                          ),
                        ),
                      ),

                      25.ph,
                      Obx(
                        () => controller.isLoading.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(
                                      0xFFE47F46)), // Custom color for the loader
                                ),
                              )
                            : SizedBox(
                                height: 58.h,
                                child: reusedButton(
                                  icon: Icons.arrow_forward_outlined,
                                  text: controller.isLoading.value
                                      ? 'Loading...'
                                      : 'NEXT',
                                  ontap: controller.isButtonActive.value
                                      ? () async {
                                          String? productID = await controller
                                              .saveProductData();
                                          if (productID != null) {
                                            Get.to(
                                              () => AddPhotographerScreen(
                                                productId: productID,
                                              ),
                                            );
                                          }
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

  void showDeleteConfirmation(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              categoryController.deleteCategory(category);
              Get.back();
              Get.back();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

void showCalendar(BuildContext context, Rx<DateTime> selectedDate,
    TextEditingController dateController) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return Container(
        padding: EdgeInsets.all(16),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: selectedDate.value,
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) {
            return isSameDay(selectedDate.value, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            selectedDate.value = selectedDay;
            dateController.text =
                '${selectedDay.day}/${selectedDay.month}/${selectedDay.year}';
            Navigator.pop(context);
          },
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(
              color: Colors.white,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: Colors.black,
            ),
            defaultTextStyle: iStyleBlack13700,
            weekendTextStyle: iStyleBlack13700,
            outsideDaysVisible: false,
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.grey),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.grey),
          ),
        ),
      );
    },
  );
}
