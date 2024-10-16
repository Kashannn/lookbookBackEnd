import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getDeviceToken() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return await _firebaseMessaging.getToken();
    } else {
      return null;
    }
  }

  Future<void> initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      final androids = message.notification?.android;
      final iOS = message.notification?.apple;

      if (Platform.isIOS) {
        PushNotificationService().showNotification(notification!, null, iOS);
      } else if (Platform.isAndroid) {
        PushNotificationService()
            .showNotification(notification!, androids, null);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  Future<String> _getAccessToken() async {
    final serviceAccount = json.decode(
      await rootBundle.loadString('asset/json/service-account-file.json'),
    );

    final auth.ServiceAccountCredentials credentials =
        auth.ServiceAccountCredentials.fromJson(serviceAccount);

    final auth.AutoRefreshingAuthClient client = await auth
        .clientViaServiceAccount(credentials,
            ['https://www.googleapis.com/auth/firebase.messaging']);

    return (client.credentials).accessToken.data;
  }

  Future<void> sendNotification(
      String receiverToken, String heading, String message) async {
    final String accessToken = await _getAccessToken();
    const String server =
        'https://fcm.googleapis.com/v1/projects/lookbook-19db7/messages:send';

    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final Map<String, dynamic> data = {
      'message': {
        'token': receiverToken,
        'notification': {
          'title': heading,
          'body': message,
        },
      }
    };

    final http.Response response = await http.post(
      Uri.parse(server),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
    } else {}
  }

  Future<void> showNotification(RemoteNotification notification,
      AndroidNotification? android, AppleNotification? iOS) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Camino-Wizard',
      'Camino-Wizard',
      channelDescription: 'Camino-Wizard Notification',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'app_icon',
    );

    // iOS notification details
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      notification.title ?? 'No Title',
      notification.body ?? 'No Body',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
