import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';
import '../../../utils/components/reusable_widget.dart';

class MessageChatScreen extends StatefulWidget {
  const MessageChatScreen({super.key});
  @override
  State<MessageChatScreen> createState() => _MessageChatScreenState();
}

class _MessageChatScreenState extends State<MessageChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(),
            SizedBox(height: 20.h),
            SizedBox(
              height: 72.h,
              width: 430.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'CONVERSATIONS',
                              style: tSStyleBlack18400,
                            ),
                            SvgPicture.asset(
                              AppImages.line,
                              color: AppColors.text1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  _buildChatBubble(
                    text: "Hey Lucas!\nHow's your project going?",
                    isSender: false,
                    avatar: 'assets/images/avatar_brooke.png',
                  ),
                  _buildChatBubble(
                    text: "Hi Brooke!",
                    isSender: true,
                    avatar: 'assets/images/avatar_lucas.png',
                  ),
                  _buildChatBubble(
                    text: "It's going well. Thanks for asking!",
                    isSender: true,
                    avatar: 'assets/images/avatar_lucas.png',
                  ),
                  _buildChatBubble(
                    text: "No worries. Let me know if you need any help 😊",
                    isSender: false,
                    avatar: 'assets/images/avatar_brooke.png',
                  ),
                  _buildChatBubble(
                    text: "You're the best!",
                    isSender: true,
                    avatar: 'assets/images/avatar_lucas.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble({
    required String text,
    required bool isSender,
    required String avatar,
  }) {
    return GestureDetector(
      onLongPressStart: (details) {
        showCustomPopupMenu(context, details.globalPosition);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isSender)
              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.secondary,
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundImage: const AssetImage(AppImages.noti),
                ),
              ),
            SizedBox(width: 10.w),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              constraints: BoxConstraints(maxWidth: 250.w),
              decoration: BoxDecoration(
                color: isSender ? AppColors.secondary : AppColors.counterColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                  bottomLeft: isSender
                      ? Radius.circular(15.r)
                      : const Radius.circular(0),
                  bottomRight: isSender
                      ? const Radius.circular(0)
                      : Radius.circular(15.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSender)
                    Text(
                      'Lucas',
                      style: tSStyleBlack12700.copyWith(color: AppColors.text5),
                    ),
                  if (!isSender)
                    Text(
                      'Brooke',
                      style: tSStyleBlack12700.copyWith(color: AppColors.text2),
                    ),
                  Text(
                    text,
                    style: isSender
                        ? tSStyleBlack14400.copyWith(color: AppColors.white)
                        : tSStyleBlack14400,
                  ),
                ],
              ),
            ),
            if (isSender) SizedBox(width: 10.w),
            if (isSender)
              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.secondary,
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundImage: const AssetImage(AppImages.profile),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
