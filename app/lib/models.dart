import 'package:flutter/material.dart';

class UserResponse {
  final String id;
  final String email;
  final String username;
  final String role;
  final String createdAt;

  UserResponse({this.id, this.email, this.username, this.role, this.createdAt});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
        id: json['id'],
        email: json['email'],
        username: json['username'] != null ? json['username'] : "",
        role: json['role'],
        createdAt: json['createdAt']);
  }
}

class NotificationObject {
  String text;
  Color color;

  NotificationObject(String text, Color color) {
    this.text = text;
    this.color = color;
  }
}
