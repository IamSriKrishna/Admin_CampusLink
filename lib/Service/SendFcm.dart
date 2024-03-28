// ignore_for_file: empty_catches, prefer_const_constructors

import 'dart:convert';
import 'package:admin/uri.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class FCMNotification{
  sendNotification(String registrationToken, String body) async {
  final String uri = "$url/send-notification"; 
  final Map<String, dynamic> requestBody = {
    'registrationToken': registrationToken,
    'body': body,
  };

  final headers = {
    'Content-Type': 'application/json',
  };

  try {
    final response = await http.post(
      Uri.parse(uri),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully");
    } else {
      print("Failed to send notification: ${response.statusCode}");
    }
  } catch (e) {
    print("Error sending notification: $e");
  }
}
  void sendNotifications({
    required BuildContext context,
    required List<String> toAllFaculty,
    required String body,
  }) async {
    final Map<String, dynamic> requestData = {
      "registrationTokens": toAllFaculty,
      "body": body, 
    };

    final response = await http.post(
      Uri.parse('$url/send-notification-toAll'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      print('Successfully sent');
    } else {
      print('Failed to sent');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send notifications"),
        ),
      );
    }
  }
}