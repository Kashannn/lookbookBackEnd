import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/add_product_controller.dart';
import 'constant/app_colors.dart';
import 'constant/app_textstyle.dart';

class ColorPickerWidget extends StatefulWidget {
  final AddProductController controller;

  ColorPickerWidget({required this.controller});

  @override
  _ColorPickerWidgetState createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  Color pickerColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Colors',
          style: tSStyleBlack16600.copyWith(
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 10.h),
        // Display the selected colors
        Obx(() {
          return Container(
            // height: 50.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Wrap(
                spacing: 10.w,
                runSpacing: 2.h,
                children: [
                  ...widget.controller.selectedColors.map((color) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 50.w,
                              height: 40.h,
                            ),
                            Container(
                              width: 35.w,
                              height: 35.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                                border: Border.all(color: AppColors.secondary),
                              ),
                            ),
                            Positioned(
                              left: 25,
                              // bottom: 22,
                              child: GestureDetector(
                                onTap: () {
                                  widget.controller.removeColor(widget
                                      .controller.selectedColors
                                      .indexOf(color));
                                },
                                child: Icon(
                                  Icons.dangerous_rounded,
                                  color: Colors.red,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  // Button to add a new color
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Pick a color'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: pickerColor,
                              onColorChanged: (Color color) {
                                setState(() {
                                  pickerColor = color;
                                });
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Select'),
                              onPressed: () {
                                setState(() {
                                  widget.controller.selectedColors
                                      .add(pickerColor);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        width: 35.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.secondary),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: AppColors.primaryColor,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
