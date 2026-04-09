import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:infosha/config/const.dart';
import 'package:infosha/config/api_endpoints.dart';
import 'package:infosha/Controller/models/profile_rating_model.dart';

class Utils {
  static Future<ProfileRatingModel> getUserRating(String id) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('GET', Uri.parse("${ApiEndPoints.profileRatingV2}?user_id=$id"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("getRating ==> $decodeData");

      if (response.statusCode == 200) {
        var profileRatingModel = ProfileRatingModel.fromJson(decodeData);
        return profileRatingModel;
      } else {
        return ProfileRatingModel();
      }
    } catch (e) {
      rethrow;
    }
  }

  static updateRating(String id) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('POST', Uri.parse("${ApiEndPoints.updateRating}?id=$id"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("updateRating ==> $decodeData");
    } catch (e) {
      rethrow;
    }
  }
}

class CallHandler {
  static const MethodChannel _channel = MethodChannel('com.example.callEvents');

  // Start listening to call events
  static Future<void> listenToCallEvents() async {
    try {
      await _channel.invokeMethod('listenToCallEvents');
    } on PlatformException catch (e) {
      print("Error listening to call events: ${e.message}");
    }
  }

  // Stop listening to call events
  static Future<void> stopListeningToCallEvents() async {
    try {
      await _channel.invokeMethod('stopListeningToCallEvents');
    } on PlatformException catch (e) {
      print("Error stopping call events: ${e.message}");
    }
  }

  // Open dial pad
  static Future<void> openDialPad(String phoneNumber) async {
    try {
      await _channel.invokeMethod('openDialPad', {"phoneNumber": phoneNumber});
    } on PlatformException catch (e) {
      print("Error opening dial pad: ${e.message}");
    }
  }
}
