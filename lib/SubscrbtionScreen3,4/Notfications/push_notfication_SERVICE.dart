import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/SubscrbtionScreen3,4/Notfications/Local_Notfication.dart';
import 'package:second/SubscrbtionScreen3,4/Notfications/Notfication_Cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotficationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static late BuildContext context;

  static void setContext(BuildContext ctx) {
    context = ctx;
  }

  static Future init() async {
    final prefs = await SharedPreferences.getInstance();
    await Firebase.initializeApp();
    await messaging.requestPermission();

    String? token = await messaging.getToken();
    await prefs.setString("fcm_token", token!);
    print(
        '................................................................................................................');
    print("Firebase Messaging Token: $token");
    print(
        "................................................................................................................");

    /// 📌 app مقفول
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      NotificationCubit cubit = BlocProvider.of<NotificationCubit>(context);

      cubit.increase();
      _navigate();
    }

    /// 📌 background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      NotificationCubit cubit = BlocProvider.of<NotificationCubit>(context);

      cubit.increase();
      _navigate();
    });

    /// 📩 foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      LocalNotificationService.showBasicNotification(message);

      NotificationCubit cubit = BlocProvider.of<NotificationCubit>(context);

      cubit.increase();
    });
  }

  static void _navigate() {
    Navigator.pushNamed(context, "NotificationScreen");
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    print(
        '................................................................................................................');
    print("Handling background message: ${message.notification?.title} ");
    print(
        '................................................................................................................');
  }
}
