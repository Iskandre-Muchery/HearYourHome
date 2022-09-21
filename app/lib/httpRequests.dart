import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/models.dart';


class HttpRequests {
  String _ip = "";
  String _port = "";

  HttpRequests(ipAddr, port) {
    this._ip = ipAddr;
    this._port = port;
  }

  void setConnectionSettings(String ipAddr, String port) {
    this._ip = ipAddr;
    this._port = port;
  }

  bool verifyEmail(String email) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return false;
    }
    return true;
  }

  Future<UserResponse> changePassword(String token, String password) async {
    if (this._ip == "" || this._port == "")
      throw Exception('Server IP or Port is empty');
    if (password.isEmpty || password.length < 8)
      throw Exception('Minimum password length: 8');
    if (password.length > 64) throw Exception('Maximum password length: 64');

    var url =
        Uri.http(this._ip + ":" + this._port, '/sessions/recoverpassword');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return UserResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<UserResponse> forgotPassword(String email) async {
    if (this._ip == "" || this._port == "")
      throw Exception('Server IP or Port is empty');
    if (!verifyEmail(email)) throw Exception('Invalid email');

    var url = Uri.http(this._ip + ":" + this._port, '/sessions/forgotpassword');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      return UserResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<UserResponse> signIn(String email, String password) async {
    
    if (this._ip == "" || this._port == "")
      throw Exception('Server IP or Port is empty');
    if (!verifyEmail(email)) throw Exception('Invalid email');
    if (password.isEmpty || password.length < 8)
      throw Exception('Minimum password length: 8');
    if (password.length > 64) throw Exception('Maximum password length: 64');

    var url = Uri.http(this._ip + ":" + this._port, '/users/signin');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return UserResponse.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode == 401) {
      throw Exception('Invalid email or password');
    }
    return null;
  }

  Future<UserResponse> signUp(
      String email, String username, String password) async {

    if (this._ip == "" || this._port == "")
      throw Exception('Server IP or Port is empty');
    if (!verifyEmail(email)) throw Exception('Invalid email');
    if (password.isEmpty || password.length < 8)
      throw Exception('Minimum password length: 8');

    var url = Uri.http(this._ip + ":" + this._port, '/users/signup');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return UserResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 409) {
      throw Exception('Email already registered');
    }
    return null;
  }

  Future<bool> ping() async {
    if (this._ip == "" || this._port == "") {
      return false;
    }
    var url = Uri.http(this._ip + ":" + this._port, '/ping');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (_) {
      return false;
    }
  }
}
