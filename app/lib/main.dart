import 'package:app/backEndSetupScreen.dart';
import 'package:app/changePasswordScreen.dart';
import 'package:app/globals.dart' as globals;
import 'package:app/notificationsScreen.dart';
import 'package:flutter/material.dart';
import 'package:app/loginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  void setEnvironmentVars() {
    globals.appMode = String.fromEnvironment('APP_MODE', defaultValue: 'PROD');
    globals.apiIpAddr =
        String.fromEnvironment('API_IP_ADDRESS', defaultValue: '40.89.156.191');
    globals.apiPort = String.fromEnvironment('API_PORT', defaultValue: '8000');
  }

  @override
  Widget build(BuildContext context) {
    setEnvironmentVars();
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
