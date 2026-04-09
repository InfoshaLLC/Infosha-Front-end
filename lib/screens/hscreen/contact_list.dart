import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:infosha/utils/error_boundary.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../Controller/models/contact_model.dart';
import 'package:infosha/views/full_screen_image.dart';
import 'package:infosha/views/widgets/dot_loader.dart';
import 'package:infosha/views/widgets/rating_view.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/home/SectonView/section_view.dart';
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';
import 'package:infosha/screens/viewUnregistered/component/view_unregistered_user.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
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
            text: 'Contacts',
            color: Colors.black,
            weight: fontWeightMedium,
            fontSize: 18.0,
          ),
        ),
        body: Container(
          height: Get.height,
          padding: const EdgeInsets.only(left: 10),
          child: Consumer<UserViewModel>(builder: (context, provider, child) {
            return Obx(() => provider.isLoadingContact.value
                ?
                // const Center(
                //     child: CircularProgressIndicator(
                //       color: baseColor,
                //     ),
                //   )

                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: Center(
                      child: DancingDotsLoader(),
                    ),
                  )
                : SectionView<AlphabetHeader<MapEntry<String, List<ContactModel>>>, ContactModel>(
                    source: convertListToAlphaHeader(
                        provider.groupedListContactsModel.entries.map((e) => e).where((element) {
                          return element.key != "" && isWellFormedUTF16(element.key) && element.key.toString() != "�";
                        }),
                        (item) => item.key != "" && isWellFormedUTF16(item.key) && item.key.toString() != "�"
                            ? (item.key).substring(0, 1).toUpperCase()
                            : ""),
                    onFetchListData: (value) {
                      return value.items.isNotEmpty ? value.items.first.value : [];
                    },

                    onChange: (value) {
                      // if (value > 0) {
                      //   scrollController.animateTo(selectedHeaderTextHeight,
                      //       duration: Duration(milliseconds: 1), curve: Curves.ease);
                      // } else {
                      //   scrollController.animateTo(-selectedHeaderTextHeight,
                      //       duration: Duration(milliseconds: 1), curve: Curves.ease);
                      // }
                    },

                    // headerBuilder:
                    //     getDefaultHeaderBuilder(
                    //         (d) => d.alphabet),
                    headerBuilder: (context, list, index) {
                      return Container(
                        height: 50.0,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: Get.width,
                          child: Row(
                            children: [
                              CustomText(
                                text: list.alphabet,
                                fontSize: 22.0,
                                color: Colors.black,
                                weight: fontWeightExtraBold,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    alphabetInset: const EdgeInsets.only(left: 10),

                    alphabetBuilder: getDefaultAlphabetBuilder((d) {
                      return d.alphabet;
                    }),

                    tipBuilder: getDefaultTipBuilder((d) => d.alphabet),
                    itemBuilder: (context, day, itemIndex, headerData, headerIndex) {
                      String country = day.code!;
                      String coutnryflag = "";

                      if (RegExp(r'\d').hasMatch(country)) {
                        coutnryflag =
                            "images/flags/${CountryPickerUtils.getCountryByPhoneCode(country.replaceAll("+", "")).isoCode.toLowerCase()}.png";
                      } else {
                        coutnryflag = country.toLowerCase() != "" ? "images/flags/${country.toLowerCase()}.png" : "";
                      }
                      return GestureDetector(
                        onTap: () {
                          if (day.isFriend != null && day.isFriend.toString() == "1") {
                            Get.to(() => ViewProfileScreen(id: day.userId.toString()));
                          } else {
                            Get.to(() => ViewUnregisteredUser(
                                contactId: day.id.toString(), id: day.number.toString(), isOther: false));
                          }
                        },
                        child: adaptor(day, itemIndex, coutnryflag, provider, country),
                      );
                    },
                  ));
            // );
          }),
        ),
      ),
    );
  }

  Widget userProfilePhoto(ContactModel day, double radius, itemIndex, country) {
    return InkWell(
      onTap: () {
        ///used to view profile image in full screen
        Get.to(() => FullScreenImage(
              image: "",
              name: day.name ?? "NA",
              isBase64: day.photo != null && day.photo!.isNotEmpty && day.photo!.contains("dummyimage") == false,
              base64Data: base64Decode(day.photo!),
            ));
      },
      child: day.photo != null && day.photo!.isNotEmpty && day.photo!.contains("dummyimage") == false
          ? CircleAvatar(
              backgroundImage: MemoryImage(base64Decode(day.photo!)),
              radius: radius,
            )
          : country != ""
              ? CircleAvatar(
                  backgroundImage: AssetImage(country),
                  radius: radius,
                  backgroundColor: Colors.white,
                )
              : CircleAvatar(
                  radius: radius,
                  backgroundColor: Colors.white,
                  child: CustomText(
                    text: UIHelper.getShortName(string: day.name, limitTo: 2),
                    fontSize: 20.0,
                    color: whiteColor,
                    weight: fontWeightMedium,
                  ),
                ),
    );
  }

  adaptor(ContactModel day, int itemIndex, String coutnryflag, UserViewModel provider, String country) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          userProfilePhoto(day, 33.0, itemIndex, coutnryflag),
          UIHelper.horizontalSpaceSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: day.profession ?? "",
                  weight: fontWeightMedium,
                  fontSize: 12.0,
                  color: const Color(0xffABAAB4),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    SizedBox(
                      width: day.isFriend != null && day.isFriend == 1 ? Get.width * 0.42 : Get.width * 0.51,
                      child: AutoSizeText(
                        day.name != null
                            ? day.name!.contains(";")
                                ? day.name!.split(';')[0].trim()
                                : day.name ?? ""
                            : "",
                        textAlign: TextAlign.start,
                        maxFontSize: 17.0,
                        minFontSize: 15,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textStyleWorkSense(weight: fontWeightMedium),
                      ),
                    ),
                    day.isFriend != null && day.isFriend == 1
                        ? MyCustomRatingView(
                            starSize: 15.0,
                            ratinigValue: day.average_rating != null ? double.parse(day.average_rating.toString()) : 0,
                            padding: 0.0,
                            fontsize: 12.0,
                          )
                        : InkWell(
                            onTap: () async {
                              Uri uri = Uri.parse(
                                  'sms:${day.number}?body=Welcome to Infosha, Please download app from https://play.google.com/store/apps/details?id=com.ktech.infosha');

                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else {
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  throw 'Could not launch $uri';
                                }
                              }
                            },
                            child: Container(
                              // height: 30.0,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: const Color(0xFfAAEDFF), borderRadius: BorderRadius.circular(22)),
                              child: Center(
                                  child: Text(
                                "Invite",
                                style: GoogleFonts.workSans(fontWeight: FontWeight.w500, fontSize: 17),
                              )),
                            ),
                          )
                  ],
                ),
                UIHelper.verticalSpaceSm1,
                Row(
                  children: [
                    coutnryflag == ""
                        ? const SizedBox.shrink()
                        : Image.asset(
                            coutnryflag,
                            width: 15,
                          ),
                    UIHelper.horizontalSpace3m,
                    day.number != ""
                        ? CustomText(
                            text: day.number ?? "",
                            color: const Color(0xffABAAB4),
                            fontSize: 14.0,
                          )
                        : Container(),
                    UIHelper.horizontalSpaceSm,
                    if (day.activeSubscriptionPlanName != null) ...[
                      Image.asset(
                        day.activeSubscriptionPlanName.contains("lord")
                            ? APPICONS.lordicon
                            : day.activeSubscriptionPlanName.contains("god")
                                ? APPICONS.godstatuspng
                                : APPICONS.kingstutspicpng,
                        width: 16.0,
                      ),
                      const SizedBox(width: 5),
                    ],
                    if (day.isFriend != null && day.isFriend.toString() == "1") ...[
                      const Icon(
                        Icons.verified,
                        color: Color(0xFF007EFF),
                        size: 18,
                      )
                    ],
                  ],
                ),
                CustomText(
                  text: country.toString(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
