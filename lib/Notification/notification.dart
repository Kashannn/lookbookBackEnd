import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:googleapis_auth/auth_io.dart' as google_auth;
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lookbook/Model/Chat/reports_model.dart';
import 'package:lookbook/Model/user/user_model.dart';
import 'package:lookbook/views/Designer/profile_screen.dart';
import 'package:uuid/uuid.dart';

import '../Model/AddProductModel/product_reported_model.dart';
import '../Model/Chat/chat_room_model.dart';
import '../Model/NotificationModel/notification_model.dart';
import '../controllers/chat_controller.dart';
import '../controllers/customer_report_controller.dart';
import '../controllers/sign_up_screen_controller.dart';
import '../views/Admin/Reports/Message_report_screen.dart';
import '../views/Admin/Reports/report_screen.dart';
import '../views/Customer/customer_all_conversation_screen.dart';
import '../views/Customer/customer_message_chat_screen.dart';
import '../views/Designer/designer_message_chat_screen.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Uuid uuid = const Uuid();
  Future<void> updateNotificationStatus(
      String notificationId, bool isRead) async {
    await FirebaseFirestore.instance
        .collection('Notifications')
        .doc(notificationId)
        .update({'isRead': isRead});
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined permission');
    }
  }

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
        handleMessage(context, message);
      },
    );
  }

  void firebaseInit(BuildContext context) {
    if (kDebugMode) {
      FirebaseMessaging.onMessage.listen((message) {
        print(message.notification!.body.toString());
        print(message.notification!.title.toString());
        print(message.data['name']);
        print(message.data['type']);
        print(message.data['id']);
        print(message.data['targetId']);

        initLocalNotification(context, message);
        showNotification(message);
      });
    }
  }

  Stream<int> getUnreadNotificationCount(String userId) {
    return FirebaseFirestore.instance
        .collection('Notifications')
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<NotificationModel>> fetchNotifications() {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('Notifications')
        .where('receiverId', isEqualTo: userId)
        .where('notificationType', whereIn: ['MessageReport', 'report'])
        .orderBy('time', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromMap(doc.data()))
            .toList());
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      'Channel Name',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            ticker: 'ticker');
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<String> getToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void handleMessage(BuildContext context, RemoteMessage message) async {
    print("DATA MESSAGE" + message.data.toString());

    if (message.data['type'] == 'chat') {
      UserModel? userModel = await SignUpController().getUserByUserId(
        message.data['senderId'].toString(),
      );

      String SenderId = message.data['senderId'];
      String chatroomId = message.data['chatroomId'];
      Get.to(() => DesignerMessageChatScreen(
            chatroom: ChatRoomModel(
                chatroomId: chatroomId,
                lastMessage: message.notification!.body.toString(),
                participants: {}),
            currentUserId: FirebaseAuth.instance.currentUser!.uid,
            otherUserId: SenderId,
            user: userModel!,
          ));
    } else if (message.data['type'] == 'report') {
      String? reportedBy = message.data['senderId'];
      // String? reportedDesigner = message.data['reportedDesigner'];
      // String? reportedAt = message.data['reportedAt'];

      String productId = message.data['chatroomId']!;
      try {
        ProductReportedModel? productReportedModel =
            await CustomerReportController()
                .getReportByProductIdAndReportedBy(productId, reportedBy!);
        UserModel? user = await SignUpController().getUserByUserId(
          productReportedModel?.reportedBy ?? '',
        );
        Get.to(() => ReportScreen(
              productReportedModel: ProductReportedModel(
                productId: productReportedModel?.productId ?? '',
                reason: productReportedModel?.reason ?? '',
                reportedBy: productReportedModel?.reportedBy ?? '',
                reportedDesigner: productReportedModel?.reportedDesigner ?? '',
                reportedAt: DateTime.now(),
                reportedByUser: user,
              ),
            ));
      } catch (e) {
        print("Error parsing reportedAt date: $e");
      }
    } else if (message.data['type'] == 'MessageReport') {
      ReportsModel reportsModel =
          await ChatController().getReportById(message.data['chatroomId']!);
      UserModel? reportedBy = await SignUpController().getUserByUserId(
        reportsModel.reportedBy.toString(),
      );
      Get.to(
        () => MessageReportScreen(
          report: ReportsModel(
            id: reportsModel.id,
            reported: reportsModel.reported,
            reportedBy: reportsModel.reportedBy,
            messageId: reportsModel.messageId,
            chatroomId: reportsModel.chatroomId,
            reason: reportsModel.reason,
            imageUrl: reportsModel.imageUrl,
            date: reportsModel.date,
            reportedByUser: reportedBy,
          ),
        ),
      );
    }
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      print('Token Refreshed');
    });
  }

  final serviceAccountJson = {
    "type": "service_account",
    "project_id": "lookbook-19db7",
    "private_key_id": "379d54dbc49953791d197d0b3711dedb8f30b2c9",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC5/a/8/NeYOP7F\niDvvIIX9thYjPzWwZ490qUFQo+hLdmBbBU2BrJRkiLgjRfR6k1SETYxETdcRF2ZD\n51FLoGtgi/W/fteXgbYfS/+qPW8TE6f0jIcyUroxwMkw+ita3safXIPA6ZKxDlm2\nr4h5/j/RR+I6fVUPmBb2drQlALh2O+NI3m5JSi+YwNvxZhAoWNkpLKHr2n7snpcz\nXxrDWuKSiiiAFol7TrL8BNQGBB4RSJBd7JDRDt3+ayt80/wW1CnQM0Kw8PHyKbA+\nxIkGz0yVhwfShcASc+XnzvTWgTgYa9VC9elMTijhAUaPXmhE+a+WKQ2vGAoHE7gQ\nSXID7Y71AgMBAAECggEACn4cm9Pi0NBkVR4ArZai4IORf6cM/xj0j6MNz4ATtpAk\n0vW7X+Wt0HcjFkBX0MN3iOg8Ec1nZOwyRYHrBO51qFJ1CHreLEqxzNWzhHXnSob5\nGnOEHAttPCnRX905LWz0fSCRwUQcFbeGyabg9uroTET3JxATiKfuobRkKNM/1NGm\n+YCxwCv8UrGAfiluVAFTbElbPEFL3iIWbJU8VRZvEiyfcCVc6JdcSbHq4XtmOoD1\nMGlk7I6suO9pC+SJCydOEEaDWGVVrbxCx0qFxrwp+nPntarD5+6yXASKfMFEM5Re\nenHxBYK9H0bsGqGTHgA9f1PJ5Lf75GnbdJfdNHy1uQKBgQDgMUum5Evuvk+wNxJH\nJCx3xqcnMR9xgFYdGPr3x16mviLDkFMHinNF9AtEVhoQxvCeRAbUXnlJIGN2VwRH\nMRNU/EsqtoBoQzaJtLx3MW2apvsjUfCXvE78H22O0VhS1o7Lspr7WzQwLnClTOlz\nloMgyfT+jvyKgiEzwz27j3+STQKBgQDUYOeiENUFWIqalo1twvSPYzHIg3l0qmmR\n7WiFoT6Jt8tIkF0mGKbhcCr1kH6GHz7iccrqr7eKwCTBXXDIOEgCOgxvyB+xt4oy\ntGLOC+DOXUU0NeiJGpuAkvNtPD2MsRxn5luOEGox46Ldoj0qTZr2EL/FfMtldRLu\nNT1NkMWzSQKBgFyTPn/9yXUeVN2ZAA0sXMhg2WkPmcJOkkCVrhxe0TDdVpGWqRJ2\nEz+RlI11WHIRFA7mXEOZd0/A9hFJwVR8aVUwkQFkNwXWq1CVtzUoze+MgCuHjGe7\ntInbmGve+i/KtVBbwi+E67nxk0ZOyh+WyTLi8i2jcZjoPzmWp4kpqi4JAoGAThx2\nFT1rm9O85q6Ixd32ZOZu4Pi6KxaiTXGsB7oObkiTE9VE7UYT2saOhlLmth2320FP\nCJIoR3f0DMp5OKq6kVcYS+SnA44l3hBKZs4nmL7lPRa2t/Z5SwjBT2Pgn2ZktDId\nalrPNBotRKbvKCfy3p26asBDbsVoeQRLz8N3c0ECgYBmw9hNPerQL85f3u2sWXKD\nkXxdC2yc9BlswFFCerYxWS7bv+hqXpu9cPWiMmJKre2MBBEKITaMR7FogTjLt6Lt\nLCe0QWGBMNqeKuBQ0XTRF7toUb7EBx5LY5PbawF4MYsFdUWnHce+0Qq+u+eZ/5UV\nSHiAHcO4VmsvTc0Ppwkw7g==\n-----END PRIVATE KEY-----\n",
    "client_email": "notifications@lookbook-19db7.iam.gserviceaccount.com",
    "client_id": "115645738474061898380",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/notifications%40lookbook-19db7.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  Future<String> getAccessToken() async {
    try {
      final credentials =
          google_auth.ServiceAccountCredentials.fromJson(serviceAccountJson);

      final List<String> scopes = [
        'https://www.googleapis.com/auth/firebase.messaging',
        'https://www.googleapis.com/auth/cloud-platform',
      ];

      // Get OAuth2 client
      final google_auth.AutoRefreshingAuthClient client =
          await google_auth.clientViaServiceAccount(credentials, scopes);

      // Obtain the access token
      final accessToken = client.credentials.accessToken.data;

      print('Access Token: $accessToken');
      return accessToken;
    } catch (e) {
      print('Error obtaining access token: $e');
      rethrow;
    }
  }

  Future<void> sendPushNotification(
    String name,
    String token,
    String msg,
    String receiverId,
    String type,
    String? ChatroomId,
    String? productId,
  ) async {
    try {
      final String accessToken = await getAccessToken();

      // Firebase FCM v1 URL for your project
      final String fcmUrl =
          'https://fcm.googleapis.com/v1/projects/lookbook-19db7/messages:send';

      final body = {
        'message': {
          'token': token,
          'notification': {
            'title': name,
            'body': msg,
          },
          'data': {
            'id': auth.currentUser?.uid ?? '',
            'targetId': receiverId,
            'senderId': auth.currentUser?.uid ?? '',
            'type': type,
            'chatroomId': ChatroomId ?? '',
          },
        },
      };

      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Notification sent successfully
        await _saveNotificationToFirestore(receiverId, msg, type,
            productId: productId);
        print('Notification sent: ${response.body}');
      } else {
        // Handle unsuccessful response
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }

  Future<void> chatSendPushNotification(
    String name,
    String token,
    String msg,
    String receiverId,
    String type,
    String? ChatroomId,
    String? productId,
  ) async {
    try {
      final String accessToken = await getAccessToken();

      // Firebase FCM v1 URL for your project
      final String fcmUrl =
          'https://fcm.googleapis.com/v1/projects/lookbook-19db7/messages:send';

      final body = {
        'message': {
          'token': token,
          'notification': {
            'title': name,
            'body': msg,
          },
          'data': {
            'id': auth.currentUser?.uid ?? '',
            'targetId': receiverId,
            'senderId': auth.currentUser?.uid ?? '',
            'type': type,
            'chatroomId': ChatroomId ?? '',
          },
        },
      };

      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Notification sent successfully
        // await _saveNotificationToFirestore(receiverId, msg, type,
        //     productId: productId);
        print('Notification sent: ${response.body}');
      } else {
        // Handle unsuccessful response
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }

// Save Notification to Firestore
  Future<void> _saveNotificationToFirestore(
      String receiverId, String message, String notificationType,
      {String? productId, String? senderId}) async {
    try {
      // Create a notification model with an empty ID initially
      NotificationModel notification = NotificationModel(
          id: '', // Initially empty, will update after Firestore generates ID
          senderId: senderId ??
              auth.currentUser?.uid ??
              '', // Admin or current user as sender
          receiverId: receiverId, // Designer's ID as receiver
          message: message, // Notification message, e.g. product removal
          time: DateTime.now(),
          productId: productId ?? '', // Add productId if available
          notificationType: notificationType);

      // Save the notification to Firestore and let Firestore generate the ID
      DocumentReference docRef =
          await firestore.collection('Notifications').add(notification.toMap());

      // Update the document with the generated ID
      await firestore.collection('Notifications').doc(docRef.id).update({
        'id': docRef.id,
      });

      print('Notification saved to Firestore with ID: ${docRef.id}');
    } catch (e) {
      // Handle Firestore write error
      print('Error saving notification to Firestore: $e');
    }
  }
}
