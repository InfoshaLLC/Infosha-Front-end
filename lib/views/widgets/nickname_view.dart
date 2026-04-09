import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import '../../Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/views/widgets/show_loader.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:infosha/screens/viewUnregistered/model/unregistered_user_model.dart';

class NicknameView extends StatefulWidget {
  List<GetNickName> nickName;

  NicknameView({Key? key, required this.nickName}) : super(key: key);

  @override
  _ChangeNameViewState createState() => _ChangeNameViewState();
}

class _ChangeNameViewState extends State<NicknameView> {
  late String selectedName;
  List<String> temp1 = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.nickName.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      List<GetNickName> separatedNames1 = [];

      /// used to split name if name is having semicolon
      for (int i = 0; i < widget.nickName.length; i++) {
        if (widget.nickName[i].name!.contains(';') && widget.nickName[i].addedBy!.contains('Anonymous')) {
          List<String> names = widget.nickName[i].name!.split(';');
          for (int j = 0; j < names.length; j++) {
            separatedNames1.add(GetNickName(addedBy: widget.nickName[i].addedBy, name: names[j]));
          }
        }

        if (widget.nickName[i].name!.contains(';') && widget.nickName[i].addedBy!.toLowerCase() != "anonymous") {
          List<String> names = widget.nickName[i].name!.split(';');

          separatedNames1.add(GetNickName(addedBy: widget.nickName[i].addedBy, name: names.first));
        }
      }
      widget.nickName.removeWhere((element) => element.name!.contains(";"));
      for (int i = 0; i < separatedNames1.length; i++) {
        widget.nickName.add(GetNickName(addedBy: separatedNames1[i].addedBy, name: separatedNames1[i].name));
      }

      List<GetNickName> allName = [];
      allName.addAll(widget.nickName);
      widget.nickName.clear();
      Map<String, Set<String>> nameMap = {};

      for (var entry in allName) {
        String name = entry.name!.trim();
        String addedBy = entry.addedBy!.trim();

        if (!nameMap.containsKey(name)) {
          nameMap[name] = {};
        }

        if (addedBy == 'Anonymous') {
          if (!nameMap[name]!.contains('Anonymous')) {
            nameMap[name]!.add('Anonymous');
            widget.nickName.add(entry);
          }
        } else {
          if (!nameMap[name]!.contains(addedBy)) {
            nameMap[name]!.add(addedBy);
            widget.nickName.add(entry);
          }
        }
      }

      widget.nickName.removeWhere((element) => element.name!.trim().isEmpty);
      selectedName = widget.nickName.first.name ?? "";

      Map<String, int> nameCount = {};

      for (var item in widget.nickName) {
        List<String> names = item.name!.split(';').map((e) => e.trim()).toList();
        for (var name in names) {
          nameCount[name] = (nameCount[name] ?? 0) + 1;
        }
      }

      int maxCount = 0;

