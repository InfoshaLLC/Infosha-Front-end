import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/Controller/models/user_full_model.dart';
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';
import 'package:infosha/utils/error_boundary.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/widgets/namewithlabel_view.dart';
import 'package:infosha/views/widgets/rating_view.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AllFollowersOtheruser extends StatefulWidget {
  List<Followers> followersList;
  AllFollowersOtheruser({super.key, required this.followersList});

  @override
  State<AllFollowersOtheruser> createState() => _allFollowersState();
}

class _allFollowersState extends State<AllFollowersOtheruser> {
  late UserViewModel provider;

  @override
  void initState() {
    provider = Provider.of<UserViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: Scaffold(
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
          margin: const EdgeInsets.only(left: 10),
          width: Get.width * 0.24,
          height: Get.height * 0.114,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: itemData.profile!.profileUrl ==
                    "https://via.placeholder.com/150"
                ? Image.asset('images/aysha.png')
                : isBase64(itemData.profile!.profileUrl!)
                    ? Image.memory(
                        base64.decode(itemData.profile!.profileUrl!),
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: itemData.profile!.profileUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            Image.asset('images/aysha.png'),
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
                if (itemData.profile!.profession != null) ...[
                  Text(
                    itemData.profile!.profession ?? '-',
                    style:
                        const TextStyle(color: Color(0xFFABAAB4), fontSize: 12),
                  )
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width * 0.37,
                      padding: const EdgeInsets.only(right: 5),
                      child: Row(children: [
                        CustomText(
                          text: itemData.username ?? "",
                          color: Colors.black,
                          fontSize: 14,
                          weight: fontWeightSemiBold,
                        ),
                        if (itemData.active_subscription_plan_name != null) ...[
                          Image(
                            height: 18,
                            image: AssetImage(
                              itemData.active_subscription_plan_name!
                                      .contains("lord")
                                  ? APPICONS.lordicon
                                  : itemData.active_subscription_plan_name!
                                          .contains("god")
                                      ? APPICONS.godstatuspng
                                      : APPICONS.kingstutspicpng,
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                        const Icon(
                          Icons.verified,
                          color: Color(0xFF007EFF),
                          size: 18,
                        ),
                      ]) /* NamewithlabelView(
                        displayName: itemData.username ?? "",
                        textcolor: Colors.black,
                        fontsize: 14.0,
                        iconsize: 18.0,
                        iconname: itemData.active_subscription_plan_name,
                        showIcon: true,
                      ) */
                      ,
                    ),
                    MyCustomRatingView(
                      starSize: 12.0,
                      ratinigValue: itemData.averageRating == null
                          ? 0.0
                          : double.parse(itemData.averageRating.toString()),
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
