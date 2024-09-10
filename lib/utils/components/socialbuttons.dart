import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';

// ignore: must_be_immutable
class socialbuttons extends StatelessWidget {
  String image;
  final Callback ontap;
  socialbuttons({
    super.key,
    required this.image,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.grey1,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(image),
          ),
        ),
      ),
    );
  }
}