      nameCount.forEach((name, count) {
        if (count > maxCount) {
          if (name.isNotEmpty) {
            selectedName = name;
          }
          maxCount = count;
        }
      });

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(covariant NicknameView oldWidget) {
    if (widget.nickName.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      List<GetNickName> separatedNames1 = [];
      for (int i = 0; i < widget.nickName.length; i++) {
        if (widget.nickName[i].name!.contains(';') && widget.nickName[i].addedBy!.contains('Anonymous')) {
          List<String> names = widget.nickName[i].name!.split(';');
          for (int j = 0; j < names.length; j++) {
            separatedNames1.add(GetNickName(addedBy: widget.nickName[i].addedBy, name: names[j]));
          }
        }

        if (widget.nickName[i].name!.contains(';') && widget.nickName[i].addedBy!.toLowerCase() != "anonymous") {
          List<String> names = widget.nickName[i].name!.split(';');

          separatedNames1.add(GetNickName(addedBy: widget.nickName[i].addedBy, name: names.first));
        }
      }
      widget.nickName.removeWhere((element) => element.name!.contains(";"));
      for (int i = 0; i < separatedNames1.length; i++) {
        widget.nickName.add(GetNickName(addedBy: separatedNames1[i].addedBy, name: separatedNames1[i].name));
      }

      List<GetNickName> allName = [];
      allName.addAll(widget.nickName);
      widget.nickName.clear();
      Map<String, Set<String>> nameMap = {};

      for (var entry in allName) {
        String name = entry.name!.trim();
        String addedBy = entry.addedBy!.trim();

        if (!nameMap.containsKey(name)) {
          nameMap[name] = {};
        }

        if (addedBy == 'Anonymous') {
          if (!nameMap[name]!.contains('Anonymous')) {
            nameMap[name]!.add('Anonymous');
            widget.nickName.add(entry);
          }
        } else {
          if (!nameMap[name]!.contains(addedBy)) {
            nameMap[name]!.add(addedBy);
            widget.nickName.add(entry);
          }
        }
      }

      widget.nickName.removeWhere((element) => element.name!.trim().isEmpty);
      selectedName = widget.nickName.first.name ?? "";

      Map<String, int> nameCount = {};

      for (var item in widget.nickName) {
        List<String> names = item.name!.split(';').map((e) => e.trim()).toList();
        for (var name in names) {
          nameCount[name] = (nameCount[name] ?? 0) + 1;
        }
      }

      int maxCount = 0;

      nameCount.forEach((name, count) {
        if (count > maxCount) {
          if (name.isNotEmpty) {
            selectedName = name;
          }
          maxCount = count;
        }
      });
      setState(() {
        isLoading = false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoaderDialog().showLoader()
        : widget.nickName.isEmpty
            ? const SizedBox()
            : PopupMenuButton(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                constraints: BoxConstraints(maxHeight: Get.height * 0.6, maxWidth: Get.width * 0.7, minWidth: Get.width * 0.4),
                position: PopupMenuPosition.under,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: selectedName,
                      color: whiteColor,
                      fontSize: 16.sp,
                      weight: fontWeightMedium,
                    ),
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
                      value: e.name,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: CustomText(
                              text: e.name!.trim().contains(';') ? e.name!.split(';').first.trim() : e.name!.trim(),
                              color: Colors.black,
                              fontSize: 16.sp,
                              weight: fontWeightMedium,
                            )),
                            WidgetSpan(
                              child: CustomText(
                                text: (Provider.of<UserViewModel>(context, listen: false).userModel.is_subscription_active != null &&
                                            Provider.of<UserViewModel>(context, listen: false).userModel.is_subscription_active == true) &&
                                        (Provider.of<UserViewModel>(context, listen: false)
                                                .userModel
                                                .active_subscription_plan_name!
                                                .contains("god") ||
                                            Provider.of<UserViewModel>(context, listen: false)
                                                .userModel
                                                .active_subscription_plan_name!
                                                .contains("king"))
                                    ? " (${e.addedBy})"
                                    : " (Subscription required)",
                                color: hintColor,
                                fontSize: 14.sp,
                                weight: fontWeightRegular,
                              ),
                            )
                            /* if ((Provider.of<UserViewModel>(context,
                                              listen: false)
                                          .userModel
                                          .is_subscription_active !=
                                      null &&
                                  Provider.of<UserViewModel>(context,
                                              listen: false)
                                          .userModel
                                          .is_subscription_active ==
                                      true) &&
                              (Provider.of<UserViewModel>(context,
                                          listen: false)
                                      .userModel
                                      .active_subscription_plan_name!
                                      .contains("god") ||
                                  Provider.of<UserViewModel>(context,
                                          listen: false)
                                      .userModel
                                      .active_subscription_plan_name!
                                      .contains("king"))) ...[
                            WidgetSpan(
                                child: CustomText(
                              text: " (${e.addedBy})",
                              color: hintColor,
                              fontSize: 14.sp,
                              weight: fontWeightRegular,
                            ))
                          ] */
                          ],
                        ),
                      ),
                    );
                  }).toList();
                },
                onSelected: (data) {
                  setState(() {
                    selectedName = data.contains(';') ? data.split(';').first : data;
                  });
                },
              );
  }
}
