import 'package:infosha/utils/error_boundary.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/models/incoming_call_model.dart';
import 'package:infosha/Controller/models/user_model.dart';
import 'package:infosha/config/api_endpoints.dart';
import 'package:infosha/country_list.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:infosha/views/widgets/rating_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_alert_window/system_alert_window.dart';

class TrueCallerOverlay extends StatefulWidget {
  const TrueCallerOverlay({Key? key}) : super(key: key);

  @override
  State<TrueCallerOverlay> createState() => _TrueCallerOverlayState();
}

class _TrueCallerOverlayState extends State<TrueCallerOverlay> {
  String number = "null";
  String mostUsedName = "";
  String mostUsedProfession = "";
  bool isIncomingCall = false;
  IncomingCallModel incomingCallModel = IncomingCallModel();
  List<String> allNames = [];
  List<String> lastFiveNames = [];
  bool isGod = false;

  @override
  void initState() {
    super.initState();

    print('Init state in DialogOverlay');

    /// used to close dialog if any error received

    /* FlutterOverlayWindow.overlayListener.handleError((e) async {
      await FlutterOverlayWindow.closeOverlay();
      await FlutterOverlayWindow.shareData("null");
    });


    FlutterOverlayWindow.overlayListener.listen((event) {
      number = event;
      getNumber(event).then((value) {
        fetchIncomingData(number);
      });

      setState(() {});
    }); */

    SystemAlertWindow.overlayListener.handleError((error) async {
      await SystemAlertWindow.closeSystemWindow(prefMode: SystemWindowPrefMode.OVERLAY);
      await SystemAlertWindow.sendMessageToOverlay("null");
    });

    /// used to listen dialog and get number
    SystemAlertWindow.overlayListener.listen((event) {
      getProfileData();
      number = event;

      getNumber(event).then((value) {
        fetchIncomingData(number);
      });

      setState(() {});
    });
  }

