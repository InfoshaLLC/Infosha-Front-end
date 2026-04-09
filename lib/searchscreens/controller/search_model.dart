import 'dart:convert';
import 'dart:developer';
import 'package:country_state_city/country_state_city.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:infosha/Controller/models/profession_model.dart';
import 'package:infosha/config/api_endpoints.dart';
import 'package:infosha/config/const.dart';
import 'package:infosha/country_list.dart';
import 'package:infosha/searchscreens/model/city_list_model.dart';
import 'package:infosha/searchscreens/model/country_list_model.dart';
import 'package:infosha/searchscreens/model/search_user_model.dart';
import 'package:intl/intl.dart';

class SearchModel extends ChangeNotifier {
  bool isLoading = false;
  CountryListModel countryListModel = CountryListModel();
  List<Country> countryList = [];
  Country selectedCountry = Country(
      name: "Country",
      isoCode: "isoCode",
      phoneCode: "phoneCode",
      flag: "flag",
      currency: "currency",
      latitude: "latitude",
      longitude: "longitude");
  CityListModel cityListModel = CityListModel();
  List<City> cityList = [City(name: "City", countryCode: "", stateCode: "")];
  City selectedCity = City(name: "City", countryCode: "", stateCode: "");
  List<String> professionList = [];
  String selectedProfession = "Profession";
  List<ProfessionModel> listDummyProfesstions = [];
  SearchUserModel searchUserModel = SearchUserModel();
  TextEditingController searchController = TextEditingController();

  List<DateTime?> dialogCalendarPickerValue = [
    // DateTime.now().subtract(const Duration(days: 1)),
    // DateTime.now(),
  ];

  bool rankingg = false;
  bool numberofranking = false;
  bool numberoffollowing = false;
  bool numberoffollowers = false;
  bool moreData = false;

  SearchModel() {
    fetchCountry();
    getProfession();
  }

