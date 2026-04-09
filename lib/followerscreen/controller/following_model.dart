import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infosha/config/const.dart';
import 'package:infosha/config/api_endpoints.dart';
import 'package:country_state_city/country_state_city.dart';
import 'package:infosha/followerscreen/model/top_visitors_model.dart';
import 'package:infosha/followerscreen/model/top_followers_model.dart';
import 'package:infosha/followerscreen/model/following_list_model.dart';

class FollowingModel extends ChangeNotifier {
  bool isLoading = false;
  FollowingListModel followingListModel = FollowingListModel();
  FollowingListModel mutualFollowingListModel = FollowingListModel();

  Future fetFollowing(String id) async {
    try {
      isLoading = true;
      notifyListeners();
      var headers = {
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('GET', Uri.parse("${ApiEndPoints.followingList}?user_id=$id&page=1"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print(request.url);
      print("FollowingList ==>4 $decodeData");

      if (response.statusCode == 200) {
        followingListModel = FollowingListModel.fromJson(decodeData);
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future fetchMoreFollowing(String id, int page) async {
    try {
      var headers = {
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('GET', Uri.parse("${ApiEndPoints.followingList}?user_id=$id&page=$page"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("FollowingList ==>5 $decodeData");

      if (response.statusCode == 200) {
        var temp = FollowingListModel.fromJson(decodeData);
        followingListModel.data!.data!.addAll(temp.data!.data!);
      } else {}
    } catch (e) {
      rethrow;
    }
  }

  Future fetchMutualMoreFollowing(String id, int page) async {
    try {
      var headers = {
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('POST', Uri.parse("${ApiEndPoints.mutualFollowings}?user_id=$id&page=$page"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("===page====${page}");
      print("===request====${request.url}");
      print("FollowingList 123 ==> $decodeData");

      if (response.statusCode == 200) {
        var temp = FollowingListModel.fromJson(decodeData);
        mutualFollowingListModel.data!.data!.addAll(temp.data!.data!);
      } else {}
    } catch (e) {
      rethrow;
    }
  }

  Future fetchMutualFollowing(String id) async {
    try {
      isLoading = true;
      notifyListeners();
      var headers = {
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('POST', Uri.parse("${ApiEndPoints.mutualFollowings}?user_id=$id&page=1"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      print("==result.body==${result.body}");
      final decodeData = jsonDecode(result.body);
      print("===page====1");
      print("===request====${request.url}");
      print("FollowingList ==>6 $decodeData");

      if (response.statusCode == 200) {
        mutualFollowingListModel = FollowingListModel.fromJson(decodeData);
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
