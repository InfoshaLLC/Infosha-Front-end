import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:infosha/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:infosha/config/const.dart';
import 'package:infosha/country_list.dart';
import 'package:geolocator/geolocator.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infosha/config/api_endpoints.dart';
import 'package:infosha/screens/home/home_screen.dart';
import 'package:infosha/services/pusher_services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:infosha/views/widgets/show_loader.dart';
import 'package:infosha/Controller/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:infosha/Controller/models/contact_model.dart';
import 'package:infosha/Controller/models/profession_model.dart';
import 'package:infosha/Controller/models/vote_status_mode.dart';
import 'package:infosha/screens/feed/controller/feed_model.dart';
import 'package:infosha/Controller/models/dummy_reviewmodel.dart';
import 'package:infosha/Controller/models/user_voting_model.dart';
import 'package:infosha/screens/authentication/login_screen.dart';
import 'package:infosha/Controller/models/visitor_list_model.dart';
import 'package:infosha/screens/home/SectonView/section_view.dart';
import 'package:infosha/Controller/models/incoming_call_model.dart';
import 'package:infosha/Controller/models/profile_rating_model.dart';
import 'package:infosha/Controller/models/comment_reaction_model.dart';
import 'package:infosha/Controller/models/user_full_model.dart' as full;
import 'package:intl_phone_number_input/intl_phone_number_input.dart' as intl;
import 'package:infosha/Controller/models/profession_by_other_user_model.dart';
import 'package:infosha/screens/viewUnregistered/model/review_vote_model.dart';
import 'package:infosha/screens/subscription/component/subscription_screen.dart';
import 'package:infosha/screens/viewUnregistered/model/unregistered_user_model.dart';
import 'package:infosha/screens/viewUnregistered/model/visitor_list_unregister.dart';

// ignore_for_file: use_build_context_synchronously

class UserViewModel extends ChangeNotifier {
  List<Contact> listContacts = [];
  Map<String, List<Contact>> groupedListContacts = {};
  List<ContactModel> listContactsModel = [];
  Map<String, List<ContactModel>> groupedListContactsModel = {};
  bool isArabic = false;
  String selectedLanguage = "English";
  RxBool isLoading = false.obs;
  RxBool isLoadingContact = false.obs;
  bool isOnbordingCompleted = false;
  String token = "null";
  String number = "null";
  List<DummyReviewModel> listReviews = [];
  List<DummyReviewModel> listmyReviews = [
    DummyReviewModel(
        isExpanded: false,
        nickname: "Tanzeem",
        rating: 4.5,
        comment: "This is amazing app for tracking..",
        imgPath: "",
        createdAt: DateTime.now().subtract(const Duration(minutes: 30))),
    DummyReviewModel(
        isExpanded: false,
        nickname: "Sana",
        rating: 5.0,
        comment: "Yes i really enjoyed it",
        imgPath: "",
        createdAt: DateTime.now().subtract(const Duration(minutes: 60)))
  ];

  List<ProfessionModel> listDummyProfesstions = [];
  String selectedName = "";

  bool isShowAddProfessionDialg = true;
  var addDropDownText = "Add Profession";
  var fcmToken = '';
  UserModel userModel = UserModel();
  FeedModel feedModel = FeedModel();
  String pusherChannelName = '';
  String socketId = '';
  final pusherService = PusherService();
  full.UserFullModel? otherUserModel;
  bool isAuthenticating = false;
  bool isRegister = false;
  bool isForgetPassword = false;
  bool isEditSocialMedia = false;
  bool isEditUnregisterUser = false;
  bool isAddComment = false;
  bool isReactionOfComment = false;
  bool isRatingLoading = false;
  bool isVisitorLoading = false;
  bool isIncomingCall = false;
  bool isVoteLoading = false;
  bool isOTPValidation = false;
  String hashCodeOTP = "";

  // List<SimCard>? simCards = [];
  ProfessionByOtherUserModel? professionByOtherUserModel;
  String byOtherUserName = 'By Other User', byOtherUserProfession = '-';
  CommentReactionModel commentReactionModel = CommentReactionModel();
  ProfileRatingModel profileRatingModel = ProfileRatingModel();
  String countryCode = "null";
  IncomingCallModel incomingCallModel = IncomingCallModel();
  CountryCode country = CountryCode(
    code: "GE",
    dialCode: "+995",
  );

  UserViewModel() {
    fetchFcmToken();
    // getSimInfo();
    // fetchDeviceContacts();
    getDeviceLocation();
    notifyListeners();
  }

  /* getSimInfo() async {
    print("simcard ==> 111");
    simCards = await MobileNumber.getSimCards;
    print("simcard ==> ${simCards!.map((e) => e.number)}");
  } */

  Future fetchFcmToken() async {
    FirebaseMessaging.instance.getToken().then((value) {
      debugPrint("fcmToken ==> $value");
      fcmToken = value ?? "";
    });
  }

  Future refresh() async {
    notifyListeners();
  }

  Future addReview(DummyReviewModel model) async {
    listReviews.add(model);
    notifyListeners();
  }

  Future deleteReview(model) async {
    listReviews.remove(model);
    notifyListeners();
  }

  Future setlistDummyProfesstions(data) async {
    listDummyProfesstions.add(data);
    notifyListeners();
  }

  Future setaddDropDownText(data) async {
    addDropDownText = data;
    notifyListeners();
  }

  Future<bool> hasDeviceContactsChanged() async {
    final prefs = await SharedPreferences.getInstance();

    String? savedData = prefs.getString("saved_contacts");
    List<dynamic> oldContacts = savedData != null ? jsonDecode(savedData) : [];

    List<Contact> freshContacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: false,
      deduplicateProperties: false,
    );

    freshContacts = freshContacts.where((c) => c.phones.isNotEmpty).toList();

    List<Map<String, dynamic>> newContacts = freshContacts.map((c) {
      return {
        "name": c.displayName,
        "number": c.phones.isNotEmpty ? c.phones.first.number : "",
      };
    }).toList();

    String oldJson = jsonEncode(oldContacts);
    String newJson = jsonEncode(newContacts);

