import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:lookbook/core/app_theme.dart';
import 'package:lookbook/routes/app_routes.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/snackbar.dart';
import 'package:lookbook/views/Admin/admin_main_screen.dart';
import 'package:lookbook/views/Customer/customer_main_screen.dart';
import 'package:lookbook/views/Designer/designer_main_screen.dart';
import 'package:lookbook/views/authentication/additional_information_form.dart';
import 'package:lookbook/views/welcomeScreen.dart';
import 'package:uuid/uuid.dart';

import 'Notification/push_notification.dart';
import 'firebase_options.dart';

var uuid = const Uuid();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final messaging = FirebaseMessaging.instance;
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  if (Platform.isAndroid) {
    initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // // Initialize local notifications plugin for iOS
  // if (Platform.isIOS) {
  //   initializationSettingsIOS = DarwinInitializationSettings(
  //     requestAlertPermission: true,
  //     requestBadgePermission: true,
  //     requestSoundPermission: true,
  //     onDidReceiveLocalNotification: (id, title, body, payload) async {
  //       // Handle notification tapped logic
  //     },
  //   );
  // }

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      final android = message.notification?.android;
      final iOS = message.notification?.apple;
      PushNotificationService().showNotification(notification, android, iOS);
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('background message ${message.notification!.body}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Look Book',
          theme: AppTheme.lightThemeMode,
          initialRoute: '/',
          getPages: AppRoutes.routes,
          home: AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserSession();
    });
  }

  Future<void> _checkUserSession() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          if (userData['isBlocked'] == true) {
            CustomSnackBars.instance.showSuccessSnackbar(
              title: 'Blocked',
              message: "You are temporarily blocked.",
            );
            await _auth.signOut();
            Get.offAll(() => WelcomeScreen());
            return;
          }

          // Handle device token
          String? deviceToken = await FirebaseMessaging.instance.getToken();
          if (deviceToken != null && deviceToken.isNotEmpty) {
            String? existingToken = userData['deviceToken'];
            if (existingToken == null || existingToken != deviceToken) {
              // If device token is missing or has changed, update it
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({'deviceToken': deviceToken});
            }
          }

          // Role-based redirection
          String userRole = userData['role'];
          if (userRole == 'DESIGNER') {
            String? fullName = userData['fullName'];
            String? phone = userData['phone'];
            String? about = userData['about'];
            List<dynamic>? socialLinks = userData['socialLinks'];
            bool isMissingInfo = fullName == null ||
                fullName.isEmpty ||
                phone == null ||
                phone.isEmpty ||
                about == null ||
                about.isEmpty ||
                socialLinks == null ||
                socialLinks.isEmpty;
            if (isMissingInfo) {
              CustomSnackBars.instance.showFailureSnackbar(
                title: 'Incomplete Profile',
                message:
                    "Please fill out all required information before proceeding.",
              );
              Get.offAll(() => const AdditionalInformationForm());
              return;
            }
          }

          // Redirect based on user role
          if (userRole == 'ADMIN') {
            Get.offAll(() => AdminMainScreen());
          } else if (userRole == 'DESIGNER') {
            Get.offAll(() => DesignerMainScreen());
          } else if (userRole == 'CUSTOMER') {
            Get.offAll(() => CustomerMainScreen());
          } else {
            Get.offAll(() => WelcomeScreen());
          }
        } else {
          Get.offAll(() => WelcomeScreen());
        }
      } catch (e) {
        print('Error fetching user data: $e');
        Get.offAll(() => WelcomeScreen());
      }
    } else {
      Get.offAll(() => WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
