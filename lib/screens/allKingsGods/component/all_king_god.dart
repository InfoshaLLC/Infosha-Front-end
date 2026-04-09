import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_state_city/models/country.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/screens/allKingsGods/controller/god_king_model.dart';
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:infosha/views/widgets/locked_widget.dart';
import 'package:provider/provider.dart';
import 'package:country_state_city/country_state_city.dart' as country;

class GodKingUsers extends StatefulWidget {
  const GodKingUsers({super.key});

  @override
  State<GodKingUsers> createState() => _GodKingUsersState();
}

class _GodKingUsersState extends State<GodKingUsers> {
  int index = 0;
  late AllKingGodModel provider;
  ScrollController kingListControlle = ScrollController();
  ScrollController godListControlle = ScrollController();
  int kingPage = 1, godPage = 1;
  bool isGodLoading = false;
  bool isKingoading = false;

  @override
  void initState() {
    provider = Provider.of<AllKingGodModel>(context, listen: false);

    Future.microtask(
        () => context.read<AllKingGodModel>().selectedCountry = Country(
              name: "Country",
              isoCode: "isoCode",
              phoneCode: "phoneCode",
              flag: "flag",
              currency: "currency",
              latitude: "latitude",
              longitude: "longitude",
            ));
    Future.microtask(() => context.read<AllKingGodModel>().fetchCountry());
    Future.microtask(() => context.read<AllKingGodModel>().getGodList());
    Future.microtask(() => context.read<AllKingGodModel>().getKingList());

    // kingListControlle.addListener(_scrollListenerKing);
    godListControlle.addListener(_scrollListenerGod);
    super.initState();
  }

  _scrollListenerKing() {
    if (kingListControlle.offset ==
            kingListControlle.position.maxScrollExtent &&
        isKingoading == false) {
      setState(() {
        isKingoading = true;
      });
      kingPage += 1;
      provider.getMoreKingList(kingPage).then((value) {
        setState(() {
          isKingoading = false;
        });
      });
    }
  }

