import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';
import '../../controllers/add_product_controller.dart';

class EditSizeSelector extends StatefulWidget {
   AddProductController controller;
   List<String>? sizes;

  EditSizeSelector({required this.controller, this.sizes});

  @override
  _EditSizeSelectorState createState() => _EditSizeSelectorState();
}

class _EditSizeSelectorState extends State<EditSizeSelector> {
  // Initially, no size is selected
 // List<String> selectedSizes = [];
  @override
  void initState() {
    // TODO: implement initState
    widget.controller.selectedSizes= widget.sizes!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sizes',
          style: tSStyleBlack16600.copyWith(
            color: AppColors.primaryColor,
          ),
        ),
        10.ph,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildSizeOption('S'),
              10.pw,
              _buildSizeOption('M'),
              10.pw,
              _buildSizeOption('L'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSizeOption(String size) {
    bool? isSelected;
    widget.controller.selectedSizes.contains(size) ? isSelected = true : isSelected = false;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected== true) {
            widget.controller.selectedSizes.remove(size);  // Remove if already selected
          } else {
            widget.controller.selectedSizes.add(size);     // Add if not selected
          }
        });
        print(widget.controller.selectedSizes);
        print(isSelected);
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected == true ? Colors.black : Colors.grey.shade300,
        ),
        child: Text(
          size,
          style: TextStyle(
            color: isSelected == true ? Colors.white : Colors.black,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
