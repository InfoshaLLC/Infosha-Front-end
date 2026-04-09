import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/viewUnregistered/model/unregistered_user_model.dart';

class DOBView extends StatefulWidget {
  List<GetDob> nickName;

  DOBView({Key? key, required this.nickName}) : super(key: key);

  @override
  _ChangeNameViewState createState() => _ChangeNameViewState();
}

class _ChangeNameViewState extends State<DOBView> {
  final GlobalKey _buttonKey = GlobalKey();

  String selectedName = '--';
  bool isLoading = false;
  String loggedinUser = '';

  @override
  void initState() {
    super.initState();

    getUserData().then((data) {
      String userName = data["name"];
      String? matchedDob;

      // Check if any nickname's added_by matches the logged-in user's name
      for (var nick in widget.nickName) {
        if (nick.addedBy != null && nick.addedBy!.toLowerCase().contains(userName.toLowerCase())) {
          matchedDob = nick.dob;
          break;
        }
      }

      widget.nickName.removeWhere(
        (element) => element.dob == null || element.dob!.trim().isEmpty,
      );

      setState(() {
        loggedinUser = userName;
        // Use matched email if found, otherwise use the first one
        // selectedName = matchedDob ?? widget.nickName.first.dob!;
        if (widget.nickName.isEmpty) {
          selectedName = '--'; // no address available
        } else {
          selectedName = matchedDob ?? widget.nickName.first.dob!;
        }
      });
    });
  }

  Future<Map<String, dynamic>> getUserData() async {
    var prefs = await SharedPreferences.getInstance();

    return {
      "name": prefs.getString("Name") ?? "",
    };
  }

  @override
  void didUpdateWidget(covariant DOBView oldWidget) {
    if (widget.nickName.isNotEmpty) {
      selectedName = widget.nickName.first.dob!;
    } else {
      selectedName = '--';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : widget.nickName.isEmpty
            ? Text(
                "--",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: fontWeightMedium,
                  fontSize: 16.sp,
                ),
              )
            : PopupMenuButton(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                constraints: BoxConstraints(maxHeight: Get.height * 0.6, maxWidth: Get.width * 0.4, minWidth: Get.width * 0.2),
                position: PopupMenuPosition.under,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(selectedName, style: TextStyle(color: Colors.black, fontWeight: fontWeightMedium, fontSize: 16.sp)),
                    const SizedBox(
                      width: 5,
                    ),
                    Image(
                      fit: BoxFit.cover,
                      height: 35,
                      width: 35,
                      filterQuality: FilterQuality.high,
                      image: AssetImage(
                        APPICONS.copyicon,
                      ),
                    ),
                  ],
                ),
                itemBuilder: (context) {
                  return widget.nickName.map((e) {
                    return PopupMenuItem<String>(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        value: e.dob ?? "--",
                        child: RichText(
                            text: TextSpan(children: [
                          WidgetSpan(
                              child: CustomText(
                            text: e.dob ?? "--",
                            color: Colors.black,
                            fontSize: 16.sp,
                            weight: fontWeightMedium,
                          )),
                          if ((Provider.of<UserViewModel>(context, listen: false).userModel.is_subscription_active != null &&
                                  Provider.of<UserViewModel>(context, listen: false).userModel.is_subscription_active == true) &&
                              (Provider.of<UserViewModel>(context, listen: false).userModel.active_subscription_plan_name!.contains("god") ||
                                  Provider.of<UserViewModel>(context, listen: false).userModel.active_subscription_plan_name!.contains("king"))) ...[
                            WidgetSpan(
                                child: CustomText(
                              text: " (${e.addedBy})",
                              color: hintColor,
                              fontSize: 14.sp,
                              weight: fontWeightRegular,
                            ))
                          ]
                        ])));
                  }).toList();
                },
                onSelected: (data) {
                  print("data ==> $data");
                  setState(() {
                    selectedName = data;
                  });
                },
              );
  }
}
