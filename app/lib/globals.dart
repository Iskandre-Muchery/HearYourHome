library app.globals;

import 'package:app/models.dart';
import 'package:flutter/foundation.dart';

ValueNotifier<bool> isConnectedToBackEnd = ValueNotifier(false);
bool isLoggedToBackEnd = false;
UserResponse user;
String apiIpAddr = "";
String apiPort = "";
String email = "";
String appMode = "";
