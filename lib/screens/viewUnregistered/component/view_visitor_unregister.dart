import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/Controller/models/visitor_list_model.dart';
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';
import 'package:infosha/screens/otherprofile/vote_bottom_sheet.dart';
import 'package:infosha/screens/subscription/component/subscription_screen.dart';
import 'package:infosha/screens/viewUnregistered/model/visitor_list_unregister.dart';
import 'package:infosha/utils/error_boundary.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/widgets/common_dialog_with_button.dart';
import 'package:infosha/views/widgets/locked_widget.dart';
import 'package:infosha/views/widgets/rating_view.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class VisitorUnregisterScreen extends StatefulWidget {
  String id;
  VisitorUnregisterScreen({super.key, required this.id});

  @override
  State<VisitorUnregisterScreen> createState() => _VisitorScreenState();
}

class _VisitorScreenState extends State<VisitorUnregisterScreen> {
  late UserViewModel provider;
  VisitorListUnregister model = VisitorListUnregister();
  int page = 1;
  ScrollController scrollController = ScrollController();
  bool isLoadingMoreData = false;

  @override
  void initState() {
    getData();
    scrollController.addListener(_fetchMoreData);
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      showAdsDialog();
    }); */
    super.initState();
  }

  getData() async {
    page = 1;
    provider = await Provider.of<UserViewModel>(context, listen: false);
    model = await provider.visitorListUnregister(widget.id);
  }

  _fetchMoreData() async {
    if (scrollController.offset == scrollController.position.maxScrollExtent && isLoadingMoreData == false) {
      setState(() {
        isLoadingMoreData = true;
      });
      page += 1;
      await provider.visitorMoreListUnregister(widget.id, page).then((value) {
        model.data!.data!.addAll(value.data!.data!);
        isLoadingMoreData = false;
      });
      setState(() {});
    }
  }

  showAdsDialog() async {
    if (Provider.of<UserViewModel>(context, listen: false).userModel.is_subscription_active == null ||
        Provider.of<UserViewModel>(context, listen: false).userModel.is_subscription_active == false) {
      showDialog(
        barrierDismissible: false,
        barrierColor: Colors.white,
        context: context,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: CommonDialogButton(title: "See rewarded ad to view who viewed your profile", buttonTitleNo: "Exit", buttonTitleYes: "See Ads"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: InkWell(
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onTap: () {
                Get.back();
              },
            ),
            title: CustomText(
              text: 'Visitor',
              color: Colors.black,
              weight: fontWeightMedium,
              fontSize: 18.0,
            ),
          ),
          body: Consumer<UserViewModel>(builder: (context, provider, child) {
            return SizedBox(
                height: Get.height,
                width: Get.width,
                child: provider.userModel.is_subscription_active == null || provider.userModel.is_subscription_active == false
                    ? Center(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFfAAEDFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Purchase King/God subscription to see who visited you",
                                style: TextStyle(color: Color(0xFf46464F), fontSize: 16),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: Get.width,
                                height: Get.height * 0.060,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(22.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.to(() => SubscriptionScreen(isNewUser: false));
                                    },
                                    child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500))),
                              )
                            ],
                          ),
                        ),
                      )
                    : provider.isVisitorLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: baseColor,
                            ),
                          )
                        : Column(
                            children: [
                              if (model.data != null) ...[
                                model.data!.data!.isEmpty
                                    ? SizedBox(
                                        height: Get.height * 0.6,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.not_interested,
                                              size: 50,
                                              color: Color(0xFF46464F),
                                            ),
                                            Text(
                                              'No results found'.tr,
                                              style: GoogleFonts.workSans(
                                                color: const Color(0xFF46464F),
                                                fontSize: 26,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Expanded(
                                        child: ListView.separated(
                                          controller: scrollController,
                                          shrinkWrap: true,
                                          itemCount: model.data!.data!.length + 1,
                                          separatorBuilder: (context, index) => const Divider(
                                            height: 10,
                                            color: Colors.transparent,
                                          ),
                                          itemBuilder: (context, index) {
                                            if (index < model.data!.data!.length) {
                                              var tempData = model.data!.data![index];
                                              return InkWell(
                                                onTap: () {
                                                  if (tempData.isLocked != null && tempData.isLocked == false) {
                                                    Get.to(() => ViewProfileScreen(id: tempData.id.toString()));
                                                  }
                                                },
                                                child: Stack(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets.only(left: 10),
                                                          width: Get.width * 0.18,
                                                          height: Get.height * 0.085,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(50),
                                                            child: tempData.profile == null || tempData.profile == "https://via.placeholder.com/150"
                                                                ? Image.asset('images/aysha.png')
                                                                : isBase64(tempData.profile!)
                                                                    ? Image.memory(
                                                                        base64Decode(tempData.profile!),
                                                                        fit: BoxFit.cover,
                                                                      )
                                                                    : CachedNetworkImage(
                                                                        imageUrl: tempData.profile!,
                                                                        fit: BoxFit.fill,
                                                                        errorWidget: (context, url, error) => Image.asset('images/aysha.png'),
                                                                        placeholder: (context, url) => const Center(
                                                                          child: CircularProgressIndicator(color: baseColor),
                                                                        ),
                                                                      ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: ListTile(
                                                            title: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  utcToLocal(tempData.createdAt ?? DateTime.now().toString()),
                                                                  style: const TextStyle(color: Color(0xFFABAAB4), fontSize: 14),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      width: Get.width * 0.39,
                                                                      padding: const EdgeInsets.only(right: 10),
                                                                      child: Text(
                                                                        tempData.username ?? "",
                                                                        maxLines: 2,
                                                                        style: const TextStyle(color: Colors.black, fontSize: 16),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        MyCustomRatingView(
                                                                            ratinigValue: double.parse(tempData.averageReview != null
                                                                                ? tempData.averageReview.toString()
                                                                                : "0"),
                                                                            fontcolor: const Color(0xFF767680)),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            subtitle: Text(
                                                              tempData.number ?? "",
                                                              style: const TextStyle(color: Color(0xFF767680), fontSize: 14),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    if (tempData.isLocked != null && tempData.isLocked == true) ...[LockWidget()]
                                                  ],
                                                ),
                                              );
                                            } else if (isLoadingMoreData) {
                                              return const Center(
                                                child: CircularProgressIndicator(color: baseColor),
                                              );
                                            }
                                          },
                                        ),
                                      )
                              ],
                            ],
                          ));
          })),
    );
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
