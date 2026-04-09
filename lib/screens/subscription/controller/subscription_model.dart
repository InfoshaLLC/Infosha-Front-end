import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infosha/config/api_endpoints.dart';
import 'package:infosha/config/const.dart';
import 'package:infosha/screens/subscription/component/subscription_payment.dart';

import 'package:infosha/screens/subscription/model/subscription_list_model.dart';
import 'package:infosha/views/ui_helpers.dart';

class SubscriptionModel extends ChangeNotifier {
  bool isLoading = false;
  bool isSubmit = false;
  SubscriptionListModel subscriptionListModel = SubscriptionListModel();
  List<Data> planList = [];
  late Data selectedPlan;

  SubscriptionModel() {
    getSubscriptionData();
  }

  Future getSubscriptionData() async {
    try {
      isLoading = true;
      notifyListeners();
      var headers = {
        // 'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse(ApiEndPoints.getPlan));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      if (response.statusCode == 200) {
        subscriptionListModel = SubscriptionListModel.fromJson(decodeData);
        print("getSubscriptionData ==> $subscriptionListModel");

        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future submitPlan() async {
    print("plan ==> ${selectedPlan.id}");
    try {
      isSubmit = true;
      notifyListeners();
      var headers = {
        // 'Authorization': 'Bearer 152|wekxmQDpBO3L08DxuzQnF1vbhoLBqMsVX9yCeTRT',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.submitPlan));
      request.body = json.encode({'plan_id': selectedPlan.id});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("decodeData ==> $decodeData");

      if (response.statusCode == 200) {
        if (decodeData["message"].toString().contains(
            "Thank you for being a valued member of our community! We've noticed that you already have an active subscription.")) {
          UIHelper.showMySnak(
              title: "Subscription",
              message: decodeData["message"],
              isError: false);
        } else {
          Get.to(() => SubscriptionPayment(
                paymentLink: decodeData["data"],
                isNewUser: true,
              ));
        }
        isSubmit = false;
        notifyListeners();
      } else {
        isSubmit = false;
        notifyListeners();
      }
    } catch (e) {
      isSubmit = false;
      notifyListeners();
    }
  }
}
