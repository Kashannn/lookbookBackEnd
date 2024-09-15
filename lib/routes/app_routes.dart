import 'package:get/get.dart';
import 'package:lookbook/utils/components/custom_menu.dart';
import 'package:lookbook/views/Designer/addproduct_screen.dart';
import 'package:lookbook/views/authentication/create_with_screen.dart';
import 'package:lookbook/views/authentication/forgot_password_screen.dart';
import 'package:lookbook/views/authentication/sign_in_screen.dart';
import 'package:lookbook/views/authentication/sign_up_screen.dart';
import 'package:lookbook/views/designer/addproduct_screen1.dart';
import 'package:lookbook/views/designer/product_detail.dart';
import 'package:lookbook/views/welcomeScreen.dart';

import '../utils/components/Customer_custom_menu.dart';
import '../utils/components/admin_custom_menu.dart';
import '../utils/components/designer_custom_menu.dart';
import '../views/Admin/Conversations/admin_allconversation_screen.dart';
import '../views/Admin/Products/remove_product_screen.dart';
import '../views/Admin/admin_notification_screen.dart';
import '../views/Admin/admin_profile_screen.dart';
import '../views/Customer/Customer_Profile_Screen.dart';
import '../views/Customer/customer_Notification_Screen.dart';
import '../views/Customer/customer_message_chat_screen.dart';
import '../views/Customer/customer_product_detail_screen.dart';
import '../views/Designer/designer_message_chat_screen.dart';
import '../views/Designer/home_screnn.dart';
import '../views/Designer/notification_screen.dart';
import '../views/Designer/profile_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => WelcomeScreen(),
    ),
    GetPage(
      name: '/signin',
      page: () => SignInScreen(),
    ),
    GetPage(
      name: '/createwith',
      page: () => const CreateWithScreen(),
    ),
    GetPage(
      name: '/signup',
      page: () => SignUpScreen(),
    ),
    GetPage(
      name: '/forgot',
      page: () => ForgotPasswordScreen(),
    ),
    GetPage(
      name: '/addProduct',
      page: () => const AddProductScreen(),
    ),
    GetPage(
      name: '/menu',
      page: () => const CustomMenu(),
    ),
    GetPage(
      name: '/addProduct1',
      page: () => AddproductScreen1(),
    ),
    // GetPage(
    //   name: '/addPhotographer',
    //   page: () => AddPhotographerScreen(
    //
    //   ),
    // ),
    GetPage(
      name: '/productDetail',
      page: () => ProductDetail(),
    ),
    GetPage(
      name: '/home',
      page: () =>  DesignerHomeScreen(),
    ),
    GetPage(
      name: '/CustomerProductDetailScreen',
      page: () => const CustomerProductDetailScreen(),
    ),
    GetPage(
      name: '/AdminCustomMenu',
      page: () => const AdminCustomMenu(),
    ),
    GetPage(
      name: '/AdminProfileScreen',
      page: () => const AdminProfileScreen(),
    ),
    GetPage(
      name: '/AdminAllConversationScreen',
      page: () => const AdminAllConversationScreen(),
    ),
    GetPage(
      name: '/AdminNotificationScreen',
      page: () => const AdminNotificationScreen(),
    ),
    GetPage(
      name: '/CustomerCustomMenu',
      page: () => const CustomerCustomMenu(),
    ),
    GetPage(
      name: '/CustomerProfileScreen',
      page: () => const CustomerProfileScreen(),
    ),
    GetPage(
      name: '/CustomerMessageChatScreen',
      page: () => const CustomerMessageChatScreen(),
    ),
    GetPage(
      name: '/CustomerNotificationScreen',
      page: () => const CustomerNotificationScreen(),
    ),
    GetPage(
      name: '/DesignerCustomMenu',
      page: () => const DesignerCustomMenu(),
    ),
    GetPage(
      name: '/DesignerMessageChatScreen',
      page: () => const DesignerMessageChatScreen(),
    ),


    GetPage(
      name: '/ProfileScreen',
      page: () =>  ProfileScreen(),
    ),
    GetPage(
      name: '/DesignerNotificationScreen',
      page: () => const DesignerNotificationScreen(),
    ),
    GetPage(
      name: '/RemoveProductScreen',
      page: () => const RemoveProductScreen(),
    ),


  ];
}