    if (oldJson == newJson) {
      return false;
    } else {
      return true;
    }
  }

  /// Used to get all device contacts
  Future fetchDeviceContacts() async {
    PermissionStatus permissionStatus = await Permission.contacts.status;
    if (permissionStatus.isGranted || permissionStatus.isRestricted || permissionStatus.isLimited) {
      groupedListContacts = {};
      // if (await FlutterContacts.requestPermission()) {
      listContacts =
          await FlutterContacts.getContacts(withProperties: true, withPhoto: true, deduplicateProperties: false);
      listContacts = listContacts.where((element) => element.phones.isNotEmpty).toList();
      // }
      await Future.forEach(listContacts, (contact) async {
        String firstLetter = contact.displayName.isNotEmpty ? contact.displayName[0].toUpperCase() : "";
        if (isWellFormedUTF16(firstLetter)) {
          if (!groupedListContacts.containsKey(firstLetter)) {
            groupedListContacts[firstLetter] = [];
          }
          try {
            String country = await getCountryISOCodeFromPhoneNumber(contact.phones.isNotEmpty
                ? Platform.isAndroid
                    ? contact.phones.first.normalizedNumber.replaceAll(' ', '')
                    : contact.phones.first.number.replaceAll(' ', '')
                : "");

            if (contact.phones.isNotEmpty) {
              contact.phones.first.customLabel = country;
            }
          } catch (e) {
            rethrow;
          }

          groupedListContacts[firstLetter]?.add(contact);
        }
      });
      await saveContactsToPrefs(listContacts);
      if (Params.UserToken != "null" && Params.UserToken != "") {
        updateContact();
      }
    }

    notifyListeners();
  }

  Future<void> saveContactsToPrefs(List<Contact> contacts) async {
    final prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> jsonContacts = contacts.map((c) {
      return {
        "name": c.displayName,
        "number": c.phones.isNotEmpty ? c.phones.first.number : "",
      };
    }).toList();

    await prefs.setString("saved_contacts", jsonEncode(jsonContacts));
  }

  /// Used to get ISO code form mobile number
  Future<String> getCountryISOCodeFromPhoneNumber(String phoneNumber) async {
    try {
      intl.PhoneNumber number = await intl.PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);

      return number.isoCode ?? "";
    } catch (e) {
      return "";
    }
  }

  /// used to set language
  Future setLanguage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("language", selectedLanguage);

    notifyListeners();
  }

  /// used to ask run time permission of contact
  Future<void> askPermissionscontact(context) async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted) {
      _handleInvalidPermissions(context, permissionStatus);
    } else {
      fetchDeviceContacts();
    }
  }

  /// used to ask run time permission of location
  Future<void> askPermissionsLocation(context) async {
    PermissionStatus permissionStatus = await _getLocationPermission();
    if (permissionStatus != PermissionStatus.granted) {
      _handleInvalidPermissionsLocation(context, permissionStatus);
    } else {
      getDeviceLocation();
    }
  }

  /// used to get user's location
  getDeviceLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (await Geolocator.isLocationServiceEnabled() == true) {
        _getCountryCode(position.latitude, position.longitude);
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  /// used to get country code of user's local number, used when any number not having country code
  void _getCountryCode(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        String? code = placemarks[0].isoCountryCode;
        countryCode = code ?? "null";
        debugPrint('Country Code: $code');
      } else {
        debugPrint('No country found for the given coordinates.');
      }
    } catch (e) {
      debugPrint('Error getting country code: $e');
    }
  }

  /// used to ask run time permission of contact
  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  /// used to ask run time permission of location
  Future<PermissionStatus> _getLocationPermission() async {
    PermissionStatus permission = await Permission.location.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.location.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  /// used to ask run time permission of phone number for phone states
  Future<void> askPermissionsPhone(context) async {
    PermissionStatus permissionStatus = await _getPhonePermission();
    if (permissionStatus != PermissionStatus.granted) {
      _handleInvalidPermissionsPhone(context, permissionStatus);
    } else {
      // getSimInfo();
    }
  }

  /// used to ask run time permission of phone number for phone states
  Future<PermissionStatus> _getPhonePermission() async {
    PermissionStatus permission = await Permission.phone.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.phone.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  /// used to check if contacct permission is given or not
  void _handleInvalidPermissions(context, PermissionStatus permissionStatus) async {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Please allow contact permission to use Infosha'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // await openAppSettings();
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar = SnackBar(content: Text('Please allow contact permission to use Infosha'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // await openAppSettings();
    }
  }

  /// used to check if location permission is given or not
  void _handleInvalidPermissionsLocation(context, PermissionStatus permissionStatus) async {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to location is denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // await openAppSettings();
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar = SnackBar(content: Text('Please allow location permission'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // await openAppSettings();
    }
  }

  /// used to check if phone number permission is given or not
  void _handleInvalidPermissionsPhone(context, PermissionStatus permissionStatus) async {
    if (permissionStatus == PermissionStatus.denied) {
      // await openAppSettings();
      const snackBar = SnackBar(content: Text('Access to phone data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar = SnackBar(content: Text('Phone permission required'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // await openAppSettings();
    }
  }

  /// used to get icon path from id
  String convertReactionIdToPath(int id) {
    var path = APPICONS.reactionpng;
    switch (id) {
      case -1:
        path = path;
        break;
      case 0:
        path = APPICONS.lovepng;
        break;
      case 1:
        path = APPICONS.wowpng;
        break;
      case 2:
        path = APPICONS.lolpng;
        break;
      case 3:
        path = APPICONS.sadpng;
        break;
      case 4:
        path = APPICONS.angrypng;
        break;
      default:
    }
    return path;
  }

  /// used to create new user and return true or false status
  Future<bool> registerUser(payload) async {
    try {
      isAuthenticating = true;
      notifyListeners();

      var headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(ApiEndPoints.REGISTERUSER));
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("registerUser ==> $decodeData");

      if (response.statusCode == 200) {
        var prefs = await SharedPreferences.getInstance();
        prefs.setString("token", decodeData["data"]["token"]);
        Params.UserToken = decodeData["data"]["token"];
        userModel = await getUserProfileById(Params.UserToken);
        getProfessionByOtherUser(userModel.id.toString(), true);
        Get.offAll(() => SubscriptionScreen(isNewUser: true));
        authAndSaveData(json.encode(decodeData), isRegister: true);
        getProfession();
        await getSignatureAuth(decodeData["data"]["id"].toString());
        await pusherService.subscribeToChannel(decodeData["data"]["id"].toString());
        return true;
      } else {
        var message = decodeData['message'] ?? "";
        UIHelper.showMySnak(title: "Error", message: message, isError: true);
        isAuthenticating = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      UIHelper.showMySnak(title: "Error", message: e.toString(), isError: true);
      isAuthenticating = false;
      notifyListeners();
      return false;
    }
  }

  /// used to load dta from local storage when user is already logged In
  Future loadSharedPref() async {
    isLoading.value = true;
    notifyListeners();
    var prefs = await SharedPreferences.getInstance();
    var tempToken = prefs.getString("token") ?? "";
    token = tempToken;
    Params.UserToken = tempToken;
    var tempNumber = prefs.getString("number") ?? "";
    number = tempNumber;
    selectedLanguage = prefs.getString("language") ?? "English";

    if (selectedLanguage == "Arabic") {
      Get.updateLocale(const Locale('ar', 'SA'));
    } else if (selectedLanguage == "French") {
      Get.updateLocale(const Locale('fr'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }

    Params.Name = prefs.getString("Name") ?? "";
    Params.Image = prefs.getString("Image") ?? "null";
    Params.Number = prefs.getString("number") ?? "";
    Params.Id = prefs.getString("Id") ?? "";
    Params.loginTime = prefs.getString("loginTime") ?? "null";

    isOnbordingCompleted = prefs.getBool("onbording") ?? false;
    debugPrint("token ===> $token");

    if (token != "" && token != "null") {
      UserModel model = await getUserProfileById(token);

      userModel = UserModel(
        id: model.id!,
        username: model.username!,
        number: model.number!,
        type: model.type!,
        profile: Profile.fromJson(model.profile!.toJson()),
        token: token,
        followersCount: model.followersCount!,
        followingCount: model.followingCount!,
        likeCount: int.parse(model.likeCount!.toString()),
        dislikeCount: model.dislikeCount!,
        followers: model.followers,
        dislikeStatus: model.dislikeStatus,
        likeStatus: model.likeStatus,
        getNickName: model.getNickName,
        averageRating: model.averageRating,
        reviewList: model.reviewList,
        getProfiles: model.getProfiles,
        number_of_review_user: model.number_of_review_user,
        active_subscription_plan_name: model.active_subscription_plan_name,
        is_subscription_active: model.is_subscription_active,
        average_review: model.average_review,
        avg_review: model.avg_review,
        contact_id: model.contact_id,
        contactsCount: model.contactsCount,
        counryCode: model.counryCode,
        countContactNumber: model.countContactNumber,
        createdAt: model.createdAt,
        fcmToken: model.fcmToken,
        getAddress: model.getAddress,
        getAddressOther: model.getAddressOther,
        getDob: model.getDob,
        getEmail: model.getEmail,
        getGender: model.getGender,
        getSocial: model.getSocial,
        getSocialOther: model.getSocialOther,
        isActive: model.isActive,
        isContactChange: model.isContactChange,
        isLocked: model.isLocked,
        num_of_review_user: model.num_of_review_user,
        updatedAt: model.updatedAt,
      );

      fetchServerContacts();
      getProfessionByOtherUser(userModel.id.toString(), true);
      isLoading.value = false;
      await getSignatureAuth(userModel.id.toString());
      await pusherService.subscribeToChannel(userModel.id.toString().toString());
      notifyListeners();
    }
    isLoading.value = false;
    notifyListeners();
    getProfession();
  }

  changePhoto(String data) async {
    var pref = await SharedPreferences.getInstance();
    selectedName = data;
    pref.setString("selectedName", data);
    notifyListeners();
  }

  /// used to store required user details to local storage
  Future<void> authAndSaveData(String data, {String? showMessage, isRegister}) async {
    Map<String, dynamic> data1 = jsonDecode(data);
    if (data1.containsKey('success') && data1['success'] == true) {
      if (showMessage == null) {
        userModel = UserModel.fromJson(data1["data"]);

        var prefs = await SharedPreferences.getInstance();
        prefs.setString("docid", userModel.id.toString());
        // prefs.setString("token", userModel.token.toString());
        prefs.setString("number", userModel.number.toString());
        prefs.setString("Name", userModel.username.toString());
        prefs.setString("Id", userModel.id.toString());
        prefs.setString("Image", userModel.profile == null ? "null" : userModel.profile!.profileUrl!);

        Params.Name = prefs.getString("Name") ?? "";
        Params.Image = prefs.getString("Image") ?? "null";
        Params.Number = prefs.getString("number") ?? "";
        Params.Id = prefs.getString("Id") ?? "";
        // Params.UserToken = prefs.getString("token") ?? "null";
        prefs.setBool("islogin", true);
        // pref.saveObject("user", userModel);
        notifyListeners();

        try {
          if (isRegister != null) {
            var payload1 = {
              "data": listContacts.map((e) {
                return {
                  // "nickname": e.displayName,
                  "name": e.displayName ?? "", //
                  "number": removeCountryCode(e.phones.isNotEmpty
                      ? e.phones.first.number
                          .toString()
                          .replaceAll(' ', '')
                          .replaceAll("-", "")
                          .replaceAll("(", "")
                          .replaceAll(")", "")
                      : ""),
                  "code": e.phones.isNotEmpty && e.phones.first.customLabel != null
                      ? e.phones.first.customLabel
                      : getCountryCode(e.phones.first.number).isNotEmpty
                          ? getCountryCode(e.phones.first.number)
                          : (countryCode == "null" ? country.code ?? "+1" : countryCode),
                  "photo": e.photo != null ? base64.encode(e.photoOrThumbnail!) : "", //
                  // "profile": e.photo != null ? "data:${detectMimeType(e.photo!)};base64,${base64Encode(e.photo!)}" : "",
                  // "profile":
                  //     e.photoOrThumbnail != null ? "data:${detectMimeType(e.photoOrThumbnail!)};base64,${base64Encode(e.photoOrThumbnail!)}" : "",

                  "contact_id": e.id ?? "",
                  "email": e.emails.isNotEmpty ? e.emails.first.address ?? "" : "",
                  "profession": e.organizations.isNotEmpty
                      ? (e.organizations.first.title.isNotEmpty
                          ? e.organizations.first.title
                          : e.organizations.first.company ?? "")
                      : '',
                  "gender": "",
                  'address': e.addresses.isNotEmpty ? e.addresses.first : '',
                  'social': e.socialMedias.isNotEmpty ? e.socialMedias.first.userName ?? "" : "",
                  "dob": e.events.isNotEmpty
                      ? "${e.events.first.year ?? ""}-${e.events.first.month ?? ""}-${e.events.first.day ?? ""}"
                      : null,
                };
              }).toList()
            };

            await uploadContactToServer(payload1);
          } else {
            fetchServerContacts();
            Get.offAll(() => const HomeScreen());
            getProfession();
          }
        } catch (e) {
          rethrow;
        }

        // Get.offAll(() => const HomeScreen());
      } else {
        var token = userModel.token ?? Params.UserToken;
        UserModel mm = UserModel.fromJson(data1["data"]);

        mm.token = token;
        userModel.profile = mm.profile;
        notifyListeners();

        var prefs = await SharedPreferences.getInstance();
        prefs.setString("docid", userModel.id.toString());
        prefs.setString("token", userModel.token.toString());
        prefs.setString("number", userModel.number.toString());
        prefs.setString("Name", userModel.username.toString());
        prefs.setString("Id", userModel.id.toString());
        prefs.setString("Image", userModel.profile == null ? "null" : userModel.profile!.profileUrl ?? "null");
        Params.Name = prefs.getString("Name") ?? "";
        Params.Image = prefs.getString("Image") ?? "null";
        Params.Number = prefs.getString("number") ?? "";
        Params.Id = prefs.getString("Id") ?? "";
        prefs.setBool("islogin", true);
        // pref.saveObject("user", userModel);
        Get.back();
        if (showMessage.isNotEmpty) {
          UIHelper.showMySnak(title: "Update", message: showMessage, isError: false);
        }
      }
      isAuthenticating = false;
      notifyListeners();
    } else {
      fetchServerContacts();

      isAuthenticating = false;
      notifyListeners();
    }
  }

  /// used to login if user logged out
  Future loginUser(payload) async {
    try {
      isAuthenticating = true;
      notifyListeners();
      var headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(ApiEndPoints.LOGINUSER));

      request.body = json.encode(payload);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("login response ==>$decodeData");

      if (response.statusCode == 200) {
        var prefs = await SharedPreferences.getInstance();
        prefs.setString("docid", decodeData["data"]["id"].toString());
        prefs.setString("token", decodeData["data"]["token"]);
        prefs.setString("number", decodeData["data"]["number"]);
        prefs.setString("Name", decodeData["data"]["username"]);
        prefs.setString("Id", decodeData["data"]["id"].toString());
        prefs.setString("Image", decodeData["data"]["profile"]["profile_url"] ?? "null");
        prefs.setString("loginTime", DateTime.now().toString());

        Params.Name = decodeData["data"]["username"] ?? "";
        Params.Image = decodeData["data"]["profile"]["profile_url"] ?? "null";
        Params.Number = decodeData["data"]["number"] ?? "";
        Params.Id = decodeData["data"]["id"].toString();
        Params.UserToken = decodeData["data"]["token"];
        Params.loginTime = DateTime.now().toString();

        userModel = await getUserProfileById(Params.UserToken);
        getProfessionByOtherUser(userModel.id.toString(), true);

        fetchServerContacts();
        getProfessionByOtherUser(userModel.id.toString(), true);

        Get.offAll(() => const HomeScreen(
              fromLogin: true,
            ));

        isAuthenticating = false;
        notifyListeners();
        await getProfession();
        await fetchDeviceContacts();
        await getSignatureAuth(decodeData["data"]["id"].toString());
        await pusherService.subscribeToChannel(decodeData["data"]["id"].toString());
      } else {
        var message = decodeData['message'] ?? "";
        UIHelper.showMySnak(title: "Error", message: message, isError: true);
        isAuthenticating = false;
        notifyListeners();
      }
    } catch (e) {
      isAuthenticating = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> getSignatureAuth(String channelName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? socketId = prefs.getString('Pusher_Socket_ID');
      debugPrint('Socket ID fetched from Shared Pref: $socketId');
      var payload = {"channel_name": "private-client.$channelName", "socket_id": socketId};
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };

      debugPrint("Payload for Auth Signature ==> $payload");
      debugPrint("Headers for Auth Signature ==> $headers");
      var request = http.Request('POST', Uri.parse("${ApiEndPoints.PUSHERURL}broadcasting/auth"));
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("Response from Auth Signature ==> $decodeData");

      if (response.statusCode == 200) {
        // Save the auth signature here
        prefs.setString('Pusher_Auth_Signature', decodeData['auth'] ?? '');
      } else {}
    } catch (e, stackTrace) {
      debugPrint('Error in getSignatureAuth: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// used to check login credentials
  Future<bool> checkCredentials(payload) async {
    isAuthenticating = true;
    notifyListeners();
    var headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(ApiEndPoints.LOGINUSER));
    request.body = json.encode(payload);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    debugPrint("checkCredentials API ==> ${result.body}");
    final decodeData = jsonDecode(result.body);

    if (response.statusCode == 200) {
      isAuthenticating = false;
      notifyListeners();
      return true;
    } else {
      UIHelper.showMySnak(
          title: "Error",
          message: decodeData["message"]
                  .toString()
                  .contains("Your account has been deactivated. Please contact admin for support.")
              ? "Your account has been deactivated. Please contact admin for support".tr
              : "Invalid phone number or password".tr,
          isError: true);
      /* if (decodeData["message"].toString().contains(
          "Your account has been deactivated. Please contact admin for support.")) {
        Get.to(() => ActiveAccount());
      } */
      isAuthenticating = false;
      notifyListeners();
      return false;
    }
  }

  /// used to check if given number is already registered or not
  Future<bool> checkExistingUser(String number) async {
    isAuthenticating = true;
    notifyListeners();
    var headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(ApiEndPoints.checkNumberExist));
    request.body = json.encode({"number": number});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    final decodeData = jsonDecode(result.body);
    debugPrint("checkExistingUser ==> $decodeData");

    if (response.statusCode == 200) {
      isAuthenticating = false;
      notifyListeners();
      return true;
    } else {
      UIHelper.showMySnak(
          title: "Error",
          message: "This number is already registered. Please use a different phone number".tr,
          isError: true);
      isAuthenticating = false;
      notifyListeners();
      return false;
    }
  }

  /// used to change number need to edit number
  Future<bool> newNumber(String number) async {
    isAuthenticating = true;
    notifyListeners();
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Params.UserToken}',
    };
    var request = http.Request('POST', Uri.parse(ApiEndPoints.newNumber));
    request.body = json.encode({"number": number});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    final decodeData = jsonDecode(result.body);
    debugPrint("newNumber ==> $decodeData");

    if (response.statusCode == 200) {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("number", number);
      isAuthenticating = false;
      notifyListeners();
      return true;
    } else {
      Get.back();
      UIHelper.showMySnak(title: "Error", message: decodeData["message"], isError: true);
      isAuthenticating = false;
      notifyListeners();
      return false;
    }
  }

  ///used to edit my bio
  Future editBio(payload, {XFile? img}) async {
    isAuthenticating = true;
    notifyListeners();

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Params.UserToken}',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiEndPoints.BIOUPDATE));
    request.fields.addAll(payload);
    if (img != null) {
      print(img.path);
      request.files.add(await http.MultipartFile.fromPath('profile', img.path));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    final decodeData = jsonDecode(result.body);
    debugPrint("editBio ==> $decodeData");

    if (response.statusCode == 200) {
      /* userModel.profile!.gender = decodeData["data"]["gender"];
      userModel.profile!.dob = decodeData["data"]["dob"];
      userModel.profile!.country = decodeData["data"]["country"];
      userModel.profile!.state = decodeData["data"]["state"];
      userModel.profile!.city = decodeData["data"]["city"];
      userModel.profile!.address = decodeData["data"]["address"];
      userModel.profile!.profession = decodeData["data"]["profession"];
      userModel.username = decodeData["data"]["nickname"];
      userModel.profile!.profileUrl = decodeData["data"]["profile_url"]; */
      userModel.profile!.profileUrl = decodeData["data"]["profile_url"];
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("Image", decodeData["data"]["profile_url"] ?? "null");
      Get.back();

      UIHelper.showMySnak(title: "Update", message: "Your profile is updated".tr, isError: false);
      isAuthenticating = false;
      // if (decodeData["message"] == "Profile photo updated successfully..") {
      //   //   var prefs = await SharedPreferences.getInstance();
      //   //   prefs.setString("Image", decodeData["data"]["profile_url"] ?? "null");
      //   //   userModel.profile!.profileUrl = prefs.getString("Image");
      //   //   final genderReference = decodeData["data"]["gender"] == "male" ? "his" : "her";
      //   await feedModel.addPost("Profile photo updated successfully.", img);
      // } else if (decodeData["message"] == "Nickname updated successfully.") {
      //   await feedModel.addPost("Nickname updated successfully.", null);
      // }
      notifyListeners();
    } else {
      // var data = await response.stream.bytesToString();

      isAuthenticating = false;
      notifyListeners();
    }
  }

  ///used to edit my social media
  Future editSocialMedia(payload) async {
    isAuthenticating = true;
    notifyListeners();

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Params.UserToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(ApiEndPoints.SOCIALUPDATE));
    request.body = json.encode(payload);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    final decodeData = jsonDecode(result.body);
    debugPrint("decodeData ==> $decodeData");

    if (response.statusCode == 200) {
      userModel.profile!.email = decodeData["data"]["email"] ?? "";
      userModel.profile!.facebookId = decodeData["data"]["facebook_id"] ?? "";
      userModel.profile!.instagramId = decodeData["data"]["instagram_id"] ?? "";
    } else {
      isAuthenticating = false;
      notifyListeners();
    }
  }

  ///used to edit other user bio update
  Future editOtherSocialMedia(payload, {XFile? img}) async {
    print(payload);
    try {
      isEditSocialMedia = true;
      notifyListeners();

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.MultipartRequest('POST', Uri.parse(ApiEndPoints.SOCIALUPDATEOTHERUSER));
      request.fields.addAll(payload);
      if (img != null) {
        print("IMAGE-------------------------${img.path}");
        request.files.add(await http.MultipartFile.fromPath('profile', img.path));
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("editSocialMedia ==>22 $decodeData");

      if (response.statusCode == 200) {
        Get.back();
        UIHelper.showMySnak(title: "Updated", message: "Bio is updated", isError: false);

        isEditSocialMedia = false;
        notifyListeners();
      } else {
        isEditSocialMedia = false;
        notifyListeners();
      }
    } catch (e) {
      isEditSocialMedia = false;
      notifyListeners();
      rethrow;
    }
  }

  ///used to update other user's social media update
  Future editOtherUserSocialMedia(payload) async {
    try {
      isEditSocialMedia = true;
      notifyListeners();

      var headers = {'Authorization': 'Bearer ${Params.UserToken}', 'Content-Type': 'application/json'};

      var request = http.Request('POST', Uri.parse(ApiEndPoints.otherSocialUpdate));
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("editSocialMedia ==>1 $decodeData");

      if (response.statusCode == 200) {
        Get.back();
        UIHelper.showMySnak(title: "Updated", message: "Social Media info is updated", isError: false);
        isEditSocialMedia = false;
        notifyListeners();
      } else {
        isEditSocialMedia = false;
        notifyListeners();
      }
    } catch (e) {
      isEditSocialMedia = false;
      notifyListeners();
      rethrow;
    }
  }

  ///used to edit other user profession
  Future editOtherProfession(String userid, String professionId) async {
    try {
      isEditSocialMedia = true;
      notifyListeners();

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.professionUpdate));
      request.body = json.encode({"profession": professionId, "user_id": userid});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      debugPrint("editOtherProfession ==> $decodeData");

      if (response.statusCode == 200) {
        UIHelper.showMySnak(
            title: decodeData["message"].toString().contains("Profession is already updated by other user")
                ? "Fail"
                : "Update",
            message: decodeData["message"].toString().tr,
            isError: decodeData["message"].toString().contains("Profession is already updated by other user")
                ? true
                : false);

        isEditSocialMedia = false;
        notifyListeners();
      } else {
        isEditSocialMedia = false;
        notifyListeners();
      }
    } catch (e) {
      isEditSocialMedia = false;
      notifyListeners();
      rethrow;
    }
  }

  /// used to upload contact number after a month
  uploadAfterMonth() {
    var payload1 = {
      "data": listContacts.map((e) {
        return {
          "name": e.displayName,
          "number": removeCountryCode(e.phones.first.number
              .toString()
              .replaceAll(' ', '')
              .replaceAll("-", "")
              .replaceAll("(", "")
              .replaceAll(")", "")),
          "code": e.phones.first.customLabel != ""
              ? e.phones.first.customLabel
              : getCountryCode(e.phones.first.number).isNotEmpty
                  ? getCountryCode(e.phones.first.number)
                  : countryCode == "null"
                      ? country.code ?? "+1"
                      : countryCode,
          "photo": e.photo != null ? base64.encode(e.photoOrThumbnail!) : "",
          "contact_id": e.id,
          "email": e.emails.isNotEmpty ? e.emails.first.address : "",
          "profession": e.organizations.isNotEmpty
              ? e.organizations.first.title.isNotEmpty
                  ? e.organizations.first.title
                  : e.organizations.first.company
              : '',
          "gender": "",
          'address': e.addresses.isEmpty ? '' : e.addresses.first,
          'social': e.socialMedias.isNotEmpty ? e.socialMedias.first.userName : "",
          "dob": e.events.isNotEmpty ? "${e.events.first.year}-${e.events.first.month}-${e.events.first.day}" : "",
        };
      }).toList()
    };

    uploadContactToServer(payload1);
  }

  String getCountryCode(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll('+', '');

    List<String> countryCodes = Countries.allCountries
        .map((country) => country['dial_code']!.replaceAll('+', ''))
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    const int minLength = 10;
    if (phoneNumber.length > minLength) {
      for (String code in countryCodes) {
        if (phoneNumber.startsWith(code)) {
          return '+$code';
        }
      }
    }

    return '';
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

  String detectMimeType(Uint8List bytes) {
    if (bytes.length < 12) return "image/jpeg";

    // PNG (89 50 4E 47 0D 0A 1A 0A)
    if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
      return "image/png";
    }

    // JPEG (FF D8 FF)
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return "image/jpeg";
    }

    // GIF (GIF87a or GIF89a)
    if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) {
      return "image/gif";
    }

    // WEBP (RIFF....WEBP)
    if (bytes[0] == 0x52 && // R
        bytes[1] == 0x49 && // I
        bytes[2] == 0x46 && // F
        bytes[3] == 0x46 && // F
        bytes[8] == 0x57 && // W
        bytes[9] == 0x45 && // E
        bytes[10] == 0x42 && // B
        bytes[11] == 0x50) {
      // P
      return "image/webp";
    }

    // BMP (42 4D)
    if (bytes[0] == 0x42 && bytes[1] == 0x4D) {
      return "image/bmp";
    }

    // TIFF (49 49 2A 00 or 4D 4D 00 2A)
    if ((bytes[0] == 0x49 && bytes[1] == 0x49 && bytes[2] == 0x2A && bytes[3] == 0x00) ||
        (bytes[0] == 0x4D && bytes[1] == 0x4D && bytes[2] == 0x00 && bytes[3] == 0x2A)) {
      return "image/tiff";
    }

    // ICO (00 00 01 00)
    if (bytes[0] == 0x00 && bytes[1] == 0x00 && bytes[2] == 0x01 && bytes[3] == 0x00) {
      return "image/x-icon";
    }

    // HEIC / HEIF (ftypheic / ftypheif / ftypmif1)
    String brand = String.fromCharCodes(bytes.sublist(4, 12));
    if (brand.contains("heic") || brand.contains("heif") || brand.contains("mif1")) {
      return "image/heic";
    }

    // Default fallback
    return "image/jpeg";
  }

  /// used to get updated contact

  updateContact() {
    var payload1 = {
      "data": listContacts.map((e) {
        print("==e.phones.first.customLabel==${e.phones.first.customLabel}");
        print("######################################");
        print(e.photo);
        print(e.photoOrThumbnail);
        return {
          // "nickname": e.displayName,
          "name": e.displayName,
          "number": removeCountryCode(e.phones.first.number
              .toString()
              .replaceAll(' ', '')
              .replaceAll("-", "")
              .replaceAll("(", "")
              .replaceAll(")", "")),
          "code": e.phones.first.customLabel != ""
              ? e.phones.first.customLabel
              : (getCountryCode(e.phones.first.number).isNotEmpty
                  ? getCountryCode(e.phones.first.number)
                  : countryCode == "null"
                      ? country.code ?? "+1"
                      : countryCode),
          // "profile": e.photo != null ? "data:image/jpeg;base64,${base64Encode(e.photo!)}" : "",
          // "profile": e.photo != null ? "data:${detectMimeType(e.photo!)};base64,${base64Encode(e.photo!)}" : "",

          // "profile": e.photoOrThumbnail != null ? "data:${detectMimeType(e.photoOrThumbnail!)};base64,${base64Encode(e.photoOrThumbnail!)}" : "",
          "photo": e.photo != null ? base64.encode(e.photoOrThumbnail!) : "",
          "contact_id": e.id,
          "email": e.emails.isNotEmpty ? e.emails.first.address : "",
          "profession": e.organizations.isNotEmpty
              ? e.organizations.first.title.isNotEmpty
                  ? e.organizations.first.title
                  : e.organizations.first.company
              : '',
          "gender": "",
          'address': e.addresses.isEmpty ? '' : e.addresses.first,
          'social': e.socialMedias.isNotEmpty ? e.socialMedias.first.userName : "",
          "dob": e.events.isNotEmpty ? "${e.events.first.year}-${e.events.first.month}-${e.events.first.day}" : "",
        };
      }).toList()
    };

//     I/flutter ( 1157): Searched Number ===> [Contact(id=28, displayName=Dr H, thumbnail=null, photo=null, isStarred=false, name=Name(first=Dr H, last=, middle=, prefix=, suffix=, nickname=, firstPhonetic=, lastPhonetic=, middlePhonetic=), phones=[Phone(number=(549) 134-6443, normalizedNumber=, label=PhoneLabel.mobile, customLabel=, isPrimary=false)], emails=[], addresses=[], organizations=[], websites=[], socialMedias=[], events=[], notes=[], accounts=[], groups=[])]
// I/flutter ( 1157): Searched Number ===> []
// I/flutter ( 1157): Searched Number ===> []
// Searched Number ===> [Contact(id=29, displayName=Dr. h, thumbnail=null, photo=null, isStarred=false, name=Name(first=Dr. h, last=, middle=, prefix=, suffix=, nickname=, firstPhonetic=, lastPhonetic=, middlePhonetic=), phones=[Phone(number=+90 549 134 64 43, normalizedNumber=+905491346443, label=PhoneLabel.mobile, customLabel=TR, isPrimary=false)], emails=[], addresses=[], organizations=[], websites=[], socialMedias=[], events=[], notes=[], accounts=[], groups=[])]

// {"data":[{"name":"Alex S","number":"9475556022","code":"IN","photo":null,"contact_id":"26","email":null,"profession":null>
//  {"data":[]}
// {"data":[{"name":"Ago","number":"593194474","code":"GE","photo":null,"contact_id":"3355","email":null,"profession":null,">
// {"data":[{"nickname":"Alex S","name":"Alex S","number":"9475556022","code":"IN","profile":null,"contact_id":"26","email":>

    var temp = listContacts.where((e) {
      final searchedNumber = e.phones.first.number.replaceAll(RegExp(r'[\s\-\(\)]'), '');

      return searchedNumber.contains("5491346443");
    }).toList();

    print("Searched Number ===> ${temp}");

    // var temp = payload1
    //     .where((element) => element.phones.first.number.contains("3224097616"));
    print("temp ===> ${payload1}");

    uploadContactToServerUpdated(payload1);
  }

  /// used to new contact to server while register
  Future uploadContactToServer(payload) async {
    try {
      var headers = {'Authorization': 'Bearer ${Params.UserToken}', 'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(ApiEndPoints.UploadContacts));
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print("====response====${response.toString()}");
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("uploadContactToServer ==> $decodeData");

      if (response.statusCode == 200) {
        await fetchServerContactsUpdated();
      }
    } catch (e) {
      UIHelper.showMySnak(title: "Error", message: e.toString(), isError: true);
      rethrow;
    }
  }

  /// used to update existing contacts
  Future uploadContactToServerUpdated(payload) async {
    try {
      var headers = {'Authorization': 'Bearer ${Params.UserToken}', 'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(ApiEndPoints.updateContact));
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      print("====request.body===${request.body}");

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      debugPrint("uploadContactToServer 33 ==> $decodeData");

      if (response.statusCode == 200) {
        await fetchServerContactsUpdated();
      } else {}
    } catch (e) {
      print("-------------------------------------==========================$e");
      rethrow;
    }
  }

  /// used to get updated contact from server when user already logged In
  Future fetchServerContactsUpdated() async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Params.UserToken}',
    };
    var request = http.Request('GET', Uri.parse("${ApiEndPoints.GETCONTACTs}?page=1"));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    final decodeData = jsonDecode(result.body);

    if (response.statusCode == 200) {
      groupedListContactsModel = {};
      listContactsModel.clear();

      var data = json.encode(decodeData);
      Contacts contacts = ContactsFromJson(data);
      if (contacts.data != null) {
        listContactsModel = contacts.data ?? [];
      }

      await Future.forEach(listContactsModel, (contact) async {
        String firstLetter = contact.name!.isNotEmpty ? contact.name![0].toUpperCase() : "";
        if (isWellFormedUTF16(firstLetter)) {
          if (!groupedListContactsModel.containsKey(firstLetter)) {
            groupedListContactsModel[firstLetter] = [];
          }
          if (contact.code.toString() == "-1") {
            contact.code = "";
          }

          if (!groupedListContactsModel[firstLetter]!.contains(contact)) {
            groupedListContactsModel[firstLetter]!.add(contact);
          }
        }
      });
      List<String> sortedKeys = groupedListContactsModel.keys.toList()..sort();
      groupedListContactsModel = {for (var key in sortedKeys) key: groupedListContactsModel[key]!};

      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  /// used to get contact from server after register
  Future fetchServerContacts() async {
    isLoadingContact.value = true;
    notifyListeners();
    groupedListContactsModel = {};
    listContactsModel.clear();
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Params.UserToken}',
    };
    var request = http.Request('GET', Uri.parse("${ApiEndPoints.GETCONTACTs}?page=1"));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    final decodeData = jsonDecode(result.body);

    if (response.statusCode == 200) {
      var data = json.encode(decodeData);
      Contacts contacts = ContactsFromJson(data);
      if (contacts.data != null) {
        listContactsModel = contacts.data ?? [];
        // listContactsModel = contacts.data!.data ?? [];
      }

      groupedListContactsModel.clear();
      await Future.forEach(listContactsModel, (contact) async {
        String firstLetter = contact.name == null
            ? contact.number ?? "Anonymous"
            : contact.name!.isNotEmpty
                ? contact.name![0].toUpperCase()
                : "";
        if (isWellFormedUTF16(firstLetter)) {
          if (!groupedListContactsModel.containsKey(firstLetter)) {
            groupedListContactsModel[firstLetter] = [];
          }
          if (contact.code.toString() == "-1") {
            contact.code = "";
          }

          groupedListContactsModel[firstLetter]!.add(contact);
        }
      });
      List<String> sortedKeys = groupedListContactsModel.keys.toList()..sort();
      groupedListContactsModel = {for (var key in sortedKeys) key: groupedListContactsModel[key]!};
      debugPrint("fetchServerContacts ==> 111 $groupedListContactsModel");

      // compareContacts(listContactsModel, listContacts);

      isLoadingContact.value = false;
      notifyListeners();
    } else {
      isLoadingContact.value = false;
      notifyListeners();
    }
  }

  /// used to use it when need to load more contacts
  /// not used now as removed pagination USE FOR REFERENCE
  Future fetchMoreServerContacts(int page) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Params.UserToken}',
    };
    var request = http.Request('GET', Uri.parse("${ApiEndPoints.GETCONTACTs}?page=$page"));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    final decodeData = jsonDecode(result.body);

    if (response.statusCode == 200) {
      var data = json.encode(decodeData);
      Contacts contacts = ContactsFromJson(data);
      if (contacts.data != null) {
        listContactsModel.addAll(contacts.data ?? []);
        // listContactsModel.addAll(contacts.data!.data ?? []);
      }
      await Future.forEach(listContactsModel, (contact) async {
        String firstLetter = contact.name!.isNotEmpty ? contact.name![0].toUpperCase() : "";
        if (isWellFormedUTF16(firstLetter)) {
          if (!groupedListContactsModel.containsKey(firstLetter)) {
            groupedListContactsModel[firstLetter] = [];
          }
          if (contact.code.toString() == "-1") {
            contact.code = "";
          }

          groupedListContactsModel[firstLetter]!.add(contact);
        }
      });
      List<String> sortedKeys = groupedListContactsModel.keys.toList()..sort();
      groupedListContactsModel = {for (var key in sortedKeys) key: groupedListContactsModel[key]!};

      debugPrint("fetchMoreServerContacts ==> $groupedListContactsModel");

      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  /// used to get logged user's profile
  Future<UserModel> getUserProfileById(token) async {
    try {
      UserModel? model;
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('${ApiEndPoints.BASE_URL}me'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("getUserProfileById ==> $decodeData");

      if (response.statusCode == 200) {
        var prefs = await SharedPreferences.getInstance();
        prefs.setBool("Subscription_Status", decodeData['is_subscription_active']);
        prefs.setString("Subscription_Plan_Name",
            decodeData['active_subscription_plan_name'] != null ? decodeData['active_subscription_plan_name'] : '');
        model = UserModel.fromJson(decodeData);
        getNicknameMe(model.number ?? "");

        notifyListeners();
      } else if (response.statusCode == 401) {
        isLoading.value = false;
        debugPrint("getUserProfileById Error: Unauthorized");
        var message = decodeData['message'] ?? "";
        UIHelper.showMySnak(title: "Error", message: message, isError: true);
        signOut();
        Get.offAll(() => const HomeScreen());
        const LoaderDialog().hideLoader();
      } else if (response.statusCode == 500) {
        debugPrint("getUserProfileById Error: Internal Server Error");
        UIHelper.showMySnak(title: "Error", message: "Internal Server Error", isError: true);
      } else {
        debugPrint("getUserProfileById Error: ${response.statusCode}");
        debugPrint(response.reasonPhrase);
      }
      return model!;
    } catch (e) {
      rethrow;
    }
  }

  /// used to get nickname list from number
  Future getNicknameMe(String number) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Params.UserToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(ApiEndPoints.getNicknameList));
    request.body = json.encode({"number": number});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    final decodeData = jsonDecode(result.body);
    print("Decoded DATA ==> $decodeData");

    if (response.statusCode == 200) {
      List<dynamic> list = decodeData['data'];

      userModel.getNickName = list.map((e) => GetNickName.fromJson(e)).toList();
      notifyListeners();
    } else {
      userModel.getNickName = [];
      notifyListeners();
    }
  }

  /// used to get other user's profile
  Future getOtherUserId(userId) async {
    isLoading.value = true;
    notifyListeners();
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Params.UserToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse('${ApiEndPoints.GETUSERBYID}user_id=$userId'));
    debugPrint('Request URL: ${request.url}');

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    final decodeData = jsonDecode(result.body);
    debugPrint("getOtherUserId ==> $decodeData");

    if (response.statusCode == 200) {
      otherUserModel = full.UserFullModel.fromJson(decodeData);
      isLoading.value = false;
      notifyListeners();
    } else {
      isLoading.value = false;
      notifyListeners();
    }
  }

  /// used to get other user's profile and return profile data
  Future<full.UserFullModel> viewProfile(userId) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Params.UserToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse('${ApiEndPoints.GETUSERBYID}user_id=$userId'));
    debugPrint('Request URL: ${request.url}');

    print("Request ${request.url} and Headers $headers");

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    final decodeData = jsonDecode(result.body);
    debugPrint("${ApiEndPoints.GETUSERBYID}user_id=$userId') Endpoint viewProfile ==> ${result.body}");
    debugPrint("${ApiEndPoints.GETUSERBYID}user_id=$userId') Endpoibt viewProfile ==> $decodeData");

    if (response.statusCode == 200) {
      otherUserModel = full.UserFullModel.fromJson(decodeData);
      return full.UserFullModel.fromJson(decodeData);
    } else {
      return full.UserFullModel.fromJson(decodeData);
    }
  }

  /// used to get nickname list from number
  Future<List<GetNickName>> getNickname(String number) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Params.UserToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(ApiEndPoints.getNicknameList));
    request.body = json.encode({"number": number});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    final decodeData = jsonDecode(result.body);

    if (response.statusCode == 200) {
      List<dynamic> list1 = decodeData['data'];
      print("Decoded DATA in getNickname ==> ${decodeData['data'].length} ${list1.length}");

      return list1.map((e) => GetNickName.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  /// used to get unregistered user's details
  Future<UnregisteredUserModel> viewUnregisterdUser(number) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Params.UserToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(ApiEndPoints.viewUnregisterdProfiel));
    request.body = json.encode({"number": number});
    request.headers.addAll(headers);

    debugPrint("viewUnregisterdUser request ==> ${request.body} and Url ==> ${ApiEndPoints.viewUnregisterdProfiel}");

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    final decodeData = jsonDecode(result.body);
    debugPrint(" Url ==> ${ApiEndPoints.viewUnregisterdProfiel} viewProfile ==> $decodeData");

    if (response.statusCode == 200) {
      return UnregisteredUserModel.fromJson(decodeData);
    } else {
      return UnregisteredUserModel();
    }
  }

  /// used to get unregistered user's details
  /// NOT USED NOW user for reference if required
  Future<UnregisteredUserModel> viewUnregisterdUserSearch(number) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Params.UserToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(ApiEndPoints.viewUnregisterdProfielSearch));
    request.body = json.encode({"number": number});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    final decodeData = jsonDecode(result.body);
    debugPrint("${ApiEndPoints.viewUnregisterdProfielSearch} Endpoint viewProfile ==> $decodeData");

    if (response.statusCode == 200) {
      return UnregisteredUserModel.fromJson(decodeData);
    } else {
      return UnregisteredUserModel();
    }
  }

  /// used to get profession of logged user given by other user
  Future<ProfessionByOtherUserModel> getProfessionByOtherUser(String userId, bool isMe) async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('${ApiEndPoints.professionByOtherUser}?user_id=$userId'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("getProfessionByOtherUser ==> $decodeData");

      if (response.statusCode == 200) {
        if (isMe) {
          professionByOtherUserModel = ProfessionByOtherUserModel.fromJson(decodeData);

          if (professionByOtherUserModel!.data!.isNotEmpty) {
            byOtherUserName = professionByOtherUserModel!.data!.first.username ?? "-";
            byOtherUserProfession = professionByOtherUserModel!.data!.first.profession ?? "-";
          }
        }
        return ProfessionByOtherUserModel.fromJson(decodeData);
      } else {
        return ProfessionByOtherUserModel();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// used to give like and dislike of other user
  Future<full.UserFullModel> likeDislike(userid, bool isLike) async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(isLike ? ApiEndPoints.ADDLIKE : ApiEndPoints.ADDDISLIKE));
      request.body = json.encode({"number": userid});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("likeDisLike response ==> $userid ==> $decodeData");

      if (response.statusCode == 200) {
        notifyListeners();
        return full.UserFullModel.fromJson(decodeData);
      } else {
        return full.UserFullModel.fromJson(decodeData);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// used to follow and unfollow
  /// NOT USED
  Future followUnfollow(userid, bool isFollow) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Params.UserToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(isFollow ? ApiEndPoints.follow : ApiEndPoints.unfollow));
    request.body = json.encode({"user_id": userid});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);
    final decodeData = jsonDecode(result.body);

    if (response.statusCode == 200) {
      debugPrint("followUnfollow ==> $decodeData");
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  /// used to give review of any user
  Future<bool> addReviewAPI(
      String id, String rating, String name, String comment, List<XFile>? file, String userid) async {
    try {
      isAddComment = true;
      notifyListeners();
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.MultipartRequest('POST', Uri.parse(ApiEndPoints.addReview));
      request.fields.addAll({"user_id": id, "rating": rating, "is_name": name, "comment": comment});
      request.headers.addAll(headers);

      final payload = {
        "user_id": id,
        "rating": rating,
        "is_name": name,
        "comment": comment,
      };
      print("PAyload----------------${payload}");
      if (file != null) {
        for (int i = 0; i < file.length; i++) {
          request.files.add(await http.MultipartFile.fromPath('file[]', file[i].path));
        }
      }

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("addReviewAPI ==> $decodeData");

      if (response.statusCode == 200) {
        Get.back();

        UIHelper.showMySnak(title: "Review", message: decodeData["message"], isError: false);
        isAddComment = false;
        notifyListeners();
        return true;
      } else {
        isAddComment = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isAddComment = false;
      notifyListeners();

      return false;
    }
  }

  /// used to give reply of any review
  Future<List<ReviewList>> addReply(String commentid, String comment, String userId) async {
    try {
      isAddComment = true;
      notifyListeners();
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.addCommentReply));
      request.body = json.encode({"comment_id": commentid, "comment": comment});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("REQ URL ==> ${request.url}");
      print("API RESPONSE ==> ${result.body}");
      print("STATUS CODE ==> ${response.statusCode}");

      if (response.statusCode == 200) {
        if (Params.Id == userId) {
          var temp = await getUserProfileById(Params.UserToken);

          debugPrint("addReply ==> ${temp.reviewList}");

          isAddComment = false;
          notifyListeners();
          return temp.reviewList!;
        } else {
          var temp = await viewProfile(userId);
          isAddComment = false;
          notifyListeners();
          return temp.data!.reviewList!;
        }
      } else {
        UIHelper.showMySnak(title: "Error", message: decodeData["message"], isError: true);

        isAddComment = false;
        notifyListeners();
        return [];
      }
    } catch (e) {
      isAddComment = false;
      notifyListeners();

      return [];
    }
  }

  /// used to give reply of review for unregistered user
  Future<List<ReviewList>> addReplyUnregistered(String commentid, String comment, String userId) async {
    try {
      isAddComment = true;
      notifyListeners();
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.addCommentReply));
      request.body = json.encode({"comment_id": commentid, "comment": comment});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      if (response.statusCode == 200) {
        if (Params.Id == userId) {
          var temp = await viewUnregisterdUser(Params.UserToken);

          debugPrint("addReply ==> ${temp.data!.reviews}");

          isAddComment = false;
          notifyListeners();
          return temp.data!.reviews ?? [];
        } else {
          var temp = await viewUnregisterdUser(userId);
          isAddComment = false;
          notifyListeners();
          return temp.data!.reviews!;
        }
      } else {
        UIHelper.showMySnak(title: "Error", message: decodeData["message"], isError: true);

        isAddComment = false;
        notifyListeners();
        return [];
      }
    } catch (e) {
      isAddComment = false;
      notifyListeners();

      return [];
    }
  }

  /// used to get all profession list
  Future<bool> getProfession() async {
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

      debugPrint("getProfession ==> $decodeData");
      if (response.statusCode == 200) {
        listDummyProfesstions = (decodeData as List).map((data) => ProfessionModel.fromJson(data)).toList();

        if (listDummyProfesstions.isNotEmpty) {
          listDummyProfesstions.sort(
            (a, b) => a.profession!.compareTo(b.profession!),
          );
        }

        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    } catch (e) {
      notifyListeners();
      return false;
    }
  }

  /// used to like and dislike for review
  Future<VoteStatusModel> likeDislikeReview(String commentid, bool isLike) async {
    // int status = -1;
    VoteStatusModel status = VoteStatusModel(status: -1, likeCount: 0, disLikeCount: 0);
    try {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(isLike ? ApiEndPoints.likeReview : ApiEndPoints.disLikeReview));
      request.body = json.encode({"comment_id": commentid});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      if (response.statusCode == 200) {
        debugPrint("likeDislikeReview ==> $decodeData");
        if (decodeData["message"].toString().contains("Your dislike added successfully in comment")) {
          // status = 1;
          status = VoteStatusModel(
              status: 1, likeCount: decodeData["data"]["like"], disLikeCount: decodeData["data"]["dislike"]);
        } else if (decodeData["message"].toString().contains("Your dislike removed successfully in comment")) {
          // status = -1;
          status = VoteStatusModel(
              status: -1, likeCount: decodeData["data"]["like"], disLikeCount: decodeData["data"]["dislike"]);
        } else if (decodeData["message"].toString().contains("Your like removed successfully in comment.")) {
          // status = -1;
          status = VoteStatusModel(
              status: -1, likeCount: decodeData["data"]["like"], disLikeCount: decodeData["data"]["dislike"]);
        } else if (decodeData["message"].toString().contains("Your like added successfully in comment")) {
          // status = 0;
          status = VoteStatusModel(
              status: 0, likeCount: decodeData["data"]["like"], disLikeCount: decodeData["data"]["dislike"]);
        } else {
          // status = -1;
          status = VoteStatusModel(
              status: -1, likeCount: decodeData["data"]["like"], disLikeCount: decodeData["data"]["dislike"]);
        }

        return status;
      } else {
        debugPrint(response.reasonPhrase);
        return status;
      }
    } catch (e) {
      return status;
    }
  }

  ///used to react on review
  Future<int> addReaction(String commentId, String name) async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.addReaction));
      request.body = json.encode({"comment_id": commentId, "reaction_name": name});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      if (response.statusCode == 200) {
        debugPrint("addReaction ==> $commentId $decodeData");
        return decodeData["data"]["reactionCount"];
      } else {
        return decodeData["data"]["reactionCount"];
      }
    } catch (e) {
      return 0;
    }
  }

  ///used to delete review
  Future<bool> deleteReviews(String commentId) async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.deleteReview));
      request.body = json.encode({"comment_id": commentId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("deleteReviews ==> $decodeData");

      if (response.statusCode == 200) {
        UIHelper.showMySnak(title: "Delete", message: "Review successfully deleted", isError: false);
        return true;
      } else {
        UIHelper.showMySnak(title: "Delete", message: "Something went wrong", isError: true);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// used to delete any reply of review
  Future<bool> deleteReplyCommenet(String commentId) async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.deleteReplyComment));
      request.body = json.encode({"comment_id": commentId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("deleteReviews ==> $decodeData");

      if (response.statusCode == 200) {
        UIHelper.showMySnak(title: "Delete", message: "Review successfully deleted", isError: false);
        return true;
      } else {
        UIHelper.showMySnak(title: "Delete", message: "Something went wrong", isError: true);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// used to block user
  Future blockUser(String id) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.blockUser));
      request.body = json.encode({"block_user_id": id});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("BLOCK USER ==> ${result.body}");

      if (response.statusCode == 200) {
        UIHelper.showMySnak(title: "Block", message: 'User blocked successfully', isError: false);
        fetchServerContacts();
        Get.offAll(() => const HomeScreen());
      } else {
        UIHelper.showMySnak(title: "Block", message: decodeData["message"], isError: true);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// used to report user
  Future reportUser(String id) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.reportUser));
      request.body = json.encode({"report_user_id": id});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("reportUser ==> $decodeData");

      if (response.statusCode == 200) {
        UIHelper.showMySnak(title: "Report", message: 'User reported successfully', isError: false);
      } else {
        UIHelper.showMySnak(title: "Report", message: 'This user is already reported', isError: true);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// used to get reaction list of any review
  Future getReactionOfComment(String id) async {
    try {
      isReactionOfComment = true;
      notifyListeners();
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('GET', Uri.parse(ApiEndPoints.getReactionOfComment));
      request.body = json.encode({"comment_id": id});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("getReactionOfComment ==> $decodeData");

      if (response.statusCode == 200) {
        commentReactionModel = CommentReactionModel.fromJson(decodeData);
        isReactionOfComment = false;
        notifyListeners();
      } else {
        isReactionOfComment = false;
        notifyListeners();
      }
    } catch (e) {
      isReactionOfComment = false;
      notifyListeners();
      rethrow;
    }
  }

  /// used to get rating of any user
  Future<ProfileRatingModel> getRating(String id) async {
    try {
      isRatingLoading = true;
      notifyListeners();
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('GET', Uri.parse("${ApiEndPoints.profileRating}?user_id=$id"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("getRating ==> $decodeData");

      if (response.statusCode == 200) {
        profileRatingModel = ProfileRatingModel.fromJson(decodeData);
        isRatingLoading = false;
        notifyListeners();
        return profileRatingModel;
      } else {
        isRatingLoading = false;
        notifyListeners();
        return ProfileRatingModel();
      }
    } catch (e) {
      isRatingLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// used to deactive logged user profile
  Future deactiveUser() async {
    try {
      const LoaderDialog().showLoader();
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('GET', Uri.parse(ApiEndPoints.deactiveUser));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("deactiveUser ==> $decodeData");

      if (response.statusCode == 200) {
        signOut();
        Get.offAll(() => const HomeScreen());
        const LoaderDialog().hideLoader();
      } else {
        const LoaderDialog().hideLoader();
      }
    } catch (e) {
      const LoaderDialog().hideLoader();
      rethrow;
    }
  }

  /// used to get visitor list of any user's profile
  Future<VisitorListModel> visitorList(String id) async {
    try {
      isVisitorLoading = true;
      notifyListeners();

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };

      debugPrint("Headers ==> $headers");
      debugPrint("${ApiEndPoints.visitorList}?user_id=$id&page=1");
      debugPrint("User Token ==> Bearer ${Params.UserToken}");
      var request = http.Request('GET', Uri.parse("${ApiEndPoints.visitorList}?user_id=$id"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("visitorList ==> $decodeData");

      if (response.statusCode == 200) {
        var list = VisitorListModel.fromJson(decodeData);
        isVisitorLoading = false;
        notifyListeners();
        return list;
      } else {
        isVisitorLoading = false;
        notifyListeners();
        return VisitorListModel();
      }
    } catch (e) {
      isVisitorLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// used to get visitor list of any user's profile
  Future<VisitorListModel> fethcMoreVisitorList(String id, int page) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('GET', Uri.parse("${ApiEndPoints.visitorList}?user_id=$id&page=$page"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("deactiveUser ==> $decodeData");

      if (response.statusCode == 200) {
        var list = VisitorListModel.fromJson(decodeData);

        notifyListeners();
        return list;
      } else {
        notifyListeners();
        return VisitorListModel();
      }
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }

  /// used to get visitor list of unregistered user
  Future<VisitorListUnregister> visitorListUnregister(String id) async {
    try {
      isVisitorLoading = true;
      notifyListeners();

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('POST', Uri.parse("${ApiEndPoints.visitorUnregisterList}?page=1"));
      request.body = json.encode({"number": id});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("visitorListUnregister ==> $decodeData");

      if (response.statusCode == 200) {
        var list = VisitorListUnregister.fromJson(decodeData);
        isVisitorLoading = false;
        notifyListeners();
        return list;
      } else {
        isVisitorLoading = false;
        notifyListeners();
        return VisitorListUnregister();
      }
    } catch (e) {
      isVisitorLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// used to get more list for pagination
  Future<VisitorListUnregister> visitorMoreListUnregister(String id, int page) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('POST', Uri.parse("${ApiEndPoints.visitorUnregisterList}?page=$page"));
      request.body = json.encode({"number": id});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("visitorListUnregister ==> $decodeData");

      if (response.statusCode == 200) {
        var list = VisitorListUnregister.fromJson(decodeData);

        notifyListeners();
        return list;
      } else {
        notifyListeners();
        return VisitorListUnregister();
      }
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }

  /// used to cancle subscription plan
  Future cancelSubscription() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.cancelSubscription));
      request.body = json.encode({"user_id": Params.Id});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("cancelSubscription ==> $decodeData");

      if (response.statusCode == 200) {
        UIHelper.showMySnak(title: "Cancel", message: "Subscription canceled successfully".tr, isError: false);
        userModel = await getUserProfileById(token);
        notifyListeners();
      } else {
        UIHelper.showMySnak(title: "Cancel", message: "Failed to cancel subscription", isError: true);
      }
    } catch (e) {
      UIHelper.showMySnak(title: "Cancel", message: "Failed to cancel subscription", isError: true);
      rethrow;
    }
  }

  /// used to set new password when forget
  Future setNewPassword(String number, String password) async {
    try {
      isOTPValidation = true;
      notifyListeners();

      var headers = {
        'Content-Type': 'application/json',
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.setNewPassword));
      request.body = json.encode({"number": number, "password": password});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("setNewPassword ==> $decodeData");

      if (response.statusCode == 200) {
        UIHelper.showMySnak(title: "Forget Password", message: "Password changed successfully".tr, isError: false);
        Get.offAll(() => const LoginScreen());
        isOTPValidation = false;
        notifyListeners();
      } else {
        UIHelper.showMySnak(title: "Forget Password", message: decodeData["message"], isError: true);
        isOTPValidation = false;
        notifyListeners();
      }
    } catch (e) {
      isOTPValidation = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Used to edit unregisterd user
  Future editOtherSocialMediaUnregistered(payload, {XFile? img}) async {
    try {
      isEditUnregisterUser = true;
      notifyListeners();

      var headers = {'Authorization': 'Bearer ${Params.UserToken}', 'Content-Type': 'application/json'};
      var request = http.MultipartRequest('POST', Uri.parse(ApiEndPoints.editUnregisterUser));
      request.fields.addAll(payload);
      if (img != null) {
        print("IMAGE-------------------------${img.path}");
        request.files.add(await http.MultipartFile.fromPath('photo', img.path));
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("editOtherSocialMediaUnregistered ==> $decodeData");

      if (response.statusCode == 200) {
        Get.back();

        UIHelper.showMySnak(title: "Updated", message: "Bio is updated", isError: false);

        isEditUnregisterUser = false;
        notifyListeners();
      } else {
        isEditUnregisterUser = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("ERROR_________________________${e}");
      isEditUnregisterUser = false;
      notifyListeners();
      UIHelper.showMySnak(title: "Error", message: e.toString(), isError: true);
      rethrow;
    }
  }

  /// Used to check register number
  Future<bool> checkRegisterNumber(String number) async {
    try {
      isRegister = true;
      notifyListeners();

      var headers = {
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.MultipartRequest('POST', Uri.parse(ApiEndPoints.checkRegisterNumber));
      request.fields.addAll({'number': number});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("checkRegisterNumber ==> $decodeData");

      if (response.statusCode == 200) {
        isRegister = false;
        notifyListeners();
        if (decodeData["data"]["status"] == false) {
          UIHelper.showMySnak(
              title: "Updated",
              message: "This number is not registered, please try with registered number",
              isError: true);
        }
        return decodeData["data"]["status"];
      } else {
        UIHelper.showMySnak(
            title: "Updated",
            message: "This number is not registered, please try with registered number",
            isError: true);
        isRegister = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isRegister = false;
      notifyListeners();
      return false;
    }
  }

  /// used to add new profession
  Future addNewProfession(String profession) async {
    try {
      var headers = {'Authorization': 'Bearer ${Params.UserToken}', 'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(ApiEndPoints.addProfession));
      request.body = json.encode({"profession": profession});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("addNewProfession ==> $decodeData");

      if (response.statusCode == 200) {
        UIHelper.showMySnak(title: "Profession", message: "Profession added to the list successfully", isError: false);
      } else {
        UIHelper.showMySnak(title: "Profession", message: "Profession failed to added", isError: true);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// used to get list of users for voting
  Future<UserVotingModel> userVoting(String number, bool isLike) async {
    try {
      var headers = {'Authorization': 'Bearer ${Params.UserToken}', 'Content-Type': 'application/json'};
      var request = http.MultipartRequest('POST', Uri.parse(ApiEndPoints.userVoting));
      request.fields.addAll({"number": number, "type": isLike ? "upvotes" : "downvotes"});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("decodeData ==>$decodeData");

      if (response.statusCode == 200) {
        return UserVotingModel.fromJson(decodeData);
      } else {
        return UserVotingModel();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// used to mark user as a spam
  Future spamUser(String number) async {
    try {
      var headers = {'Authorization': 'Bearer ${Params.UserToken}', 'Content-Type': 'application/json'};

      var request = http.MultipartRequest('POST', Uri.parse(ApiEndPoints.spamUser));
      request.fields.addAll({"number": number});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("spamUser ==> $decodeData");

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      rethrow;
    }
  }

  /// used to send otp
  Future sendOTP(String number, BuildContext context) async {
    try {
      isOTPValidation = true;
      notifyListeners();

      var headers = {'Authorization': 'Bearer ${Params.UserToken}', 'Content-Type': 'application/json'};

      var request = http.MultipartRequest('POST', Uri.parse(ApiEndPoints.sendOTP));
      request.fields.addAll({"number": number});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      debugPrint("sendOTP ==> $decodeData");

      if (response.statusCode == 200) {
        UIHelper.showBottomFlash(context,
            title: "OTP", message: "${"Verification Code sent to".tr} $number", isError: false);
        isOTPValidation = false;
        notifyListeners();
      } else {
        UIHelper.showBottomFlash(context, title: "OTP", message: decodeData['message'], isError: false);
        isOTPValidation = false;
        notifyListeners();
      }
    } catch (e) {
      isOTPValidation = false;
      notifyListeners();
      rethrow;
    }
  }

  /// used to verify otp
  Future<bool> verifyOTP(String number, String otp, BuildContext context) async {
    try {
      isOTPValidation = true;
      notifyListeners();

      var headers = {'Authorization': 'Bearer ${Params.UserToken}', 'Content-Type': 'application/json'};

      var request = http.MultipartRequest('POST', Uri.parse(ApiEndPoints.verifyOTP));
      request.fields.addAll({"number": number, "code": otp});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("verifyOTP ==> $decodeData");

      if (response.statusCode == 200) {
        isOTPValidation = false;
        notifyListeners();
        return true;
      } else {
        UIHelper.showBottomFlash(context, title: "OTP", message: "Please enter valid OTP", isError: false);
        isOTPValidation = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isOTPValidation = false;
      notifyListeners();

      return false;
    }
  }

  /// used to send otp for georgia only
  Future sendOTPGeorgia(String number, BuildContext context) async {
    try {
      isOTPValidation = true;
      notifyListeners();

      var headers = {'Content-Type': 'application/json'};

      var request = http.Request('POST', Uri.parse("https://api.gosms.ge/api/otp/send"));
      request.body = json.encode({"api_key": ApiEndPoints.geoSMSAPIKey, "phone": number});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      if (response.statusCode == 200) {
        UIHelper.showBottomFlash(context,
            title: "OTP", message: "${"Verification Code sent to".tr} +$number", isError: false);
        hashCodeOTP = decodeData['hash'];
        isOTPValidation = false;
        notifyListeners();
      } else {
        UIHelper.showBottomFlash(context, title: "OTP", message: decodeData['message'], isError: false);
        isOTPValidation = false;
        notifyListeners();
      }
    } catch (e) {
      isOTPValidation = false;
      notifyListeners();
      rethrow;
    }
  }

  /// used to verify otp for georgia
  Future<bool> verifyOTPGeorgia(String number, String otp, BuildContext context) async {
    try {
      isOTPValidation = true;
      notifyListeners();

      var headers = {'Content-Type': 'application/json'};

      var request = http.Request('POST', Uri.parse("https://api.gosms.ge/api/otp/verify"));
      request.body = json.encode({
        "api_key": ApiEndPoints.geoSMSAPIKey,
        "phone": number,
        "hash": hashCodeOTP,
        "code": otp,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      if (response.statusCode == 200) {
        isOTPValidation = false;
        notifyListeners();

        if (decodeData["success"] == true && decodeData["verify"] == true) {
          return true;
        } else {
          UIHelper.showBottomFlash(context, title: "OTP", message: "Please enter valid OTP", isError: false);
          return false;
        }
      } else {
        UIHelper.showBottomFlash(context, title: "OTP", message: "Please enter valid OTP", isError: false);
        isOTPValidation = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isOTPValidation = false;
      notifyListeners();
      return false;
    }
  }

  /// used to lock profile
  Future lookProfile(bool isLock) async {
    try {
      const LoaderDialog().showLoader();
      var headers = {'Authorization': 'Bearer ${Params.UserToken}', 'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(ApiEndPoints.lockProfile));
      request.body = json.encode({"user_id": userModel.id, "type": isLock ? 1 : 0});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("lookProfile ==> $decodeData");

      if (response.statusCode == 200) {
        const LoaderDialog().hideLoader();
        UIHelper.showMySnak(title: "Profile", message: decodeData['message'], isError: false);
      } else {
        const LoaderDialog().hideLoader();
        UIHelper.showMySnak(
            title: "Profile", message: "Profile failed to ${isLock ? "lock" : "unlock"}", isError: true);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// used to verify otp for georgia
  Future<ReviewVoteModel> reviewVoteList(String id, bool isLike) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('GET', Uri.parse(ApiEndPoints.reviewVoteList));
      request.body = json.encode({"comment_id": id, "user_type": isLike ? "like" : "dislike"});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("reviewVoteList ==> $decodeData");

      if (response.statusCode == 200) {
        ReviewVoteModel model = ReviewVoteModel.fromJson(decodeData);
        return model;
      } else {
        return ReviewVoteModel();
      }
    } catch (e) {
      return ReviewVoteModel();
    }
  }

  /// used to store onbording data when user open app for the first time
  Future completeOnbording(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("onbording", value);
  }

  /// used to signout and clear local data
  Future signOut() async {
    Params.UserToken = "null";
    Params.loginTime = "null";
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("token", "null");
    final FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    await pusherService.disconnect();
    Get.offAll(() => const LoginScreen());
  }
}