  getProfileData() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token") ?? "";
    try {
      var headers = {'Accept': 'application/json', 'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
      var request = http.Request('GET', Uri.parse('${ApiEndPoints.BASE_URL}me'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      if (response.statusCode == 200) {
        UserModel model = UserModel.fromJson(decodeData);

        if (model.is_subscription_active == true &&
            (model.active_subscription_plan_name != null && model.active_subscription_plan_name!.contains("god"))) {
          isGod = true;
        } else {
          isGod = false;
        }
      } else {
        isGod = false;
      }
    } catch (e) {
      isGod = false;
      rethrow;
    }
  }

  /// used to remove country code from number and used in API call
  Future getNumber(String phoneWithDialCode) async {
    allNames.clear();
    lastFiveNames.clear();

    Map<String, String> foundedCountry = {};
    for (var country in Countries.allCountries) {
      String dialCode = country["dial_code"].toString();
      if (phoneWithDialCode.contains(dialCode)) {
        foundedCountry = country;
      }
    }

    if (foundedCountry.isNotEmpty) {
      var dialCode = phoneWithDialCode.substring(
        0,
        foundedCountry["dial_code"]!.length,
      );
      var newPhoneNumber = phoneWithDialCode.substring(
        foundedCountry["dial_code"]!.length,
      );
      number = newPhoneNumber;
      print({dialCode, newPhoneNumber});
    }
  }

  /// used to call API and get data from number
  fetchIncomingData(String number) async {
    incomingCallModel.data = null;
    try {
      setState(() {
        isIncomingCall = true;
      });

      var request = http.Request('GET', Uri.parse("${ApiEndPoints.incomingCallData}?number=$number"));

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      if (response.statusCode == 200) {
        incomingCallModel = IncomingCallModel.fromJson(decodeData);

        if (incomingCallModel.data!.getNames != null && incomingCallModel.data!.getNames!.isNotEmpty) {
          if (incomingCallModel.data!.reviews != null && incomingCallModel.data!.reviews!.isNotEmpty) {
            incomingCallModel.data!.reviews!.sort((a, b) => b.commentReactionsCount!.compareTo(a.commentReactionsCount!));
          }

          incomingCallModel.data!.getNames!.forEach((map) {
            List<String> names = map.name!.split(';');
            allNames.addAll(names);
          });

          if (incomingCallModel.data!.profession!.isNotEmpty) {}

          mostUsedname();
          mostUsedprofession();
        } else {
          if (incomingCallModel.data!.name!.contains(";")) {
            List<String> names = incomingCallModel.data!.name!.split(';');
            allNames.addAll(names);
          } else {
            allNames.add(incomingCallModel.data!.name!);
          }
        }

        lastFiveNames = allNames.length > 5 ? allNames.sublist(allNames.length - 5) : allNames;

        setState(() {
          isIncomingCall = false;
        });
      } else {
        setState(() {
          isIncomingCall = false;
        });
      }
    } catch (e) {
      setState(() {
        isIncomingCall = false;
      });
      rethrow;
    }
  }

  /// used to get most used profession
  mostUsedprofession() {
    if (incomingCallModel.data!.profession != null && incomingCallModel.data!.profession!.isNotEmpty) {
      Map<String, int> professionCounts = {};

      // Count the occurrences of each profession
      for (var profession in incomingCallModel.data!.profession!) {
        String professionName = profession.profession!.toLowerCase();
        if (professionCounts.containsKey(professionName)) {
          professionCounts[professionName] = professionCounts[professionName]! + 1;
        } else {
          professionCounts[professionName] = 1;
        }
      }

      // Sort the professions by count
      List<MapEntry<String, int>> sortedProfessions = professionCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

      // Get the most used profession or the first one if none is most used
      String mostUsed = sortedProfessions.isNotEmpty ? sortedProfessions.first.key : incomingCallModel.data!.profession!.first.profession!;

      mostUsedProfession = mostUsed;
    }
  }

  /// used to get most used name
  mostUsedname() {
    Map<String, int> nameCount = {};

    for (var item in incomingCallModel.data!.getNames!) {
      List<String> names = item.name!.split(';').map((e) => e.trim().toLowerCase()).toList();
      for (var name in names) {
        nameCount[name] = (nameCount[name] ?? 0) + 1;
      }
    }

    int maxCount = 0;

    nameCount.forEach((name, count) {
      if (count > maxCount) {
        mostUsedName = name;
        maxCount = count;
      }
    });

    mostUsedName = mostUsedName;
  }

  bool isBase64(String str) {
    try {
      base64.decode(str);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// used to mark user as a spam
  Future spamUser(String number) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "null";
    try {
      var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

      var request = http.Request('POST', Uri.parse(ApiEndPoints.spamUser));
      request.body = json.encode({"number": number});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("spamUser ==> ${decodeData}");

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: decodeData["message"]);
      } else {
        Fluttertoast.showToast(msg: decodeData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: 450,
          // height: Get.height * 0.4,
          width: Get.width,
          padding: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
              Color(0xFF0F296D),
              Color(0xFF0F296D),
              Color(0xFF004683),
              Color(0xFF006599),
              Color(0xFF007CA9),
              Color(0xFF009EC4),
            ]),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: isIncomingCall == true
              ? Stack(
                  children: [
                    const Center(
                      child: CircularProgressIndicator(color: baseColor),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () async {
                          await SystemAlertWindow.closeSystemWindow(prefMode: SystemWindowPrefMode.OVERLAY);
                          await SystemAlertWindow.sendMessageToOverlay("null");
                          /* await FlutterOverlayWindow.closeOverlay();
                          await FlutterOverlayWindow.shareData("null"); */
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    incomingCallModel.data == null
                        ? Align(
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  width: Get.width * 0.25,
                                  height: Get.height * 0.2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.asset('images/aysha.png'),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: Get.width * 0.35,
                                                child: const Text(
                                                  "anonymous",
                                                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              MyCustomRatingView(
                                                starSize: 12.0,
                                                fontcolor: Colors.white,
                                                ratinigValue: 0,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: Get.height * 0.006),
                                        ],
                                      ),
                                      subtitle: Text(
                                        number,
                                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                                      )),
                                ),
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        width: Get.width * 0.25,
                                        height: Get.height * 0.2,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: incomingCallModel.data!.photo == null || incomingCallModel.data!.photo == ""
                                              ? CircleAvatar(
                                                  radius: 22,
                                                  backgroundColor: Colors.white,
                                                  child: CustomText(
                                                    text: UIHelper.getShortName(string: incomingCallModel.data!.name ?? "", limitTo: 2),
                                                    fontSize: 20.0,
                                                    color: baseColor,
                                                    weight: fontWeightMedium,
                                                  ),
                                                )
                                              : isBase64(incomingCallModel.data!.photo!)
                                                  ? Image.memory(base64Decode(incomingCallModel.data!.photo!), fit: BoxFit.cover)
                                                  : CachedNetworkImage(
                                                      imageUrl: incomingCallModel.data!.photo!,
                                                      fit: BoxFit.fill,
                                                      errorWidget: (context, url, error) => CircleAvatar(
                                                        radius: 22,
                                                        backgroundColor: Colors.white,
                                                        child: CustomText(
                                                          text: UIHelper.getShortName(string: incomingCallModel.data!.name ?? "", limitTo: 2),
                                                          fontSize: 20.0,
                                                          color: baseColor,
                                                          weight: fontWeightMedium,
                                                        ),
                                                      ),
                                                      placeholder: (context, url) => const Center(
                                                        child: CircularProgressIndicator(color: baseColor),
                                                      ),
                                                    ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                            dense: true,
                                            visualDensity: const VisualDensity(vertical: 4),
                                            title: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: Get.width * 0.63,
                                                  child: Text(
                                                    incomingCallModel.data!.user_profession != null
                                                        ? incomingCallModel.data!.user_profession ?? ""
                                                        : incomingCallModel.data!.profession!.isNotEmpty
                                                            ? mostUsedProfession
                                                            : "",
                                                    style: const TextStyle(fontSize: 14, color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(height: Get.height * 0.01),
                                                if (mostUsedName != "" && mostUsedName.contains(";") == false) ...[
                                                  SizedBox(
                                                    width: Get.width * 0.58,
                                                    child: Text(
                                                      mostUsedName.toLowerCase(),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(fontSize: Get.width * 0.04, color: Colors.white, fontWeight: FontWeight.bold),
                                                    ),
                                                  )
                                                ],
                                                SizedBox(height: Get.height * 0.01),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: Get.width * 0.41,
                                                      child: Text(
                                                        allNames.join(', ').toLowerCase()
                                                        /* lastFiveNames
                                                          .join(', ')
                                                          .toLowerCase() */
                                                        ,
                                                        maxLines: 10,
                                                        overflow: TextOverflow.ellipsis,
                                                        style:
                                                            TextStyle(fontSize: Get.width * 0.04, color: Colors.white, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        MyCustomRatingView(
                                                          starSize: 12.0,
                                                          fontcolor: Colors.white,
                                                          ratinigValue: incomingCallModel.data!.averageReview != null
                                                              ? double.parse(incomingCallModel.data!.averageReview != null
                                                                  ? incomingCallModel.data!.averageReview.toString()
                                                                  : "0")
                                                              : 0,
                                                        ),
                                                        const SizedBox(height: 20),
                                                        PopupMenuButton(
                                                          constraints: BoxConstraints(
                                                              maxHeight: Get.height * 0.6, maxWidth: Get.width * 0.7, minWidth: Get.width * 0.4),
                                                          position: PopupMenuPosition.under,
                                                          child: const Padding(
                                                            padding: EdgeInsets.only(right: 10),
                                                            child: Icon(
                                                              Icons.more_vert,
                                                              color: Colors.white,
                                                              weight: 20,
                                                            ),
                                                          ),
                                                          itemBuilder: (context) {
                                                            return [
                                                              PopupMenuItem(
                                                                child: ListTile(
                                                                  visualDensity: const VisualDensity(vertical: -4),
                                                                  contentPadding: EdgeInsets.zero,
                                                                  leading: const Icon(Icons.notification_important_outlined),
                                                                  title: Text("Spam".tr),
                                                                ),
                                                                onTap: () {
                                                                  spamUser(number);
                                                                },
                                                              ),
                                                            ];
                                                          },
                                                        )
                                                        /* ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                const MaterialStatePropertyAll(
                                                              baseColor,
                                                            ),
                                                            shape:
                                                                MaterialStatePropertyAll(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(20),
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            spamUser(number);
                                                          },
                                                          child: Text(
                                                            'Spam'.tr,
                                                            style: const TextStyle(
                                                                color: Colors.white),
                                                          )) */
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: Get.height * 0.006),
                                              ],
                                            ),
                                            subtitle: Text(
                                              incomingCallModel.data!.number ?? number,
                                              style: TextStyle(color: Colors.white, fontSize: Get.width * 0.045, fontWeight: FontWeight.w500),
                                            ),
                                            contentPadding: EdgeInsets.zero),
                                      ),
                                    ],
                                  ),
                                ),
                                if (incomingCallModel.data!.getAddress != null && incomingCallModel.data!.getAddress!.isNotEmpty) ...[
                                  Padding(
                                    padding: EdgeInsets.only(left: Get.width * 0.2),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              incomingCallModel.data!.getAddress![0].address!.city != null &&
                                                      incomingCallModel.data!.getAddress![0].address!.city != ""
                                                  ? "${incomingCallModel.data!.getAddress![0].address!.city},"
                                                  : "",
                                              style: TextStyle(color: Colors.white, fontSize: Get.width * 0.03),
                                            ),
                                            Text(
                                              incomingCallModel.data!.getAddress![0].address!.country != null &&
                                                      incomingCallModel.data!.getAddress![0].address!.country != ""
                                                  ? " ${incomingCallModel.data!.getAddress![0].address!.country},"
                                                  : "",
                                              style: TextStyle(color: Colors.white, fontSize: Get.width * 0.03),
                                            ),
                                            const SizedBox(width: 5),
                                            if (incomingCallModel.data!.getAddress![0].address!.country != null &&
                                                incomingCallModel.data!.getAddress![0].address!.country != "") ...[
                                              SizedBox(
                                                height: Get.height * 0.015,
                                                width: Get.width * 0.05,
                                                child: CountryPickerUtils.getDefaultFlagImage(
                                                    CountryPickerUtils.getCountryByName(incomingCallModel.data!.getAddress![0].address!.country!)),
                                              )
                                            ],
                                          ],
                                        ),
                                        Text(
                                          incomingCallModel.data!.getDob![0].dob != null && incomingCallModel.data!.getDob![0].dob != ""
                                              ? "DOB: ${incomingCallModel.data!.getDob![0].dob}"
                                              : "",
                                          style: TextStyle(color: Colors.white, fontSize: Get.width * 0.03),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                SizedBox(height: Get.height * 0.01),
                                if (incomingCallModel.data!.reviews != null && incomingCallModel.data!.reviews!.isNotEmpty) ...[
                                  TitledContainer(
                                    titleText: "Comment by ${incomingCallModel.data!.reviews![0].nicknames ?? ""}",
                                    child: Center(
                                      child: Text(
                                        incomingCallModel.data!.reviews![0].comment ?? "",
                                        style: TextStyle(color: Colors.white, fontSize: Get.width * 0.035),
                                      ),
                                    ),
                                  )
                                ],
                              ],
                            ),
                          ),
                    if (isGod == false &&
                        (incomingCallModel.data != null && incomingCallModel.data!.isLocked != null && incomingCallModel.data!.isLocked == true)) ...[
                      lockedProfile()
                    ],
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () async {
                          await SystemAlertWindow.closeSystemWindow(prefMode: SystemWindowPrefMode.OVERLAY);
                          await SystemAlertWindow.sendMessageToOverlay("null");
                          // await FlutterOverlayWindow.closeOverlay();
                          // await FlutterOverlayWindow.shareData("null");
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget lockedProfile() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black38.withOpacity(0.1),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 28, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Profile Locked",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TitledContainer extends StatelessWidget {
  const TitledContainer({required this.titleText, required this.child, this.idden = 8, Key? key}) : super(key: key);
  final String titleText;
  final double idden;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: Get.width * 0.9,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFf3BBED7)),
            borderRadius: BorderRadius.circular(idden * 0.6),
          ),
          child: child,
        ),
        Positioned(
          left: 10,
          right: 10,
          top: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: const Color(0xFF009EC4),
              child: Text(
                titleText,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: Get.width * 0.035),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
