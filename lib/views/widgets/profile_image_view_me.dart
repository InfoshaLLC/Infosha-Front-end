// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/Controller/models/user_model.dart';

import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/full_screen_image.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ProfileImageViewMe extends StatefulWidget {
  List<GetProfiles> nickName;
  String name;

  ProfileImageViewMe({Key? key, required this.nickName, required this.name})
      : super(key: key);

  @override
  _ChangeNameViewState createState() => _ChangeNameViewState();
}

class _ChangeNameViewState extends State<ProfileImageViewMe>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  Uint8List? _cachedImageData;
  late UserViewModel provider;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    provider = Provider.of<UserViewModel>(context, listen: false);

    _initialize(context);
    super.initState();
  }

  Future<void> _initialize(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await getSharedPref(context);
    _cacheImageData();
    setState(() {
      isLoading = false;
    });
  }

  void _cacheImageData() {
    if (isBase64(provider.selectedName)) {
      _cachedImageData = base64.decode(provider.selectedName);
    }
  }

  Future getSharedPref(BuildContext context) async {
    var pref = await SharedPreferences.getInstance();
    provider.selectedName = pref.getString("selectedName") ?? "";
    if (provider.selectedName.isEmpty) {
      if (widget.nickName.isNotEmpty) {
        provider.selectedName = widget.nickName.first.profile ?? "";
        _cacheImageData();
      }
    }
  }

  @override
  void didUpdateWidget(covariant ProfileImageViewMe oldWidget) {
    if (_cachedImageData == null && isBase64(provider.selectedName)) {
      _cachedImageData = base64.decode(provider.selectedName);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(builder: (context, provider, child) {
      return isLoading
          ? Container()
          : widget.nickName.isEmpty
              ? InkWell(
                  onTap: () {
                    Get.to(() => FullScreenImage(
                          image: "",
                          name: widget.name,
                          isBase64: false,
                          showDefault: false,
                        ));
                  },
                  child: CircleAvatar(
                    radius: Get.height * 0.095,
                    child: CustomText(
                      text: UIHelper.getShortName(
                          string: widget.name, limitTo: 2),
                      fontSize: 20.0,
                      color: Colors.black,
                      weight: fontWeightMedium,
                    ),
                  ),
                )
              : PopupMenuButton(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  constraints: BoxConstraints(
                    maxHeight: Get.height * 0.6,
                    maxWidth: Get.width * 0.4,
                    minWidth: Get.width * 0.2,
                  ),
                  position: PopupMenuPosition.under,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 35),
                      InkWell(
                        onTap: () {
                          Get.to(() => FullScreenImage(
                                image: provider.selectedName,
                                name: widget.name,
                                isBase64: isBase64(provider.selectedName),
                                base64Data: isBase64(provider.selectedName)
                                    ? base64.decode(provider.selectedName)
                                    : null,
                                showDefault: false,
                              ));
                        },
                        child: isBase64(provider.selectedName)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(
                                  _cachedImageData!,
                                ),
                                radius: Get.height * 0.095,
                              )
                            : CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    provider.selectedName),
                                radius: Get.height * 0.095,
                              ),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          value: e.profile,
                          child: RichText(
                              text: TextSpan(children: [
                            WidgetSpan(
                              child: isBase64(e.profile!)
                                  ? CircleAvatar(
                                      backgroundImage: MemoryImage(
                                          base64.decode(e.profile!)),
                                      radius: Get.height * 0.022,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              e.profile!),
                                      radius: Get.height * 0.022,
                                    ),
                            ),
                            if ((Provider.of<UserViewModel>(context,
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
                            ]
                          ])));
                    }).toList();
                  },
                  onSelected: (data) {
                    setState(() {
                      provider.changePhoto(data);
                      _cacheImageData();
                      // provider.selectedName = data;
                    });
                  },
                );
    });
  }

  bool isBase64(String str) {
    try {
      base64.decode(str);

      return true;
    } catch (e) {
      return false;
    }
  }
}
