// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:lookbook/Firebase/firebase_customerEnd_services.dart';
// import 'package:lookbook/Model/NotificationModel/notification_model.dart';
// import 'package:lookbook/Notification/notification.dart';
// import 'package:lookbook/extension/sizebox_extension.dart';
//
// import '../../Model/user/user_model.dart';
// import '../../utils/components/constant/app_colors.dart';
// import '../../utils/components/constant/app_images.dart';
// import '../../utils/components/constant/app_textstyle.dart';
//
// class DesignerNotificationScreen extends StatelessWidget {
//   const DesignerNotificationScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 26.h),
//           child: Column(
//             children: [
//               20.ph,
//               Center(
//                 child: Text(
//                   'N O T I F I C A T I O N S',
//                   style: tSStyleBlack18600,
//                 ),
//               ),
//               Center(
//                 child: SvgPicture.asset(
//                   AppImages.line,
//                   width: 150.w,
//                   height: 15.h,
//                   color: AppColors.text1,
//                 ),
//               ),
//               30.ph,
//               StreamBuilder<List<NotificationModel>>(
//                 stream: NotificationService().fetchNotifications('removed'),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   if (!snapshot.hasData) {
//                     return Center(child: Text('NO NOTIFICATIONS TO SHOW', style: tSStyleBlack16400,));
//                   }
//
//                   List<NotificationModel> notifications = snapshot.data!;
//
//                   return Expanded(
//                     child: ListView.builder(
//                       itemCount: notifications.length,
//                       itemBuilder: (BuildContext context, int index) {
//                       NotificationModel notificationModel = notifications[index];
//
//
//                       return FutureBuilder(
//                         future: FirebaseCustomerEndServices().fetchUser(notificationModel.senderId),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//
//                           if (!snapshot.hasData) {
//                             return const Text('No notifications found');
//                           }
//
//                           UserModel? user = snapshot.data!;
//
//                           return Row(
//                             children: [
//                               CircleAvatar(
//                                 // radius: 30.0.r,
//                                 backgroundColor: Colors.transparent,
//                                 child: ClipOval(
//                                   child: Image.network(
//                                     user.imageUrl!,
//                                     fit: BoxFit.cover,
//                                     width: 60.0.w,
//                                     height: 60.0.h,
//                                   ),
//                                 ),
//                               ),
//                               15.pw,
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     user.fullName!,
//                                     style: iStyleBlack13700.copyWith(
//                                       color: AppColors.text3,
//                                     ),
//                                   ),
//                                   //5.ph,
//                                   Text(
//                                     notificationModel.message,
//                                     style: iStyleBlack13400.copyWith(
//                                       color: AppColors.text2,
//                                     ),
//                                   )
//                                 ],
//                               )
//                             ],
//                           );
//                         },
//
//                       );
//                     },
//                     ),
//                   );
//                 }
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
