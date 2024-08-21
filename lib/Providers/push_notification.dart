// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';

class PushNotificationFunction {
  // for sending push notification
  static Future<void> sendPushNotification(
      String title, String msg, String token) async {
    try {
      final body = {
        "to": token,
        "notification": {
          "title": title, //our name should be send
          "body": msg,
          //  "android_channel_id": "chats"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'AAAA1bDtpf8:APA91bGiJxl8SKRxl4svBLf2THKJvgZ_BckGBVVr2lav22jTegN71vAhkvbJchcR39JIlG8quQVramrrlESnFubyU-16bhWiTA4HotiVe17Pc_dyDtgwda8nAyH79wF1-SCGmR5uHHQQ'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');

      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  // for sending push notification
  static Future<void> sendCallPushNotification(
      String title,
      String msg,
      String token,
      String uid,
      String name,
      String avatar,
      String email,
      String phone,
      String roomID,
      String callType) async {
    try {
      final body = {
        "to": token,
        "notification": {
          "title": title, //our name should be send
          "body": msg,
          //  "android_channel_id": "chats"
        },
        "data": {
          'uid': uid,
          'name': name,
          'email': email,
          'avatar': avatar,
          'phone': phone,
          'roomID': roomID,
          'callType': callType
        },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'Key=AAAAi0fN8VM:APA91bGd7K8HhlDGJ4Qzey41OA6eqf0Ngt3q5-z1Hy9VPJKaAu0YVFlbXHnOXrNqK1FLnmsYtt5W-MAjQEc5IzIKojXUiIXwp7NWam8F2toRj93_pMGoaKyFs1RKIH7JQ-a9ToMmWVaL'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');

      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }
}
