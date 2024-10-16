import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/Model/Chat/chat_room_model.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/custom_search_bar.dart';
import 'package:shimmer/shimmer.dart';

import '../../Firebase/firebase_customerEnd_services.dart';
import '../../Model/Chat/message_model.dart';
import '../../Model/user/user_model.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/designer_allcustomer_controller.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import 'designer_message_chat_screen.dart';

class DesignerAllConversationScreen extends StatefulWidget {
  const DesignerAllConversationScreen({super.key});

  @override
  State<DesignerAllConversationScreen> createState() =>
      _DesignerAllConversationScreenState();
}

class _DesignerAllConversationScreenState
    extends State<DesignerAllConversationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ChatRoomModel> filteredChatRooms = [];
  List<ChatRoomModel> allChatRooms = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterChatRooms);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterChatRooms);
    _searchController.dispose();
    super.dispose();
  }

  void _filterChatRooms() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredChatRooms = allChatRooms.where((chatRoom) {
        String? customerId = chatRoom.participants!.keys
            .firstWhere((key) => key != FirebaseAuth.instance.currentUser!.uid);
        return customerId != null;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final DesignerAllCustomerController designerAllCustomerController =
        Get.put(DesignerAllCustomerController());
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseCustomerEndServices firebaseCustomerEndServices =
        FirebaseCustomerEndServices();
    final ChatController chatController = Get.put(ChatController());

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 72.h,
              width: 430.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'MESSAGES',
                    style: tSStyleBlack18400,
                  ),
                  SvgPicture.asset(
                    AppImages.line,
                    color: AppColors.text1,
                  ),
                ],
              ),
            ),
            10.ph,
            SizedBox(
              height: 43.h,
              width: 385.w,
              child: CustomSearchBar3(searchController: _searchController),
            ),
            20.ph,
            Expanded(
              child: StreamBuilder<List<ChatRoomModel>>(
                stream: designerAllCustomerController
                    .fetchAllChatRooms(currentUserId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'NO CHATS TO SHOW',
                            style: tSStyleBlack16400,
                          ),
                        ],
                      ),
                    );
                  }

                  // Update the chat rooms list based on search input
                  allChatRooms = snapshot.data!;
                  filteredChatRooms = _searchController.text.isEmpty
                      ? allChatRooms
                      : filteredChatRooms;

                  return ListView.builder(
                    itemCount: filteredChatRooms.length,
                    itemBuilder: (BuildContext context, int index) {
                      String getInitials(String name) {
                        List<String> nameParts = name.split(' ');
                        if (nameParts.length >= 2) {
                          return nameParts[0][0] + nameParts[1][0];
                        } else if (nameParts.isNotEmpty) {
                          return nameParts[0][0];
                        }
                        return '';
                      }

                      ChatRoomModel chatRoom = filteredChatRooms[index];
                      String? customerId;
                      try {
                        customerId = chatRoom.participants!.keys
                                .firstWhere((key) => key != currentUserId)
                            as String?;
                      } catch (e) {
                        print('Error extracting customerId: $e');
                        return SizedBox();
                      }

                      if (customerId == null) {
                        print('CustomerId is null');
                        return SizedBox();
                      }

                      return FutureBuilder<UserModel?>(
                        future:
                            firebaseCustomerEndServices.fetchUser(customerId),
                        builder: (context, customerSnapshot) {
                          if (customerSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox();
                          }
                          if (!customerSnapshot.hasData) {
                            return SizedBox();
                          }

                          UserModel? customer = customerSnapshot.data;
                          if (customer != null &&
                              customer.fullName!.toLowerCase().contains(
                                  _searchController.text.toLowerCase())) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                              child: SizedBox(
                                child: InkWell(
                                  onTap: () async {
                                    chatController.markMessagesAsRead(
                                      chatController.chatroomsRef
                                          .doc(chatRoom.chatroomId)
                                          .collection('messages'),
                                      currentUserId,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DesignerMessageChatScreen(
                                          chatroom: chatRoom,
                                          currentUserId: currentUserId,
                                          otherUserId: customerId!,
                                          user: customer,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: Colors.white,
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
                                              CircleAvatar(
                                                radius: 25.0.r,
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: ClipOval(
                                                  child:
                                                      customer.imageUrl !=
                                                                  null &&
                                                              customer.imageUrl!
                                                                  .isNotEmpty
                                                          ? Stack(
                                                              children: [
                                                                Shimmer
                                                                    .fromColors(
                                                                  baseColor:
                                                                      Colors.grey[
                                                                          300]!,
                                                                  highlightColor:
                                                                      Colors.grey[
                                                                          100]!,
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        60.0.w,
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
                                                                ),
                                                                // Display the Network Image
                                                                Positioned.fill(
                                                                  child:
                                                                      ClipOval(
                                                                    child: Image
                                                                        .network(
                                                                      customer
                                                                          .imageUrl!,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width:
                                                                          60.0.w,
                                                                      height:
                                                                          60.0.h,
                                                                      loadingBuilder: (BuildContext context,
                                                                          Widget
                                                                              child,
                                                                          ImageChunkEvent?
                                                                              loadingProgress) {
                                                                        if (loadingProgress ==
                                                                            null)
                                                                          return child;
                                                                        return Shimmer
                                                                            .fromColors(
                                                                          baseColor:
                                                                              Colors.grey[300]!,
                                                                          highlightColor:
                                                                              Colors.grey[100]!,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                60.0.w,
                                                                            height:
                                                                                60.0.h,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: AppColors.secondary.withOpacity(0.5),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) {
                                                                        return Container(
                                                                          width:
                                                                              60.0.w,
                                                                          height:
                                                                              60.0.h,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                AppColors.secondary.withOpacity(0.5),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              getInitials(customer.fullName ?? ''),
                                                                              style: tSStyleBlack18500.copyWith(
                                                                                color: AppColors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
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
                                                                      customer.fullName ??
                                                                          ''),
                                                                  style: tSStyleBlack18500
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                ),
                                              ),
                                              SizedBox(width: 15.0.w),
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 270.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      customer.fullName ?? '',
                                                      style: iStyleBlack13700
                                                          .copyWith(
                                                        color: AppColors.text3,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                    chatRoom.lastMessage != ''
                                                        ? Text(
                                                            chatRoom
                                                                .lastMessage!,
                                                            style:
                                                                iStyleBlack13500
                                                                    .copyWith(
                                                              color: AppColors
                                                                  .text2,
                                                            ),
                                                            maxLines: 1,
                                                          )
                                                        : SizedBox.shrink(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          StreamBuilder<List<MessageModel>>(
                                            stream: ChatController()
                                                .fetchUnreadMessages(chatRoom
                                                    .chatroomId!), // Fetch unread messages stream
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return SizedBox
                                                    .shrink(); // Show loading indicator while fetching
                                              }
                                              if (snapshot.hasError) {
                                                return SizedBox(); // Return empty space in case of error
                                              }

                                              // Get the number of unread messages
                                              int unreadCount = snapshot
                                                      .data?.length ??
                                                  0; // If there's no data, set count to 0

                                              // Conditionally render CircleAvatar based on unreadCount
                                              return unreadCount > 0
                                                  ? CircleAvatar(
                                                      radius: 15.0.r,
                                                      backgroundColor:
                                                          AppColors.secondary,
                                                      child: Text(
                                                        unreadCount
                                                            .toString(), // Display the count of unread messages
                                                        style: oStyleBlack14300
                                                            .copyWith(
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(); // Hide the CircleAvatar if there are no unread messages
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          else {
                            return SizedBox();
                          }
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
