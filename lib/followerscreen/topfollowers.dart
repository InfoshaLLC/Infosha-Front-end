import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_state_city/country_state_city.dart' as con;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/followerscreen/controller/topfollowers_model.dart';
import 'package:infosha/followerscreen/model/top_followers_model.dart';
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';
import 'package:infosha/screens/viewUnregistered/component/view_unregistered_user.dart';
import 'package:infosha/utils/error_boundary.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/full_screen_image.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:infosha/views/widgets/common_dialog_with_button.dart';
import 'package:infosha/views/widgets/locked_widget.dart';
import 'package:provider/provider.dart';

class TopFollowersScreen extends StatefulWidget {
  TopFollowersScreen({super.key});

  @override
  State<TopFollowersScreen> createState() => _TopFollowersScreenState();
}

class _TopFollowersScreenState extends State<TopFollowersScreen> {
  late TopFollowVisitorModel provider;
  int index = 0;

  @override
  void initState() {
    provider = Provider.of<TopFollowVisitorModel>(context, listen: false);

    Provider.of<TopFollowVisitorModel>(context, listen: false).setInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAdsDialog();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          child: CommonDialogButton(
            title: "See rewarded ad to view top 100",
            buttonTitleNo: "Exit",
            buttonTitleYes: "See Ads",
          ),
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
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: CustomText(
            text: "Top 100",
            color: Colors.black,
            fontSize: 18.0,
            weight: fontWeightMedium,
          ),
        ),
        body: Consumer<TopFollowVisitorModel>(builder: (context, provider, child) {
          /* if (provider.topFollowersModel.data != null &&
              provider.topFollowersModel.data!.isNotEmpty) {
            for (var data in provider.topFollowersModel.data ?? []) {
              precacheImage(
                  CachedNetworkImageProvider(
                    data.profile ?? "",
                  ),
                  context);
            }
          }

          if (provider.topVisitorsModel.data != null &&
              provider.topVisitorsModel.data!.isNotEmpty) {
            for (var data in provider.topVisitorsModel.data ?? []) {
              precacheImage(
                  CachedNetworkImageProvider(
                    data.profile ?? "",
                  ),
                  context);
            }
          } */
          return DefaultTabController(
            initialIndex: index,
            length: 2,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(Get.height * 0.09),
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 60,
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
                        child: TabBar(
                          onTap: (value) {
                            index = value;
                          },
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: const Color(0xFF1B2870),
                          labelPadding: const EdgeInsets.all(5),
                          indicatorPadding: const EdgeInsets.only(top: 15),
                          padding: const EdgeInsets.only(top: 10),
                          indicatorWeight: 2.5,
                          labelColor: primaryColor,
                          labelStyle: textStyleWorkSense(fontSize: 13.0, weight: fontWeightSemiBold),
                          unselectedLabelColor: Colors.black,
                          unselectedLabelStyle: textStyleWorkSense(fontSize: 13.0, color: Colors.black, weight: fontWeightMedium),
                          tabs: [
                            Text(
                              "Most Followers".tr,
                            ),
                            Text(
                              "Most Visited".tr,
                            ),
                            /* Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  provider.visitType,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                PopupMenuButton<int>(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 0,
                                      child: Text("Unique Visit".tr),
                                      onTap: () async {
                                        setState(() {
                                          provider.changeType("Unique Visit");
                                        });
                                      },
                                    ),
                                    PopupMenuItem(
                                      value: 1,
                                      child: Text("Non Unique Visit".tr),
                                      onTap: () async {
                                        setState(() {
                                          provider
                                              .changeType("Non Unique Visit");
                                        });
                                      },
                                    ),
                                  ],
                                  onSelected: (value) {},
                                  offset: const Offset(0, 0),
                                  elevation: 2,
                                  child: Icon(Icons.arrow_drop_down,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ), */
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  provider.isTopFollowers
                      ? ValueListenableBuilder(
                          valueListenable: provider.progressFollower,
                          builder: (context, value, child) {
                            return Center(
                              child: SizedBox(
                                width: Get.width * 0.3,
                                height: Get.height * 0.14,
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.3,
                                      height: Get.height * 0.14,
                                      child: CircularProgressIndicator(
                                        strokeCap: StrokeCap.round,
                                        strokeWidth: 8,
                                        color: baseColor,
                                        value: provider.progressFollower.value,
                                        backgroundColor: baseColor.withOpacity(0.2),
                                      ),
                                    ),
                                    Align(
                                      child: Text(
                                        "${(provider.progressFollower.value * 100).round()}%",
                                        style: const TextStyle(color: baseColor, fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Column(
                          children: <Widget>[
                            filterTag(),
                            UIHelper.verticalSpaceSm,
                            if (provider.topFollowersModel.data != null) ...[
                              provider.topFollowersModel.data!.isEmpty
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
                                      child: /* SingleChildScrollView(
                                        child: Column(
                                            children: List.generate(
                                          provider
                                              .topFollowersModel.data!.length,
                                          (index) {
                                            var data = provider
                                                .topFollowersModel.data![index];
                                            return Column(
                                              children: [
                                                adaptor(context, data, index),
                                                const Divider(
                                                  height: 20,
                                                  thickness: 0,
                                                  color: Colors.transparent,
                                                ),
                                              ],
                                            );
                                          },
                                        )) */
                                          ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: provider.topFollowersModel.data!.length,
                                      separatorBuilder: (context, index) => const Divider(
                                        height: 20,
                                        thickness: 0,
                                        color: Colors.transparent,
                                      ),
                                      itemBuilder: (context, index) {
                                        var data = provider.topFollowersModel.data![index];
                                        return adaptor(context, data, index);
                                      },
                                    ))
                            ],
                          ],
                        ),
                  provider.isTopVisitor
                      ? ValueListenableBuilder(
                          valueListenable: provider.progressVisitor,
                          builder: (context, value, child) {
                            return Center(
                                child: SizedBox(
                              width: Get.width * 0.3,
                              height: Get.height * 0.14,
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.3,
                                    height: Get.height * 0.14,
                                    child: CircularProgressIndicator(
                                      strokeCap: StrokeCap.round,
                                      strokeWidth: 8,
                                      color: baseColor,
                                      value: provider.progressVisitor.value,
                                      backgroundColor: baseColor.withOpacity(0.2),
                                    ),
                                  ),
                                  Align(
                                    child: Text(
                                      "${(provider.progressVisitor.value * 100).round()}%",
                                      style: const TextStyle(color: baseColor, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ));
                          })
                      : Column(
                          children: <Widget>[
                            filterTag(),
                            UIHelper.verticalSpaceSm,
                            if (provider.topVisitorsModel.data != null) ...[
                              provider.topVisitorsModel.data!.isEmpty
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
                                  : /* Expanded(
                                      child: SingleChildScrollView(
                                          child: Column(
                                              children: List.generate(
                                      provider.topVisitorsModel.data!.length,
                                      (index) {
                                        var data = provider
                                            .topVisitorsModel.data![index];
                                        return Column(
                                          children: [
                                            adaptorVisitor(
                                                context,
                                                data.name ?? "",
                                                data.profession ?? "-",
                                                data.number ?? "",
                                                data.country != null &&
                                                        data.country != ""
                                                    ? data.country ?? ""
                                                    : "",
                                                data.city != null &&
                                                        data.city != ""
                                                    ? data.city ?? ""
                                                    : "",
                                                data.profile != null
                                                    ? data.profile ?? ""
                                                    : "",
                                                index,
                                                data.id.toString(),
                                                data.followersCount == null
                                                    ? "0"
                                                    : data.followersCount
                                                        .toString(),
                                                data.isFriend == 1
                                                    ? true
                                                    : false,
                                                data.isSubscriptionActive !=
                                                        null
                                                    ? true
                                                    : false,
                                                data.activeSubscriptionPlanName ??
                                                    "null",
                                                data.visitsCount ?? 1,
                                                (data.isLocked != null &&
                                                    data.isLocked == true)),
                                            const Divider(
                                              height: 20,
                                              thickness: 0,
                                              color: Colors.transparent,
                                            ),
                                          ],
                                        );
                                      },
                                    )))) */
                                  Expanded(
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: provider.topVisitorsModel.data!.length,
                                        separatorBuilder: (context, index) => const Divider(
                                          height: 20,
                                          thickness: 0,
                                          color: Colors.transparent,
                                        ),
                                        itemBuilder: (context, index) {
                                          var data = provider.topVisitorsModel.data![index];
                                          return adaptorVisitor(
                                              context,
                                              data.name ?? "",
                                              data.profession ?? "-",
                                              data.number ?? "",
                                              data.country != null && data.country != "" ? data.country ?? "" : "",
                                              data.city != null && data.city != "" ? data.city ?? "" : "",
                                              data.profile != null ? data.profile ?? "" : "",
                                              index,
                                              data.id.toString(),
                                              data.followersCount == null ? "0" : data.followersCount.toString(),
                                              data.isFriend == 1 ? true : false,
                                              data.isSubscriptionActive != null ? true : false,
                                              data.activeSubscriptionPlanName ?? "null",
                                              data.visitsCount ?? 1,
                                              (data.isLocked != null && data.isLocked == true));
                                        },
                                      ),
                                    )
                            ],
                          ],
                        )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget adaptorVisitor(BuildContext context, String name, String profession, String number, String country, String city, String image, int index,
      String id, String followersCount, bool isFriend, bool isActive, String planName, int count, bool isLocked) {
    return InkWell(
      onTap: () {
        if (isFriend) {
          Get.to(() => ViewProfileScreen(id: id));
        } else {
          Get.to(() => ViewUnregisteredUser(contactId: number, id: number, isOther: false));
        }
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                Container(
                  //  height: 140,
                  padding: const EdgeInsets.only(top: 15, bottom: 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: lightGrey),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => FullScreenImage(
                                    image: image.isEmpty || image == "https://via.placeholder.com/150" ? "" : image,
                                    name: name,
                                    isBase64: isBase64(image),
                                    base64Data: isBase64(image) ? base64Decode(image) : null,
                                    showDefault: image.isEmpty || image == "https://via.placeholder.com/150",
                                  ));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(Get.height * 0.054),
                                  child: image.isEmpty || image == "https://via.placeholder.com/150"
                                      ? Image.asset('images/aysha.png')
                                      : isBase64(image)
                                          ? Image.memory(
                                              base64.decode(image),
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: image,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) => Image.asset('images/aysha.png'),
                                              placeholder: (context, url) => const Center(
                                                child: CircularProgressIndicator(color: baseColor),
                                              ),
                                            ),
                                ),
                              ),
                            ) /* Container(
                              margin: const EdgeInsets.only(left: 10),
                              width: Get.width * 0.225,
                              height: Get.height * 0.11,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: image.isEmpty ||
                                        image == "https://via.placeholder.com/150"
                                    ? Image.asset('images/aysha.png')
                                    : isBase64(image)
                                        ? Image.memory(
                                            base64.decode(image),
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: image,
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url, error) =>
                                                Image.asset('images/aysha.png'),
                                            placeholder: (context, url) =>
                                                const Center(
                                              child: CircularProgressIndicator(
                                                  color: baseColor),
                                            ),
                                          ),
                              ),
                            ) */
                            ,
                          ),
                          Expanded(
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  profession,
                                  style: const TextStyle(fontSize: 12, color: Color(0xFFABAAB4)),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: Get.width,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "$followersCount ",
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Followers".tr,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(minWidth: 0, maxWidth: Get.width * 0.42),
                                        child: CustomText(
                                          text: name.contains(';')
                                              ? name.split(';').isEmpty
                                                  ? name
                                                  : name.split(';').first
                                              : name,
                                          color: Colors.black,
                                          fontSize: 16,
                                          weight: fontWeightSemiBold,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      if (isFriend) ...[
                                        const Icon(
                                          Icons.verified,
                                          color: Color(0xFF007EFF),
                                          size: 18,
                                        )
                                      ],
                                      if (planName != "null") ...[
                                        Image.asset(
                                          planName.contains("lord")
                                              ? APPICONS.lordicon
                                              : planName.contains("god")
                                                  ? APPICONS.godstatuspng
                                                  : APPICONS.kingstutspicpng,
                                          width: 16.0,
                                        ),
                                        const SizedBox(width: 5),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [Text("${"Visits".tr}: "), Text("$count")],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(color: Colors.black26),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 75),
                        child: Row(
                          children: [
                            if ((city.isNotEmpty && city != "null") || (country.isNotEmpty && country != "null")) ...[
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey,
                                size: 16,
                              ),
                              Row(
                                children: [
                                  if (city.isNotEmpty) ...[Text(' $city, ')],
                                  Text(country.isEmpty || country == "null" ? "" : country),
                                ],
                              )
                            ],
                            const SizedBox(width: 5),
                            /* if (country.isNotEmpty && country != "null") ...[
                              SizedBox(
                                height: Get.height * 0.02,
                                width: Get.width * 0.04,
                                child: CountryPickerUtils.getDefaultFlagImage(
                                    CountryPickerUtils.getCountryByName(
                                        country.isEmpty
                                            ? "United States"
                                            : country)),
                              )
                            ], */
                          ],
                        ),
                      ),
                      UIHelper.verticalSpaceSm,
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 25,
                      width: 50,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                          ),
                          color: Color(0xFF1B2870)
                          // .withOpacity(1.0 - (index * 0.02)),
                          ),
                      child: Center(
                        child: Text(
                          "#${index + 1}",
                          style: const TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          if (isLocked) ...[LockWidget()]
        ],
      ),
    );
  }

  adaptor(BuildContext context, Data data, int index) {
    return InkWell(
      onTap: () {
        if (data.is_friend != null && data.is_friend != 0) {
          if (data.isLocked != null && data.isLocked == false) {
            Get.to(() => ViewProfileScreen(id: data.user_id.toString()));
          }
        } else {
          if (data.isLocked != null && data.isLocked == false) {
            Get.to(() => ViewUnregisteredUser(contactId: data.number!, id: data.number!, isOther: false));
          }
        }
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                Container(
                  //  height: 140,
                  padding: const EdgeInsets.only(top: 15, bottom: 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: lightGrey),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => FullScreenImage(
                                  image: data.profile == null || data.profile!.isEmpty || data.profile == "https://via.placeholder.com/150"
                                      ? ""
                                      : data.profile ?? "",
                                  name: data.username ?? "",
                                  isBase64: data.profile != null ? isBase64(data.profile!) : null,
                                  base64Data: data.profile != null
                                      ? isBase64(data.profile!)
                                          ? base64Decode(data.profile!)
                                          : null
                                      : null,
                                  showDefault: data.profile == null || data.profile!.isEmpty || data.profile! == "https://via.placeholder.com/150",
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(Get.height * 0.054),
                                  child: data.profile == null || data.profile!.isEmpty || data.profile! == "https://via.placeholder.com/150"
                                      ? Image.asset('images/aysha.png')
                                      : isBase64(data.profile!)
                                          ? Image.memory(
                                              base64.decode(data.profile!),
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: data.profile!,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) => Image.asset('images/aysha.png'),
                                              placeholder: (context, url) => const Center(
                                                child: CircularProgressIndicator(color: baseColor),
                                              ),
                                            ),
                                ),
                              ),
                            ) /* Container(
                              margin: const EdgeInsets.only(left: 10),
                              width: Get.width * 0.225,
                              height: Get.height * 0.11,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: data.profile == null ||
                                        data.profile!.isEmpty ||
                                        data.profile! ==
                                            "https://via.placeholder.com/150"
                                    ? Image.asset('images/aysha.png')
                                    : isBase64(data.profile!)
                                        ? Image.memory(
                                            base64.decode(data.profile!),
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: data.profile!,
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url, error) =>
                                                Image.asset('images/aysha.png'),
                                            placeholder: (context, url) =>
                                                const Center(
                                              child: CircularProgressIndicator(
                                                  color: baseColor),
                                            ),
                                          ),
                              ),
                            ) */
                            ,
                          ),
                          Expanded(
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  data.profession ?? "",
                                  style: const TextStyle(fontSize: 12, color: Color(0xFFABAAB4)),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: Get.width,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "${data.followersCount} ",
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Followers".tr,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(minWidth: 0, maxWidth: Get.width * 0.48),
                                        child: CustomText(
                                          text: data.username!.contains(';')
                                              ? data.username!.split(';').isEmpty
                                                  ? data.username!
                                                  : data.username!.split(';').first
                                              : data.username!,
                                          color: Colors.black,
                                          fontSize: 16,
                                          weight: fontWeightSemiBold,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      if (data.is_friend != null && data.is_friend != 0) ...[
                                        const Icon(
                                          Icons.verified,
                                          color: Color(0xFF007EFF),
                                          size: 18,
                                        )
                                      ],
                                      if (data.activeSubscriptionPlanName != null) ...[
                                        Image.asset(
                                          data.activeSubscriptionPlanName.contains("lord")
                                              ? APPICONS.lordicon
                                              : data.activeSubscriptionPlanName.contains("god")
                                                  ? APPICONS.godstatuspng
                                                  : APPICONS.kingstutspicpng,
                                          width: 16.0,
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(color: Colors.black26),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 70),
                        child: Row(
                          children: [
                            if (data.country != null) ...[
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey,
                                size: 16,
                              ),
                              Row(
                                children: [
                                  /* if (data.city != null) ...[
                                    Text(' ${data.country!.city}, ')
                                  ], */
                                  Text("${data.country!.country}"),
                                ],
                              )
                            ],
                            const SizedBox(width: 5),
                            /* if (country.isNotEmpty) ...[
                              SizedBox(
                                height: Get.height * 0.02,
                                width: Get.width * 0.04,
                                child: CountryPickerUtils.getDefaultFlagImage(
                                    CountryPickerUtils.getCountryByName(
                                        country.isEmpty
                                            ? "United States"
                                            : country)),
                              )
                            ], */
                          ],
                        ),
                      ),
                      UIHelper.verticalSpaceSm,
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 25,
                      width: 50,
                      decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(20)), color: const Color(0xFF1B2870)
                          /* .withOpacity(1.0 - (index * 0.02)), */
                          ),
                      child: Center(
                        child: Text(
                          "#${index + 1}",
                          style: const TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          if (data.isLocked != null && data.isLocked == true) ...[LockWidget()]
        ],
      ),
    );
  }

  filterTag() {
    return SizedBox(
      height: Get.height * 0.052,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: Get.height * 0.052,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: PopupMenuButton(
                  itemBuilder: (context) {
                    return provider.countryList.map((str) {
                      return PopupMenuItem(
                        value: str,
                        textStyle: GoogleFonts.workSans(
                          color: const Color(0xFf46464F),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        child: Text(
                          str.name,
                          style: GoogleFonts.workSans(
                            color: const Color(0xFf46464F),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  onSelected: (value) {
                    setState(() {
                      provider.selectedCountry = value;
                      if (provider.selectedCountry.name != "Country") {
                        provider.worldWide = false;
                      }
                      provider.fetchTopFollowers();
                      provider.fetchTopVisitors();
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(width: Get.width * 0.01),
                      Text(
                        provider.selectedCountry.name.toString(),
                        style: GoogleFonts.workSans(
                          color: const Color(0xFf46464F),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                )),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                provider.worldWide = !provider.worldWide;
                provider.selectedCountry = con.Country(
                    name: "Country",
                    isoCode: "isoCode",
                    phoneCode: "phoneCode",
                    flag: "flag",
                    currency: "currency",
                    latitude: "latitude",
                    longitude: "longitude");
                if (index == 0) {
                  provider.fetchTopFollowers().then((value) => provider.fetchTopVisitors());
                } else {
                  provider.fetchTopVisitors().then((value) => provider.fetchTopFollowers());
                }
              });
            },
            child: Container(
              height: Get.height * 0.051,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: provider.worldWide ? const Color(0xFFAAEDFF) : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: provider.worldWide ? Colors.transparent : const Color(0xFF767680),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (provider.worldWide) ...[
                      const Icon(Icons.done),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      "Worldwide".tr,
                      style: GoogleFonts.workSans(
                        color: const Color(0xFf46464F),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: Get.height * 0.052,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: PopupMenuButton(
                  itemBuilder: (context) {
                    return provider.categoryList.map((str) {
                      return PopupMenuItem(
                        value: str,
                        textStyle: GoogleFonts.workSans(
                          color: const Color(0xFf46464F),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        child: Text(
                          str.categoryName ?? "",
                          style: GoogleFonts.workSans(
                            color: const Color(0xFf46464F),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  onSelected: (value) {
                    setState(() {
                      provider.selectedCategory = value;
                      provider.fetchTopFollowers();
                      provider.fetchTopVisitors();
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(width: Get.width * 0.01),
                      Text(
                        provider.selectedCategory.categoryName ?? "",
                        style: GoogleFonts.workSans(
                          color: const Color(0xFf46464F),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                )),
          ),
        ],
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

Widget ListTilewidget(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: Container(
      height: 140,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 25,
                width: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
                  color: Color(0xFF1B2870),
                ),
                child: const Center(
                  child: Text(
                    "#1",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            leading: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  radius: 22,
                  child: Image(
                    filterQuality: FilterQuality.high,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    image: const AssetImage('images/aysha.png'),
                  ),
                ),
              ],
            ),
            title: const Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                "Model",
                style: TextStyle(fontSize: 12, color: Color(0xFFABAAB4)),
              ),
            ),
            subtitle: const Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Bushra Ansari",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text("+92 333 1234567"),
                  ],
                ),
              ],
            ),
            trailing: const Padding(
              padding: EdgeInsets.only(top: 17),
              child: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            " ",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Followers",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              color: Colors.black26,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 75),
            child: Row(
              children: [
                Text(
                  "Lahore,Pakistan",
                  style: TextStyle(color: Color(0xFF767680)),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
