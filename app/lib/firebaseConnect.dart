import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class NotificationPush {
  final FirebaseMessaging _fcm;

  Future<String> get_fcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    return (fcmToken);
  }
  
  NotificationPush(this._fcm);

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestPermission(alert: true, sound: true, badge: true);
    }
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _fcm.setAutoInitEnabled(true);


    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");

    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    // );
  }
}

class PushNotificationMessage {
  
  final String title;
  final String body;
  
  PushNotificationMessage({
    @required this.title,
    @required this.body,
  });
}