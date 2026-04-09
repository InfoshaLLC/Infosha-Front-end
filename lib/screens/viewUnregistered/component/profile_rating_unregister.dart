import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/Controller/models/profile_rating_model.dart';
import 'package:infosha/Controller/models/user_model.dart';
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';
import 'package:infosha/screens/otherprofile/vote_bottom_sheet.dart';
import 'package:infosha/screens/viewUnregistered/model/unregistered_user_model.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/widgets/rating_view.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfileRatingUnregister extends StatefulWidget {
  UnregisteredUserModel viewProfileModel;
  ProfileRatingUnregister({required this.viewProfileModel});

  @override
  State<ProfileRatingUnregister> createState() => _ProfileRatingState();
}

class _ProfileRatingState extends State<ProfileRatingUnregister> {
  // late UserViewModel provider;
  // ProfileRatingModel profileRatingModel = ProfileRatingModel();

  @override
  void initState() {
    // provider = Provider.of<UserViewModel>(context, listen: false);
    if (widget.viewProfileModel.data!.reviews != null &&
        widget.viewProfileModel.data!.reviews!.isNotEmpty) {
      widget.viewProfileModel.data!.reviews
          ?.removeWhere((element) => element.is_deleted_comment == 1);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        backgroundColor: const Color(0xFFF8FDFD),
        elevation: 0,
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () {
            Get.back();
          },
        ),
        title: Text(
          "Profile Ratings".tr,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Consumer<UserViewModel>(builder: (context, provider, child) {
        return provider.isRatingLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: baseColor,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    widget.viewProfileModel.data!.reviews!.isEmpty
                        ? SizedBox(
                            height: Get.height * 0.7,
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                widget.viewProfileModel.data!.reviews!.length,
                            separatorBuilder: (context, index) => const Divider(
                              height: 10,
                              color: Colors.transparent,
                            ),
                            itemBuilder: (context, index) {
                              var data =
                                  widget.viewProfileModel.data!.reviews![index];
                              return listTilewidget(data);
                            },
                          ),
                    /* Consumer<UserViewModel>(
                        builder: (context, provider, child) {
                      return provider.userModel.is_subscription_active ==
                                  null ||
                              provider.userModel.is_subscription_active == false
                          ? Column(
                              children: [
                                SizedBox(height: Get.height * 0.03),
                                Container(
                                  padding: const EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFfAAEDFF),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "You can only view 1 rating per day. To gain unlimited access to this and many more features subscribe now"
                                            .tr,
                                        style: GoogleFonts.workSans(
                                            fontSize: 16,
                                            color: const Color(0xFf46464F),
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: Get.height * 0.02),
                                      CustomButton(
                                        () {
                                          Get.to(() => SubscriptionScreen(
                                              isNewUser: false));
                                        },
                                        text: "Subscribe Now".tr,
                                        textcolor: whiteColor,
                                        color: primaryColor,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          : const SizedBox();
                    }) */
                  ],
                ),
              );
      }),
    );
  }
}

bool isBase64Image(String str) {
  try {
    base64.decode(str);

    return true;
  } catch (e) {
    return false;
  }
}

Widget listTilewidget(ReviewList data) {
  return InkWell(
    onTap: () {
      Get.to(() => ViewProfileScreen(id: data.reviewerId.toString()));
    },
    child: ListTile(
      leading: SizedBox(
        width: Get.width * 0.12,
        height: Get.height * 0.055,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: data.profileUrl == null
              ? Image.asset('images/aysha.png')
              : isBase64Image(data.profileUrl!)
                  ? Image.memory(base64Decode(data.profileUrl!),
                      fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: data.profileUrl!,
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) =>
                          Image.asset('images/aysha.png'),
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: baseColor),
                      ),
                    ),
        ),
      ),
      title: Column(
        children: [
          Row(
            children: [
              Text(
                Jiffy.parse(data.createdAt != null
                        ? utcToLocal(data.createdAt!)
                        : data.createdAt.toString())
                    .fromNow(),
                style: const TextStyle(color: Color(0xFFABAAB4), fontSize: 14),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Text(
                      data.user_nickname ?? data.user_nickname ?? "",
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(width: 5),
                    /* if (data.reviewer != null &&
                        data.reviewer!.activeSubscriptionPlanName != null) ...[
                      SizedBox(
                        height: 15,
                        child: Image(
                          image: AssetImage(data
                                  .reviewer!.activeSubscriptionPlanName
                                  .toString()
                                  .contains("lord")
                              ? 'images/vector.png'
                              : 'images/kingstutspic.png'),
                        ),
                      )
                    ],
                    const SizedBox(width: 5), */

                    const Icon(
                      Icons.verified,
                      size: 15,
                      color: Color(0xFF007EFF),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  MyCustomRatingView(
                      ratinigValue: double.parse(data.rating ?? "0"),
                      fontcolor: const Color(0xFF767680)),
                ],
              ),
            ],
          ),
        ],
      ),
      /* subtitle: Text(
        data.reviewer != null ? data.reviewer!.number ?? "" : "",
        style: const TextStyle(color: Color(0xFF767680), fontSize: 14),
      ), */
    ),
  );
}
