import 'package:app/backEndSetupScreen.dart';
import 'package:app/changePasswordScreen.dart';
import 'package:app/firebaseConnect.dart';
import 'package:app/globals.dart' as globals;
import 'package:app/notificationsScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:app/loginScreen.dart';



void main() {
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void setEnvironmentVars() {
    globals.appMode = String.fromEnvironment('APP_MODE', defaultValue: 'PROD');
    globals.apiIpAddr =
        String.fromEnvironment('API_IP_ADDRESS', defaultValue: '40.89.156.191');
    globals.apiPort = String.fromEnvironment('API_PORT', defaultValue: '8000');
  }

  void initializePushNotifications() {
    final pushNotificationService = NotificationPush(_firebaseMessaging);
    pushNotificationService.initialise();
  }

  @override
  Widget build(BuildContext context) {
    setEnvironmentVars();
    initializePushNotifications();
    return MaterialApp(
      debugShowCheckedModeBanner: (globals.appMode != "PROD") ? true : false,
      title: 'HearYourHome',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      routes: {
        "/": (_) => LoginPage(),
        "/BackEndSetup": (_) => BackEndSetupScreen(),
        "/ChangePassword": (_) => ChangePasswordScreen(),
        "/NotificationsScreen": (_) => NotificationsScreen(),
      },
    );
  }
  
}
