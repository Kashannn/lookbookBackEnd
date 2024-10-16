import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/controllers/admin_chat_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Model/Chat/chat_room_model.dart';
import '../../../Model/user/user_model.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';
import '../../../utils/components/custom_search_bar.dart';
import 'message-chat_screen.dart';

import 'package:flutter_svg/flutter_svg.dart';

class AdminAllConversationScreen extends StatelessWidget {
  AdminAllConversationScreen({Key? key}) : super(key: key);

  // Inject the controller using GetX
  final AdminChatController controller = Get.put(AdminChatController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const CustomAppBar(),
            SizedBox(
              height: 72.h,
              width: 430.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'C O N V E R S A T I O N S',
                    style: tSStyleBlack18500,
                  ),
                  SvgPicture.asset(
                    AppImages.line,
                    color: AppColors.text1,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 43.h,
              width: 385.w,
              child: CustomSearchBar3(
                searchController: controller.searchController,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.error.isNotEmpty) {
                  return Center(child: Text('Error: ${controller.error}'));
                }
                if (controller.filteredChatRooms.isEmpty) {
                  return Center(
                    child: Text(
                      controller.searchQuery.value.isEmpty
                          ? 'NO CHATS TO SHOW'
                          : 'NO CHATS MATCHING YOUR SEARCH',
                      style: tSStyleBlack16400,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.filteredChatRooms.length,
                  itemBuilder: (BuildContext context, int index) {
                    ChatRoomModel chatRoom =
                        controller.filteredChatRooms[index];
                    List<String> userIds = chatRoom.participants!.keys.toList();

                    if (userIds.length < 2) {
                      return SizedBox();
                    }
                    return FutureBuilder<List<UserModel?>>(
                      future: Future.wait(userIds.map((userId) => controller
                          .firebaseCustomerEndServices
                          .fetchUser(userId))),
                      builder: (context, userSnapshot) {
                        String getInitials(String name) {
                          List<String> nameParts = name.split(' ');
                          if (nameParts.length >= 2) {
                            return nameParts[0][0] + nameParts[1][0];
                          } else if (nameParts.isNotEmpty) {
                            return nameParts[0][0];
                          }
                          return '';
                        }

                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox.shrink();
                        }

                        if (!userSnapshot.hasData ||
                            userSnapshot.data!.contains(null)) {
                          // If any user is not found, don't display anything
                          return SizedBox
                              .shrink(); // Don't show anything if user data is not found
                        }

                        // If both users are found, display the chat tile
                        UserModel user1 = userSnapshot.data![0]!;
                        UserModel user2 = userSnapshot.data![1]!;

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 18.0.w, vertical: 5.h),
                          child: SizedBox(
                            child: InkWell(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessageChatScreen(
                                      chatroom: chatRoom,
                                      user1: user1,
                                      user2: user2,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: const Color(0xFFF8F9FE),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: ClipOval(
                                                    child: user2.imageUrl !=
                                                                null &&
                                                            user2.imageUrl!
                                                                .isNotEmpty
                                                        ? Image.network(
                                                            user2.imageUrl!,
                                                            fit: BoxFit.cover,
                                                            width: 60.0.w,
                                                            height: 60.0.h,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null)
                                                                return child;
                                                              return Shimmer
                                                                  .fromColors(
                                                                baseColor:
                                                                    Colors.grey[
                                                                        300]!,
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        100]!,
                                                                child:
                                                                    Container(
                                                                  width: 60.0.w,
                                                                  height:
                                                                      60.0.h,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppColors
                                                                        .secondary
                                                                        .withOpacity(
                                                                            0.5),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return Container(
                                                                width: 60.0.w,
                                                                height: 60.0.h,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .secondary
                                                                      .withOpacity(
                                                                          0.5),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    getInitials(
                                                                        user2.fullName ??
                                                                            ''),
                                                                    style: tSStyleBlack18500
                                                                        .copyWith(
                                                                      color: AppColors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : Container(
                                                            width: 60.0.w,
                                                            height: 60.0.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .secondary
                                                                  .withOpacity(
                                                                      0.5),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                getInitials(
                                                                    user2.fullName ??
                                                                        ''),
                                                                style:
                                                                    tSStyleBlack18500
                                                                        .copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: ClipOval(
                                                  child: user1.imageUrl !=
                                                              null &&
                                                          user1.imageUrl!
                                                              .isNotEmpty
                                                      ? Image.network(
                                                          user1.imageUrl!,
                                                          fit: BoxFit.cover,
                                                          width: 60.0.w,
                                                          height: 60.0.h,
                                                          loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;
                                                            return Shimmer
                                                                .fromColors(
                                                              baseColor: Colors
                                                                  .grey[300]!,
                                                              highlightColor:
                                                                  Colors.grey[
                                                                      100]!,
                                                              child: Container(
                                                                width: 60.0.w,
                                                                height: 60.0.h,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .secondary
                                                                      .withOpacity(
                                                                          0.5),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Container(
                                                              width: 60.0.w,
                                                              height: 60.0.h,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .secondary
                                                                    .withOpacity(
                                                                        0.5),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  getInitials(
                                                                      user1.fullName ??
                                                                          ''),
                                                                  style: tSStyleBlack18500
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      : Container(
                                                          width: 60.0.w,
                                                          height: 60.0.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .secondary
                                                                .withOpacity(
                                                                    0.5),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              getInitials(user1
                                                                      .fullName ??
                                                                  ''),
                                                              style:
                                                                  tSStyleBlack18500
                                                                      .copyWith(
                                                                color: AppColors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 15.0.w),
                                          Container(
                                            constraints:
                                                BoxConstraints(maxWidth: 270.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${user1.fullName} & ${user2.fullName}',
                                                  style:
                                                      iStyleBlack13700.copyWith(
                                                    color: AppColors.text3,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                chatRoom.lastMessage != ''
                                                    ? FittedBox(
                                                        // Allow the text to scale
                                                        child: Text(
                                                          chatRoom.lastMessage!,
                                                          style:
                                                              iStyleBlack13500
                                                                  .copyWith(
                                                            color:
                                                                AppColors.text2,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis, // Show ellipsis if it overflows
                                                        ),
                                                      )
                                                    : SizedBox.shrink(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_outlined,
                                        size: 25.sp,
                                        color: const Color(0xFFE47F46),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  String getUserNameFromId(String userId) {
    return '';
  }
}
