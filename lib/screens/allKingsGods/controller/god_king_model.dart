import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infosha/config/const.dart';
import 'package:infosha/config/api_endpoints.dart';
import 'package:country_state_city/country_state_city.dart';
import 'package:infosha/screens/allKingsGods/model/king_god_list_model.dart';


class AllKingGodModel extends ChangeNotifier {
  bool isKingLoading = false;
  bool isGodLoading = false;
  bool worldWide = false;
  List<Country> countryList = [];
  Country selectedCountry = Country(
    name: "Country",
    isoCode: "isoCode",
    phoneCode: "phoneCode",
    flag: "flag",
    currency: "currency",
    latitude: "latitude",
    longitude: "longitude",
  );

  KingGodListModel kingListModel = KingGodListModel();
  KingGodListModel godListModel = KingGodListModel();

  AllKingGodModel() {
    fetchCountry();
  }

  fetchCountry() async {
    countryList = await getAllCountries();
    if (countryList.isNotEmpty) {
      countryList.insert(
          0,
          Country(
              name: "Country",
              isoCode: "isoCode",
              phoneCode: "phoneCode",
              flag: "flag",
              currency: "currency",
              latitude: "latitude",
              longitude: "longitude"));
      selectedCountry = countryList.first;
    }
  }

  Future getKingList() async {
    try {
      isKingLoading = true;
      notifyListeners();
      var headers = {'Accept': 'application/json', 'Authorization': 'Bearer ${Params.UserToken}', 'Content-Type': 'application/json'};
      var request = http.Request(
          'GET',
          Uri.parse(
              "${ApiEndPoints.userSubscriptionList}?page=1&plan_type=king&country=${selectedCountry.name == "Country" ? "" : selectedCountry.name}"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("getKingList ==> $decodeData");

      if (response.statusCode == 200) {
        kingListModel = KingGodListModel.fromJson(decodeData);

        kingListModel.data!.data?.removeWhere((element) => element.user?.isSubscriptionActive != null && element.user?.isSubscriptionActive == false);
        isKingLoading = false;
        notifyListeners();
      } else {
        isKingLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isKingLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future getGodList() async {
    try {
      isGodLoading = true;
      notifyListeners();
      var headers = {'Accept': 'application/json', 'Authorization': 'Bearer ${Params.UserToken}', 'Content-Type': 'application/json'};
      var request = http.Request(
          'GET',
          Uri.parse(
              "${ApiEndPoints.userSubscriptionList}?page=1&plan_type=god&country=${selectedCountry.name == "Country" ? "" : selectedCountry.name}"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print(request.url);
      print("getGodList ==> $decodeData");

      if (response.statusCode == 200) {
        godListModel = KingGodListModel.fromJson(decodeData);

        godListModel.data!.data?.removeWhere((element) => element.user?.isSubscriptionActive != null && element.user?.isSubscriptionActive == false);
        isGodLoading = false;
        notifyListeners();
      } else {
        isGodLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isGodLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future getMoreKingList(int page) async {
    try {
      var headers = {'Accept': 'application/json', 'Authorization': 'Bearer ${Params.UserToken}', 'Content-Type': 'application/json'};
      var request = http.Request(
          'GET',
          Uri.parse(
              "${ApiEndPoints.userSubscriptionList}?page=$page&plan_type=king&country=${selectedCountry.name == "Country" ? "" : selectedCountry.name}"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("getKingList ==> $decodeData");

      if (response.statusCode == 200) {
        var temp = KingGodListModel.fromJson(decodeData);
        if (temp.data != null && temp.data!.data!.isNotEmpty) {
          kingListModel.data!.data!.addAll(temp.data!.data!);
          kingListModel.data!.data
              ?.removeWhere((element) => element.user?.isSubscriptionActive != null && element.user?.isSubscriptionActive == false);
        }
      } else {}
    } catch (e) {
      rethrow;
    }
  }

  Future getMoreGodList(int page) async {
    try {
      var headers = {'Accept': 'application/json', 'Authorization': 'Bearer ${Params.UserToken}', 'Content-Type': 'application/json'};
      var request = http.Request(
          'GET',
          Uri.parse(
              "${ApiEndPoints.userSubscriptionList}?page=$page&plan_type=god&country=${selectedCountry.name == "Country" ? "" : selectedCountry.name}"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("getGodList ==> $decodeData");

      if (response.statusCode == 200) {
        var temp = KingGodListModel.fromJson(decodeData);
        if (temp.data != null && temp.data!.data!.isNotEmpty) {
          godListModel.data!.data!.addAll(temp.data!.data!);

          godListModel.data!.data
              ?.removeWhere((element) => element.user?.isSubscriptionActive != null && element.user?.isSubscriptionActive == false);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
