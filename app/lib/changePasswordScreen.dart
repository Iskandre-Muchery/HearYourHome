import 'package:app/httpRequests.dart';
import 'package:flutter/material.dart';
import 'package:app/globals.dart' as globals;

class ChangePasswordScreenArgument {
  final String token;

  ChangePasswordScreenArgument(this.token);
}

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _firstPasswordFieldController =
      new TextEditingController();
  final TextEditingController _secondPasswordFieldController =
      new TextEditingController();
  String _firstTextPassword = "";
  String _secondTextPassword = "";
  String _token = "";

  _ChangePasswordScreenState() {
    _firstPasswordFieldController.addListener(_firstTextPasswordListen);
    _secondPasswordFieldController.addListener(_secondTextPasswordListen);
  }

  void _firstTextPasswordListen() {
    if (_firstPasswordFieldController.text.isEmpty) {
      _firstTextPassword = "";
    } else {
      _firstTextPassword = _firstPasswordFieldController.text;
    }
  }

  void _secondTextPasswordListen() {
    if (_secondPasswordFieldController.text.isEmpty) {
      _secondTextPassword = "";
    } else {
      _secondTextPassword = _secondPasswordFieldController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments
        as ChangePasswordScreenArgument;
    if (args.token != "") {
      _token = args.token;
    }

    return Scaffold(
      appBar: _buildBar(context),
      body: new Container(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: new Column(
            children: <Widget>[
              _buildTitle(),
              _buildTextFields(),
              _buildConfirmationButton(),
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

  Widget _buildTitle() {
    return new Container(
        padding: EdgeInsets.only(top: 20),
        child: new Text('Change your password',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));
  }

  Widget _buildConfirmationButton() {
    return new Container(
        padding: EdgeInsets.only(top: 20),
        child: new ElevatedButton(
            onPressed: _confirmationButtonPressed, child: Text('Ok')));
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 15),
            child: new TextField(
              controller: _firstPasswordFieldController,
              decoration: new InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Type your new password'),
              obscureText: true,
            ),
          ),
          new Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: new TextField(
              controller: _secondPasswordFieldController,
              decoration: new InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Type your new password again'),
              obscureText: true,
            ),
          )
        ],
      ),
    );
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

  void _confirmationButtonPressed() async {
    if (_firstTextPassword == "" || _secondTextPassword == "") {
      _showErrorMsg('Please fill all password text fields');
      return;
    }
    if (_firstTextPassword != _secondTextPassword) {
      _showErrorMsg('Passwords are not the same');
      return;
    }
    if (_firstTextPassword.length < 8 || _firstTextPassword.length > 64) {
      _showErrorMsg('Password must be sized between 8 and 64 characters');
    }
    if (globals.apiIpAddr == "" ||
        globals.apiPort == "" ||
        globals.isConnectedToBackEnd.value == false) {
      Navigator.pushReplacementNamed(context, "/BackEndSetup");
      return;
    }
    HttpRequests httpRequests =
        new HttpRequests(globals.apiIpAddr, globals.apiPort);
    try {
      var result =
          await httpRequests.changePassword(_token, _firstTextPassword);
      if (result != null) {
        Navigator.pushReplacementNamed(context, "/");
      }
    } on Exception catch (err) {
      print(err);
      _displayExceptionWithSnackBar(err.toString());
    }
  }
}