  _scrollListenerGod() {
    if (godListControlle.offset == godListControlle.position.maxScrollExtent &&
        isGodLoading == false) {
      setState(() {
        isGodLoading = true;
      });
      godPage += 1;
      provider.getMoreGodList(godPage).then((value) {
        setState(() {
          isGodLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              text: "View Gods and Kings User",
              color: Colors.black,
              fontSize: 18.0,
              weight: fontWeightMedium,
            )),
        body: Consumer<AllKingGodModel>(builder: (context, provider, child) {
          return provider.isGodLoading || provider.isKingLoading
              ? const Center(child: CircularProgressIndicator(color: baseColor))
              : DefaultTabController(
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
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.black12))),
                              child: TabBar(
                                onTap: (value) {
                                  index = value;
                                },
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorColor: const Color(0xFF1B2870),
                                labelPadding: const EdgeInsets.all(5),
                                indicatorPadding:
                                    const EdgeInsets.only(top: 15),
                                padding: const EdgeInsets.only(top: 10),
                                indicatorWeight: 2.5,
                                labelColor: primaryColor,
                                labelStyle: textStyleWorkSense(
                                    fontSize: 13.0, weight: fontWeightSemiBold),
                                unselectedLabelColor: Colors.black,
                                unselectedLabelStyle: textStyleWorkSense(
                                    fontSize: 13.0,
                                    color: Colors.black,
                                    weight: fontWeightMedium),
                                tabs: [
                                  Text(
                                    "Gods User".tr,
                                  ),
                                  Text(
                                    "Kings User".tr,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    body: TabBarView(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            filterTag(),
                            UIHelper.verticalSpaceSm,
                            if (provider.godListModel.data != null) ...[
                              provider.godListModel.data!.data!.isEmpty
                                  ? SizedBox(
                                      height: Get.height * 0.6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                          controller: godListControlle,
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: provider.godListModel.data!
                                                  .data!.length +
                                              1,
                                          separatorBuilder: (context, index) =>
                                              const Divider(
                                                height: 20,
                                                thickness: 0,
                                                color: Colors.transparent,
                                              ),
                                          itemBuilder: (context, index) {
                                            if (index <
                                                provider.godListModel.data!
                                                    .data!.length) {
                                              var data = provider.godListModel
                                                  .data!.data![index];
                                              return adaptor(
                                                  context,
                                                  data.user != null
                                                      ? data.user!.username ??
                                                          ""
                                                      : "",
                                                  data.user != null
                                                      ? data.user!
                                                              .user_profession ??
                                                          "-"
                                                      : "-",
                                                  data.user != null
                                                      ? data.user!.number ?? ""
                                                      : "",
                                                  data.user != null
                                                      ? data.user!
                                                              .profile_url ??
                                                          ""
                                                      : "",
                                                  index,
                                                  data.userId.toString(),
                                                  data.user != null
                                                      ? data.user!.followersCount !=
                                                              null
                                                          ? data.user!
                                                              .followersCount
                                                              .toString()
                                                          : "0"
                                                      : "0",
                                                  data.user != null
                                                      ? data.user!.activeSubscriptionPlanName !=
                                                              null
                                                          ? data.user!
                                                              .activeSubscriptionPlanName!
                                                          : ""
                                                      : "",
                                                  (data.isLocked != null &&
                                                      data.isLocked == true));
                                            } else if (isGodLoading) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: baseColor),
                                              );
                                            }
                                          }),
                                    )
                            ],
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            filterTag(),
                            UIHelper.verticalSpaceSm,
                            if (provider.kingListModel.data != null) ...[
                              provider.kingListModel.data!.data!.isEmpty
                                  ? SizedBox(
                                      height: Get.height * 0.6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      child: NotificationListener<
                                          ScrollNotification>(
                                        onNotification:
                                            (ScrollNotification notification) {
                                          if (notification
                                              is ScrollUpdateNotification) {
                                            if (notification.metrics.pixels ==
                                                notification
                                                    .metrics.maxScrollExtent) {
                                              setState(() {
                                                isKingoading = true;
                                              });
                                              kingListControlle.animateTo(
                                                kingListControlle
                                                    .position.maxScrollExtent,
                                                duration: const Duration(
                                                    milliseconds: 100),
                                                curve: Curves.easeInOut,
                                              );
                                              kingPage += 1;
                                              provider
                                                  .getMoreKingList(kingPage)
                                                  .then((value) {
                                                setState(() {
                                                  isKingoading = false;
                                                });
                                              });
                                            }
                                          }
                                          return true;
                                        },
                                        child: ListView.separated(
                                          controller: kingListControlle,
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: provider.kingListModel
                                                  .data!.data!.length +
                                              1,
                                          separatorBuilder: (context, index) =>
                                              const Divider(
                                            height: 20,
                                            thickness: 0,
                                            color: Colors.transparent,
                                          ),
                                          itemBuilder: (context, index) {
                                            if (index <
                                                provider.kingListModel.data!
                                                    .data!.length) {
                                              var data = provider.kingListModel
                                                  .data!.data![index];
                                              return adaptor(
                                                  context,
                                                  data.user != null
                                                      ? data.user!.username ??
                                                          ""
                                                      : "",
                                                  data.user != null
                                                      ? data.user!
                                                              .user_profession ??
                                                          "-"
                                                      : "-",
                                                  data.user != null
                                                      ? data.user!.number ?? ""
                                                      : "",
                                                  data.user != null
                                                      ? data.user!
                                                              .profile_url ??
                                                          ""
                                                      : "",
                                                  index,
                                                  data.userId.toString(),
                                                  data.user != null
                                                      ? data.user!.followersCount !=
                                                              null
                                                          ? data.user!
                                                              .followersCount
                                                              .toString()
                                                          : "0"
                                                      : "0",
                                                  data.user != null
                                                      ? data.user!.activeSubscriptionPlanName !=
                                                              null
                                                          ? data.user!
                                                              .activeSubscriptionPlanName!
                                                          : ""
                                                      : "",
                                                  (data.isLocked != null &&
                                                      data.isLocked == true));
                                            } else if (isKingoading) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: baseColor),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    )
                            ],
                          ],
                        )
                      ],
                    ),
                  ),
                );
        }));
  }

  filterTag() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              height: Get.height * 0.052,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: PopupMenuButton<country.Country>(
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
                    provider
                        .getKingList()
                        .then((value) => provider.getGodList());
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

              provider.selectedCountry = country.Country(
                  name: "Country",
                  isoCode: "isoCode",
                  phoneCode: "phoneCode",
                  flag: "flag",
                  currency: "currency",
                  latitude: "latitude",
                  longitude: "longitude");
              provider.getKingList().then((value) => provider.getGodList());
            });
          },
          child: Container(
            height: Get.height * 0.051,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: provider.worldWide
                  ? const Color(0xFFAAEDFF)
                  : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: provider.worldWide
                    ? Colors.transparent
                    : const Color(0xFF767680),
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
        Expanded(child: Container())
      ],
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

  adaptor(
      BuildContext context,
      String name,
      String profession,
      String number,
      String image,
      int index,
      String id,
      String followersCount,
      String plan,
      bool isLocked) {
    return InkWell(
      onTap: () {
        Get.to(() => ViewProfileScreen(id: id));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: lightGrey),
              child: Column(
                children: [
                  ListTile(
                    leading: SizedBox(
                      width: Get.width * 0.1,
                      height: Get.height * 0.05,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: image.isEmpty ||
                                image == "https://via.placeholder.com/150"
                            ? Image.asset('images/aysha.png')
                            : isBase64(image)
                                ? Image.memory(base64.decode(image),
                                    fit: BoxFit.cover)
                                : CachedNetworkImage(
                                    imageUrl: image,
                                    fit: BoxFit.fill,
                                    errorWidget: (context, url, error) =>
                                        Image.asset('images/aysha.png'),
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                          color: baseColor),
                                    ),
                                  ),
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        profession,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFFABAAB4)),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: Get.width * 0.23, minWidth: 1),
                              child: CustomText(
                                text: name,
                                color: Colors.black,
                                fontSize: 16,
                                weight: fontWeightSemiBold,
                              ),
                            ),
                            UIHelper.horizontalSpaceSm,
                            if (plan.isNotEmpty) ...[
                              Image.asset(
                                plan.contains("lord")
                                    ? APPICONS.lordicon
                                    : plan.contains("god")
                                        ? APPICONS.godstatuspng
                                        : APPICONS.kingstutspicpng,
                                height: 20,
                              ),
                            ],
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.verified,
                              color: Color(0xFF007EFF),
                              size: 18,
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(number),
                          ],
                        ),
                      ],
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$followersCount ",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Followers".tr,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLocked) ...[LockWidget()]
          ],
        ),
      ),
    );
  }
}
