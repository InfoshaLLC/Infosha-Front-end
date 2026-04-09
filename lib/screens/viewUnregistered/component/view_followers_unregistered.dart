import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';

import 'package:infosha/screens/otherprofile/view_profile_screen.dart';
import 'package:infosha/screens/viewUnregistered/model/unregistered_user_model.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/widgets/namewithlabel_view.dart';
import 'package:infosha/views/widgets/rating_view.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AllFollowersUnregistered extends StatefulWidget {
  List<Followers> followersList;
  AllFollowersUnregistered({super.key, required this.followersList});

  @override
  State<AllFollowersUnregistered> createState() => _allFollowersState();
}

class _allFollowersState extends State<AllFollowersUnregistered> {
  late UserViewModel provider;

  @override
  void initState() {
    provider = Provider.of<UserViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xFF46464F),
          ),
          onTap: () {
            Get.back();
          },
        ),
        title: CustomText(
          text: "All Followers".tr,
          isHeading: true,
          fontSize: 18.0,
        ),
      ),
      body: widget.followersList.isEmpty
          ? SizedBox(
              height: Get.height * 0.8,
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    APPICONS.searchResultIcon,
                    height: Get.height * 0.09,
                  ),
                  SizedBox(height: Get.height * 0.04),
                  Text(
                    'No Followers Found'.tr,
                    style: GoogleFonts.workSans(
                      color: const Color(0xFF46464F),
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: widget.followersList.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 10, thickness: 0),
              itemBuilder: (context, index) {
                var itemData = widget.followersList[index];
                return followersContainer(itemData);
              },
            ),
    );
  }
}

bool isBase64(String str) {
  try {
    base64.decode(str);

    return true;
  } catch (e) {
    return false;
  }
}

Widget followersContainer(Followers itemData) {
  return InkWell(
    onTap: () {
      Get.to(() => ViewProfileScreen(id: itemData.id.toString()));
    },
    child: Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          child: ClipOval(
            child: SizedBox.fromSize(
              size: Size.fromRadius(Get.height * 0.06),
              child: itemData.profile == null ||
                      itemData.profile! == "https://via.placeholder.com/150"
                  ? Image.asset('images/aysha.png')
                  : isBase64(itemData.profile!)
                      ? Image.memory(base64.decode(itemData.profile!),
                          fit: BoxFit.cover)
                      : CachedNetworkImage(
                          imageUrl: itemData.profile!,
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) =>
                              Image.asset('images/aysha.png'),
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(color: baseColor),
                          ),
                        ),
            ),
          ),
        ),
        /* Container(
          margin: const EdgeInsets.only(left: 5),
          width: Get.width * 0.24,
          height: Get.height * 0.114,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: itemData.profile == null ||
                    itemData.profile! == "https://via.placeholder.com/150"
                ? Image.asset('images/aysha.png')
                : isBase64(itemData.profile!)
                    ? Image.memory(base64.decode(itemData.profile!),
                        fit: BoxFit.cover)
                    : CachedNetworkImage(
                        imageUrl: itemData.profile!,
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) =>
                            Image.asset('images/aysha.png'),
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(color: baseColor),
                        ),
                      ),
          ),
        ), */
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (itemData.profession != null) ...[
                  Text(
                    itemData.profession ?? '-',
                    style:
                        const TextStyle(color: Color(0xFFABAAB4), fontSize: 12),
                  )
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width * 0.44,
                      child: Row(children: [
                        Container(
                          constraints:
                              BoxConstraints(maxWidth: Get.width * 0.34),
                          child: CustomText(
                            text: itemData.username ?? "",
                            color: Colors.black,
                            fontSize: 14,
                            weight: fontWeightSemiBold,
                          ),
                        ),
                        const Icon(
                          Icons.verified,
                          color: Color(0xFF007EFF),
                          size: 18,
                        ),
                        if (itemData.activeSubscriptionPlanName != null) ...[
                          const SizedBox(width: 3),
                          Image(
                            height: 18,
                            image: AssetImage(
                              itemData.activeSubscriptionPlanName!
                                      .contains("lord")
                                  ? APPICONS.lordicon
                                  : itemData.activeSubscriptionPlanName!
                                          .contains("god")
                                      ? APPICONS.godstatuspng
                                      : APPICONS.kingstutspicpng,
                            ),
                          ),
                        ],
                      ]),
                    ),
                    MyCustomRatingView(
                      starSize: 12.0,
                      ratinigValue: itemData.averageReview == null
                          ? 0.0
                          : double.parse(itemData.averageReview.toString()),
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Text(
              itemData.number ?? '',
              style: const TextStyle(color: Color(0xFFABAAB4), fontSize: 12),
            ),
            /* subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    number,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                      Row(
                        children: [
                          if (city.isNotEmpty) ...[Text(' $city, ')],
                          Text(country.isEmpty ? "US" : country),
                        ],
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        height: Get.height * 0.02,
                        width: Get.width * 0.04,
                        child: CountryPickerUtils.getDefaultFlagImage(
                            CountryPickerUtils.getCountryByName(
                                country.isEmpty ? "United States" : country)),
                      ),
                    ],
                  ),
                ],
              ),
            ), */
          ),
        ),
      ],
    ),
  );
}
