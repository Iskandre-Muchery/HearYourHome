import 'dart:ffi';

import 'package:app/changePasswordScreen.dart';
import 'package:app/httpRequests.dart';
import 'package:app/models.dart';
import 'package:flutter/material.dart';
import 'package:app/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  final TextEditingController _tokenFieldController =
      new TextEditingController();
  HttpRequests _api;
  String _email = "";
  String _token = "";
  String _password = "";
  //String _ip = "";
  //String _port = "";
  String _connectionStatus = "Not connected to Back-End";
  Image _connectionStatusIcon = new Image.asset("assets/icons/unvalid.png",
      width: 30, height: 30, fit: BoxFit.fitWidth);
  FormType _form = FormType.login;

  Future<bool> _tryConnectionToBackEndDebugMode() async {
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString('ip') ?? "";
    final port = prefs.getString('port') ?? "";

    if (ip == "" || port == "") {
      return false;
    }
    _api = HttpRequests(ip, port);
    if (await _api.ping() == true) {
      print("Ping: pong received from server");
      globals.isConnectedToBackEnd.value = true;
      return true;
    }
    print("Ping: pong not received from server");
    return false;
  }

  _LoginPageState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
    _tokenFieldController.addListener(_tokenListen);
  }

  void _tokenListen() {
    if (_tokenFieldController.text.isEmpty) {
      _token = "";
    } else {
      _token = _tokenFieldController.text;
    }
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  void _formChange() async {
    setState(() {
      if (_form == FormType.register) {
        _form = FormType.login;
      } else {
        _form = FormType.register;
      }
    });
  }

  void _showErrorMsg(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 5),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _displayExceptionWithSnackBar(String errorMsg) {
    var msg = errorMsg.substring(11);
    _showErrorMsg(msg);
  }

  @override
  Widget build(BuildContext context) {
    if (globals.appMode == "PROD") {
      _api = HttpRequests(globals.apiIpAddr, globals.apiPort);
    } else if (globals.appMode == "DEBUG") {
      _tryConnectionToBackEndDebugMode();
    }
    return new Scaffold(
      key: _scaffoldKey,
      appBar: _buildBar(context),
      body: new SingleChildScrollView(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: new Column(
            children: (globals.appMode == "DEBUG")
                ? <Widget>[
                    _buildConnectionStatus(),
                    _buildTextFields(),
                    _buildButtons(),
                  ]
                : <Widget>[
                    _buildTextFields(),
                    _buildButtons(),
                  ],
          )),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("HearYourHome"),
      centerTitle: true,
    );
  }

  Widget _buildConnectionStatus() {
    return new Container(
      padding: EdgeInsets.only(top: 20),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(right: 5),
            child: ValueListenableBuilder(
              valueListenable: globals.isConnectedToBackEnd,
              builder: (BuildContext context, bool isConnectedToBackEnd,
                  Widget child) {
                if (isConnectedToBackEnd == false) {
                  _connectionStatusIcon = new Image.asset(
                      "assets/icons/unvalid.png",
                      width: 30,
                      height: 30,
                      fit: BoxFit.fitWidth);
                  return _connectionStatusIcon;
                } else {
                  _connectionStatusIcon = new Image.asset(
                      "assets/icons/valid.png",
                      width: 30,
                      height: 30,
                      fit: BoxFit.fitWidth);
                  return _connectionStatusIcon;
                }
              },
            ),
          ),
          new Container(
            padding: EdgeInsets.only(right: 5),
            child: ValueListenableBuilder(
                valueListenable: globals.isConnectedToBackEnd,
                builder: (BuildContext context, bool isConnectedToBackEnd,
                    Widget child) {
                  if (isConnectedToBackEnd == false) {
                    _connectionStatus = "Not connected to Back-End";
                    return Text(_connectionStatus);
                  } else {
                    final ipAddr = globals.apiIpAddr;
                    final port = globals.apiPort;
                    _connectionStatus = "Connected to $ipAddr:$port";
                    return Text(_connectionStatus);
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 15),
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Email'),
            ),
          ),
          new Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Password'),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    if (_form == FormType.login) {
      return new Container(
        width: 180.0,
        padding: EdgeInsets.only(top: 20),
        child: new Column(
          children: <Widget>[
            new ElevatedButton(
              child: new Text('Login'),
              onPressed: _loginPressed,
            ),
            new ElevatedButton(
              child: new Text('Register'),
              onPressed: _formChange,
            ),
            new TextButton(
              child: new Text('I forgot my password'),
              onPressed: _forgotPasswordPressed,
            ),
            new TextButton(
              child: new Text('Back-End Setup'),
              onPressed: _backEndSetupPressed,
            ),
          ],
        ),
      );
    } else {
      return new Container(
        padding: EdgeInsets.all(20),
        child: new Column(
          children: <Widget>[
            new ElevatedButton(
              child: new Text('Create an Account'),
              onPressed: _registerPressed,
            ),
            new TextButton(
              child: new Text('Already registered ? Click here to login.'),
              onPressed: _formChange,
            )
          ],
        ),
      );
    }
  }

  Future<void> _displayForgotPasswordInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Email sent'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    'An email containing a token to reset your password has been sent to $_email'),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _token = value;
                    });
                  },
                  controller: _tokenFieldController,
                  decoration: InputDecoration(hintText: 'Enter your token'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Cancel')),
              TextButton(
                child: Text('Ok'),
                onPressed: _tokenValidationButtonPressed,
              )
            ],
          );
        });
  }

  void _tokenValidationButtonPressed() {
    setState(() {
      Navigator.pop(context);
    });
    if (_token != "") {
      Navigator.pushReplacementNamed(context, '/ChangePassword',
          arguments: ChangePasswordScreenArgument(_token));
    }
  }

  void _backEndSetupPressed() {
    Navigator.pushReplacementNamed(context, '/BackEndSetup');
  }

  void _forgotPasswordPressed() async {
    if (globals.apiIpAddr == "" ||
        globals.apiPort == "" ||
        globals.isConnectedToBackEnd.value == false) {
      Navigator.pushReplacementNamed(context, "/BackEndSetup");
      return;
    }
    if (_email == "") {
      _showErrorMsg('Please enter your email address');
      return;
    }
    HttpRequests httpRequests =
        new HttpRequests(globals.apiIpAddr, globals.apiPort);
    try {
      var result = await httpRequests.forgotPassword(_email);
      if (result != null) {
        await _displayForgotPasswordInputDialog(context);
      } else {
        _showErrorMsg('Unknown email');
      }
    } on Exception catch (err) {
      print(err);
      _displayExceptionWithSnackBar(err.toString());
    }
  }

  void _loginPressed() async {
    if (globals.appMode == "DEBUG" &&
        globals.isConnectedToBackEnd.value == false) {
      Navigator.pushReplacementNamed(context, "/BackEndSetup");
      return;
    }
    try {
      var result = await _api.signIn(_email, _password);
      if (result != null) {
        globals.user = UserResponse(
          id: result.id,
          email: result.email,
          username: result.username,
          createdAt: result.createdAt,
          role: result.role,
        );
        print(globals.user);
        if (globals.appMode == "DEBUG") {
          print(globals.user);
        }
        Navigator.pushReplacementNamed(context, "/NotificationsScreen");
      }
    } on Exception catch (err) {
      if (globals.appMode == "DEBUG") {
        print(err);
      }
      _displayExceptionWithSnackBar(err.toString());
    }
  }

  void _registerPressed() async {
    if (globals.appMode == "DEBUG" &&
        globals.isConnectedToBackEnd.value == false) {
      Navigator.pushReplacementNamed(context, '/BackEndSetup');
      return;
    }
    try {
      var result = await _api.signUp(_email, "", _password);
      if (result != null) {
        setState(() {
          _form = FormType.login;
        });
        globals.user = UserResponse(
          id: result.id,
          email: result.email,
          username: result.username,
          createdAt: result.createdAt,
          role: result.role,
        );
        if (globals.appMode == "DEBUG") {
          print(globals.user);
        }
      }
    } on Exception catch (err) {
      if (globals.appMode == "DEBUG") {
        print(err);
      }
      _displayExceptionWithSnackBar(err.toString());
    }
  }
}
