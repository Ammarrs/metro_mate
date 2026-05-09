import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:second/SubscrbtionScreen3,4/Notfications/Local_Notfication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotficationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

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

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          '................................................................................................................');
      print(
          "Received a message while in the foreground: ${message.notification?.title}");
      print(
          '................................................................................................................');
      LocalNotificationService.showBasicNotification(
        message,
      );
    });
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