  fetchCountry() async {
    countryList = await getAllCountries();
    countryList.sort((a, b) => a.name.compareTo(b.name));
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

  fetchCity() async {
    cityList.clear();
    cityList = await getCountryCities(selectedCountry.isoCode);
    if (cityList.isNotEmpty) {
      cityList.insert(0, City(name: "City", countryCode: "", stateCode: ""));
      selectedCity = cityList.first;
    }
    print("citry ===> ${cityList}");
  }

  createURL() {
    getUser();
  }

  Future getProfession() async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse(ApiEndPoints.professionList));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      if (response.statusCode == 200) {
        listDummyProfesstions = (decodeData as List)
            .map((data) => ProfessionModel.fromJson(data))
            .toList();
        professionList =
            listDummyProfesstions.map((e) => e.profession!).toList();
        professionList.sort((a, b) => a.compareTo(b));
        professionList.insert(0, "Profession");

        print("professionList ==> $professionList");
        notifyListeners();
      } else {
        notifyListeners();
      }
    } catch (e) {
      notifyListeners();
    }
  }

  /* bool isAlphanumeric(String text) {
    final RegExp alphanumericWithSpace = RegExp(r'^[a-zA-Z0-9\s]+$');
    final RegExp hasAlphabetic = RegExp(r'[a-zA-Z]');
    return alphanumericWithSpace.hasMatch(text) && hasAlphabetic.hasMatch(text);
  } */

  bool isAlphanumeric(String text) {
    final RegExp alphanumericWithSpace =
        RegExp(r'^[\p{L}0-9\s]+$', unicode: true);
    final RegExp hasAlphabetic = RegExp(r'\p{L}', unicode: true);
    return alphanumericWithSpace.hasMatch(text) && hasAlphabetic.hasMatch(text);
  }

  Future getUser() async {
    try {
      moreData = false;
      isLoading = true;
      notifyListeners();
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request =
          http.Request('GET', Uri.parse("${ApiEndPoints.searchUserV2}?page=1"));

      request.headers.addAll(headers);
      request.body = json.encode({
        "search": searchController.text.isEmpty
            ? ""
            : isAlphanumeric(searchController.text.trim())
                ? searchController.text.trim()
                : removeCountryCode(searchController.text
                    .trim()
                    .toString()
                    .replaceAll(' ', '')
                    .replaceAll("-", "")
                    .replaceAll("(", "")
                    .replaceAll(")", "")),
        "number_of_ranking": numberofranking ? 1 : 0,
        "number_of_follower": numberoffollowers ? 1 : 0,
        "number_of_following": numberoffollowing ? 1 : 0,
        // "country":
        //     selectedCountry.name == "Country" ? "" : selectedCountry.name,
        "country":
        selectedCountry.name == "Country" ? "" : "+${selectedCountry.phoneCode}",
        "city": selectedCity.name == "City" ? "" : selectedCity.name,
        "start_date": dialogCalendarPickerValue.isNotEmpty
            ? DateFormat("dd-MM-yyyy").format(dialogCalendarPickerValue[0]!)
            : "",
        "end_date": dialogCalendarPickerValue.isNotEmpty
            ? DateFormat("dd-MM-yyyy").format(dialogCalendarPickerValue[1]!)
            : "",
        "profession":
            selectedProfession == "Profession" ? "" : selectedProfession
      });



      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      print("===request.body===${request.body}");
      print("===request.body===${request.url}");
      print("===result.body===${result.body}");

      if (response.statusCode == 200) {
        searchUserModel = SearchUserModel.fromJson(decodeData);

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

  String removeCountryCode(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll('+', '');
    List<String> countryCodes = Countries.allCountries
        .map((country) => country['dial_code']!.replaceAll('+', ''))
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    const int minLength = 10;

    if (phoneNumber.length > minLength) {
      for (String code in countryCodes) {
        if (phoneNumber.startsWith(code)) {
          String remainingNumber = phoneNumber.substring(code.length);
          return remainingNumber;
        }
      }
    }

    return phoneNumber;
  }

  Future getMoreUser(int page) async {
    try {
      moreData = false;
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'GET', Uri.parse("${ApiEndPoints.searchUserV2}?page=$page"));

      request.headers.addAll(headers);
      request.body = json.encode({
        "search": searchController.text.isEmpty
            ? ""
            : isAlphanumeric(searchController.text.trim())
                ? searchController.text.trim()
                : removeCountryCode(searchController.text
                    .trim()
                    .toString()
                    .replaceAll(' ', '')
                    .replaceAll("-", "")
                    .replaceAll("(", "")
                    .replaceAll(")", "")),
        "number_of_ranking": numberofranking ? 1 : 0,
        "number_of_follower": numberoffollowers ? 1 : 0,
        "number_of_following": numberoffollowing ? 1 : 0,
        // "country":
        //     selectedCountry.name == "Country" ? "" : selectedCountry.name,
        "country":
        selectedCountry.name == "Country" ? "" : "+${selectedCountry.phoneCode}",
        "city": selectedCity.name == "City" ? "" : selectedCity.name,
        "start_date": dialogCalendarPickerValue.isNotEmpty
            ? DateFormat("dd-MM-yyy").format(dialogCalendarPickerValue[0]!)
            : "",
        "end_date": dialogCalendarPickerValue.isNotEmpty
            ? DateFormat("dd-MM-yyy").format(dialogCalendarPickerValue[1]!)
            : "",
        "profession":
            selectedProfession == "Profession" ? "" : selectedProfession
      });

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("searchUserModel ==> ${decodeData}");

      if (response.statusCode == 200) {
        var temp = SearchUserModel.fromJson(decodeData);
        if (temp.data!.data != null && temp.data!.data!.isNotEmpty) {
          moreData = temp.data?.data != null && temp.data!.data!.isNotEmpty;
          searchUserModel.data!.data!.addAll(temp.data!.data!);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
