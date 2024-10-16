import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';

class BuildLinks extends StatelessWidget {
  String image;
  final Callback ontap;
  String text;
  BuildLinks({
    super.key,
    required this.image,
    required this.ontap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Row(
        children: [
          SvgPicture.asset(
            image,
          ),
          10.pw,
          Text(
            text,
            style: oStyleBlack14300.copyWith(
              color: AppColors.text1,
              decoration: TextDecoration.underline,
            ),
          ),
          10.pw,
          const Icon(
            Icons.arrow_forward,
            color: AppColors.secondary,
            size: 18,
          ),
        ],
      ),
    );
  }
}