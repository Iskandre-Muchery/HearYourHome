import 'package:app/globals.dart' as globals;
import 'package:app/httpRequests.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackEndSetupScreen extends StatefulWidget {
  @override
  _BackEndSetupScreenState createState() => _BackEndSetupScreenState();
}

class _BackEndSetupScreenState extends State<BackEndSetupScreen> {
  final _ipFilter = new TextEditingController();
  final _portFilter = new TextEditingController();
  Image _connectionStatusIcon = Image.asset("assets/icons/unvalid.png",
      width: 30, height: 30, fit: BoxFit.fitWidth);
  String _ip = "";
  String _port = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: new Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: new ListView(
            children: <Widget>[
              _buildConnectionStatus(),
              _buildTextFields(),
              _buildButtons(),
            ],
          )),
    );
  }

  _BackEndSetupScreenState() {
    _ipFilter.addListener(_ipListen);
    _portFilter.addListener(_portListen);
  }

  void _ipListen() {
    if (_ipFilter.text.isEmpty) {
      _ip = "";
    } else {
      _ip = _ipFilter.text;
    }
  }

  void _portListen() {
    if (_portFilter.text.isEmpty) {
      _port = "";
    } else {
      _port = _portFilter.text;
    }
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Area"),
      centerTitle: true,
    );
  }

  Widget _buildConnectionStatus() {
    return new Container(
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
                    return Text("Not connected to Back-End");
                  } else {
                    final ipAddr = globals.apiIpAddr;
                    final port = globals.apiPort;
                    return Text('Connected to $ipAddr:$port');
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
            child: new TextField(
              controller: _ipFilter,
              decoration: new InputDecoration(labelText: 'Ip Address'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _portFilter,
              decoration: new InputDecoration(labelText: 'Port'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return new Container(
      padding: EdgeInsets.only(top: 20),
      child: new Column(
        children: <Widget>[
          new ElevatedButton(
            child: new Text('Connect'),
            onPressed: _connectPressed,
          ),
          new ElevatedButton(
            child: new Text('Go back to Login'),
            onPressed: _goBackPressed,
          )
        ],
      ),
    );
  }

  void _connectPressed() async {
    if (_ip.isEmpty || _port.isEmpty) return;
    HttpRequests httpRequests = new HttpRequests(this._ip, this._port);
    if (await httpRequests.ping()) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('ip', _ip);
      prefs.setString('port', _port);
      globals.apiIpAddr = _ip;
      globals.apiPort = _port;
      globals.isConnectedToBackEnd.value = true;
      Navigator.pushReplacementNamed(context, "/");
    } else {
      globals.isConnectedToBackEnd.value = false;
    }
  }

  void _goBackPressed() {
    Navigator.pushReplacementNamed(context, '/');
  }
}
