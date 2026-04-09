import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infosha/Controller/models/user_full_model.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';

// ignore: must_be_immutable
class AddressView extends StatefulWidget {
  List<GetAddress> nickName;
  String? title = "";

  AddressView({Key? key, required this.nickName, this.title}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddressViewState createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  String selectedName = '--';
  bool isLoaidng = false;
  String loggedinUser = '';

  @override
  void initState() {
    super.initState();

    getUserData().then((data) {
      String userName = data["name"];
      String? matchedAddress;

      // Check if any nickname's added_by matches the logged-in user's name
      for (var nick in widget.nickName) {
        if (nick.addedBy != null && nick.addedBy!.toLowerCase().contains(userName.toLowerCase())) {
          matchedAddress = nick.address?.address;
          break;
        }
      }

      widget.nickName.removeWhere(
        (element) => element.address?.address == null || element.address!.address!.trim().isEmpty,
      );

      setState(() {
        loggedinUser = userName;
        // Use matched email if found, otherwise use the first one
        // if (widget.nickName.first.address?.address != null) {
        //   selectedName = matchedAddress ?? widget.nickName.first.address?.address;
        // }
        if (widget.nickName.isEmpty) {
          selectedName = '--'; // no address available
        } else {
          selectedName = matchedAddress ?? widget.nickName.first.address!.address!;
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
  void didUpdateWidget(covariant AddressView oldWidget) {
    if (widget.nickName.isNotEmpty) {
      setState(() {
        isLoaidng = true;
      });
      widget.nickName.removeWhere((element) => element.address!.address == null || element.address!.address.trim().isEmpty);

      if (widget.nickName.isNotEmpty) {
        selectedName = widget.nickName.first.address!.address!;
      } else {
        selectedName = '--';
      }
      setState(() {
        isLoaidng = false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return isLoaidng
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
                    Container(
                      constraints: BoxConstraints(minWidth: 0, maxWidth: Get.width * 0.6),
                      child: Text(selectedName, style: TextStyle(color: Colors.black, fontWeight: fontWeightMedium, fontSize: 16.sp)),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Image(
                      fit: BoxFit.cover,
                      height: 35,
                      width: 35,
                      filterQuality: FilterQuality.high,
                      image: AssetImage(APPICONS.copyicon),
                    ),
                  ],
                ),
                itemBuilder: (context) {
                  return widget.nickName.map((e) {
                    return PopupMenuItem<String>(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        value: e.address?.address ?? "--",
                        child: RichText(
                            text: TextSpan(children: [
                          WidgetSpan(
                              child: CustomText(
                            text: e.address?.address ?? "--",
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
                  setState(() {
                    selectedName = data;
                  });
                },
              );
  }
}
