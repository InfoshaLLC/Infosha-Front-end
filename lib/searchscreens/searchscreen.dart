import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:infosha/utils/error_boundary.dart';
import 'package:country_state_city/models/city.dart';
import 'package:infosha/views/full_screen_image.dart';
import 'package:country_state_city/models/country.dart';
import 'package:infosha/followerscreen/topfollowers.dart';
import 'package:infosha/views/widgets/locked_widget.dart';
import 'package:infosha/Controller/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:infosha/searchscreens/controller/search_model.dart';
import 'package:infosha/searchscreens/model/search_user_model.dart';
import 'package:country_state_city/country_state_city.dart' as country;
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';
import 'package:infosha/screens/subscription/component/subscription_screen.dart';
import 'package:infosha/screens/viewUnregistered/component/view_unregistered_user.dart';
// ignore_for_file: use_build_context_synchronously

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Color containerColor = Colors.white;
  double rating = 0;
  late SearchModel provider;
  bool isReveresed = false;
  ScrollController scrollController = ScrollController();
  final searchController = TextEditingController();
  bool isLoadingMoreData = false;
  int page = 1;
  late UserViewModel userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserViewModel>(context, listen: false);
    provider = Provider.of<SearchModel>(context, listen: false);
    Future.microtask(() => context.read<SearchModel>().dialogCalendarPickerValue = []);
    Future.microtask(() => context.read<SearchModel>().searchController.clear());
    Future.microtask(() => context.read<SearchModel>().getProfession());

    provider.selectedProfession = "Profession";
    provider.selectedCountry = Country(
        name: "Country",
        isoCode: "isoCode",
        phoneCode: "phoneCode",
        flag: "flag",
        currency: "currency",
        latitude: "latitude",
        longitude: "longitude");
    provider.selectedCity = City(name: "City", countryCode: "", stateCode: "");
    provider.numberofranking = false;
    provider.numberoffollowing = false;
    provider.numberoffollowers = false;

    provider.searchUserModel = SearchUserModel();
    provider.isLoading = false;
    provider.fetchCountry();

    setState(() {});

    scrollController.addListener(_getMoreData);
  }

  _getMoreData() {
    if (scrollController.offset == scrollController.position.maxScrollExtent && isLoadingMoreData == false && provider.moreData) {
      setState(() {
        isLoadingMoreData = true;
      });
      page += 1;
      provider.getMoreUser(page).then((value) {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isLoadingMoreData = false;
          });
        });
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Visibility(
              visible: false,
              child: InkWell(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopFollowersScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: CustomText(
            text: 'Search',
            color: Colors.black,
            weight: fontWeightMedium,
            fontSize: 18.0,
          ),
        ),
        body: Consumer<SearchModel>(builder: (context, provider, child) {
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                pinned: false,
                elevation: 0,
                leadingWidth: 0.0,
                leading: Container(),
                expandedHeight: Get.height * 0.38,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: headerWidget(),
                ),
              ),
              SliverToBoxAdapter(
                child: provider.isLoading
                    ? SizedBox(
                        height: Get.height * 0.35,
                        child: const Center(child: CircularProgressIndicator(color: baseColor)),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: 'search_results'.tr,
                                  color: Colors.black,
                                ),
                                const Spacer(),
                                CustomText(
                                  text: 'Sort:',
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 2),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isReveresed = !isReveresed;
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFAAEDFF),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'images/updown_icon_176660.png',
                                        height: 18,
                                        width: 18,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            UIHelper.verticalSpaceSm,
                            if (provider.searchUserModel.data == null || provider.searchUserModel.data!.data!.isEmpty) ...[
                              Card(
                                margin: const EdgeInsets.only(top: 20),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                elevation: 5,
                                child: Column(
                                  children: [
                                    Subscriptionwidget(
                                        context,
                                        "\$ 1.99",
                                        "\$ 4.99",
                                        "\$ 11.99",
                                        "King Status",
                                        APPICONS.kingstutspicpng,
                                        "images/kingstuts.png",
                                        const Color(0xFFB42F69),
                                        [
                                          "able to delete unlimited comments",
                                          "able to get notification momentarily when somebody visits their profile",
                                          "able to see which user entered what kind of information on any profile",
                                          "able to see which user enters his phone number using what nickname",
                                          "able to write an anonymous comment on anyone's profile",
                                          "no ads",
                                          "able to see review makers",
                                          "able to block unlimited users",
                                          "unlimited search results"
                                        ],
                                        false),
                                    Subscriptionwidget(
                                        context,
                                        "\$ 9.99",
                                        "\$ 24.99",
                                        "\$ 59.99",
                                        "God Status",
                                        APPICONS.godstatuspng,
                                        "images/godstuts.png",
                                        const Color(0xFFF4851F),
                                        [
                                          "able to see followers of any user",
                                          "able to see who does any user follow",
                                          "able to get notification momentarily when somebody visits their profile",
                                          "able to see which user entered what kind of information on any profile",
                                          "Who deleted a comment on thier profile",
                                          "Who visited your profile and which user visits which user's profile",
                                          "able to write an anonymous comment on anyone's profile",
                                          "no ads",
                                          "able to see the list of other King and Gods users",
                                          "able to block unlimited users",
                                          "able to delete unlimited comments",
                                          "Unlimited search results",
                                          "able to see anonymous comment poster",
                                          "able to see other users' activity, like writing a comment on someone's profile, rating them out of 5 stars or them filling in any information on other or their profile"
                                        ],
                                        false),
                                  ],
                                ),
                              )
                            ],
                            if (provider.searchUserModel.data != null)
                              ListView.separated(
                                reverse: isReveresed,
                                itemCount: provider.searchUserModel.data!.data!.length + 1,
                                shrinkWrap: true,
                                primary: false,
                                separatorBuilder: (context, index) => const SizedBox(height: 5),
                                itemBuilder: (context, index) {
                                  if (index < provider.searchUserModel.data!.data!.length) {
                                    Data data = provider.searchUserModel.data!.data![index];
                                    return InkWell(
                                      onTap: () {
                                        if (data.isFriend != null && data.isFriend != 0) {
                                          if (data.isLocked != null && data.isLocked != true) {
                                            Get.to(() => ViewProfileScreen(id: data.userId.toString()));
                                          }
                                        } else {
                                          if (data.isLocked != null && data.isLocked != true) {
                                            Get.to(() => ViewUnregisteredUser(
                                                id: data.number.toString(), contactId: data.contactId.toString(), isOther: false));
                                          }
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Get.to(
                                                          () => FullScreenImage(
                                                            showDefault: data.photo == null,
                                                            image: data.photo ?? "",
                                                            name: data.userName ?? "NA",
                                                            isBase64: data.photo != null && data.photo != "" && isBase64(data.photo!),
                                                            base64Data: data.photo != null && data.photo != "" && isBase64(data.photo!)
                                                                ? base64.decode(data.photo!)
                                                                : null,
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets.all(5),
                                                        width: Get.width * 0.26,
                                                        height: Get.height * 0.124,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(50),
                                                          child: data.photo == null
                                                              ? Image.asset(APPICONS.profileicon)
                                                              : data.photo == null && data.photo == ""
                                                                  ? CircleAvatar(
                                                                      radius: Get.height * 0.1,
                                                                      child: CustomText(
                                                                        text: UIHelper.getShortName(string: data.userName, limitTo: 2),
                                                                        fontSize: 20.0,
                                                                        color: Colors.black,
                                                                        weight: fontWeightMedium,
                                                                      ),
                                                                    )
                                                                  : isBase64(data.photo!)
                                                                      ? Image.memory(base64Decode(data.photo!), fit: BoxFit.cover)
                                                                      : CachedNetworkImage(
                                                                          imageUrl: data.photo!,
                                                                          fit: BoxFit.cover,
                                                                          errorWidget: (context, url, error) => Image.asset(APPICONS.profileicon),
                                                                          placeholder: (context, url) => const Center(
                                                                            child: CircularProgressIndicator(color: baseColor),
                                                                          ),
                                                                        ),
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: Get.width * 0.62,
                                                              child: Text(
                                                                provider.selectedProfession == "Profession"
                                                                    ? data.profession != null
                                                                        ? data.profession ?? '-'
                                                                        : '-'
                                                                    : provider.selectedProfession,
                                                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Container(
                                                              constraints: BoxConstraints(maxWidth: Get.width * 0.61, minWidth: 1),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    data.userName ?? "",
                                                                  ),
                                                                  Padding(
                                                                      padding: const EdgeInsets.only(top: 15),
                                                                      child: CustomText(
                                                                        text: 'Visits : ${data.visitsCount?.toString() ?? ''}',
                                                                        fontSize: 14.0,
                                                                        weight: fontWeightSemiBold,
                                                                        color: primaryColor,
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 3,
                                                            ),
                                                            if (data.isFriend != null && data.isFriend.toString() == "1")
                                                              Image.asset('images/Vector (2).png', height: 13, width: 16),
                                                            if (data.isFriend != null &&
                                                                data.isFriend.toString() == "1" &&
                                                                data.planName != null) ...[
                                                              const SizedBox(width: 3),
                                                              Image(
                                                                height: 16,
                                                                image: AssetImage(data.planName.contains("lord")
                                                                    ? APPICONS.lordicon
                                                                    : data.planName.contains("god")
                                                                        ? APPICONS.godstatuspng
                                                                        : APPICONS.kingstutspicpng),
                                                              )
                                                            ],
                                                          ],
                                                        ),
                                                        const SizedBox(height: 5),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const Divider(
                                                              color: Colors.grey,
                                                            ),
                                                            if (provider.selectedCountry.name != "Country" || provider.selectedCity.name != "City")
                                                              if (provider.selectedCountry.name != "Country") ...[
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
                                                                        if (provider.selectedCity.name != "City") ...[
                                                                          Text(' ${provider.selectedCity.name}, ')
                                                                        ],
                                                                        Text(provider.selectedCountry.name),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(width: 5),
                                                                    SizedBox(
                                                                      height: Get.height * 0.02,
                                                                      width: Get.width * 0.04,
                                                                      child: CountryPickerUtils.getDefaultFlagImage(
                                                                          CountryPickerUtils.getCountryByName(provider.selectedCountry.name)),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            UIHelper.verticalSpaceSm,
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (data.isLocked != null && data.isLocked == true) ...[LockWidget()]
                                        ],
                                      ),
                                    );
                                  } else if (isLoadingMoreData) {
                                    return const Center(
                                      child: CircularProgressIndicator(color: baseColor),
                                    );
                                  } else {}
                                },
                              ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget headerWidget() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: provider.searchController,
                  onFieldSubmitted: (value) {
                    if (provider.searchController.text.trim().isNotEmpty) {
                      page = 1;
                      provider.getUser().then((value) {
                        /* if (Provider.of<UserViewModel>(context, listen: false)
                                    .userModel
                                    .is_subscription_active ==
                                null ||
                            Provider.of<UserViewModel>(context, listen: false)
                                    .userModel
                                    .is_subscription_active ==
                                false) {
                          InterstitialScreen().showAds();
                        } */
                      });
                    }
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF767680),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFABAAB4), width: 1), borderRadius: BorderRadius.circular(28.0)),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFABAAB4), width: 1), borderRadius: BorderRadius.circular(28.0)),
                      hintText: 'Search'),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    if (provider.searchController.text.trim().isNotEmpty) {
                      page = 1;
                      provider.getUser().then((value) {
                        /* if (Provider.of<UserViewModel>(context, listen: false)
                                    .userModel
                                    .is_subscription_active ==
                                null ||
                            Provider.of<UserViewModel>(context, listen: false)
                                    .userModel
                                    .is_subscription_active ==
                                false) {
                          InterstitialScreen().showAds();
                        } */
                      });
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: Container(
                    height: Get.height * 0.06,
                    width: Get.width * 0.14,
                    decoration: const BoxDecoration(color: baseColor, shape: BoxShape.circle),
                    child: const Center(child: Icon(Icons.search, color: Colors.white)),
                  ))
            ],
          ),
          UIHelper.verticalSpaceMd,
          CustomText(
            text: 'Filter',
            fontSize: 20.0,
            weight: fontWeightSemiBold,
            color: Colors.black,
          ),
          UIHelper.verticalSpaceSm,
          Wrap(
            spacing: 12,
            runSpacing: 14,
            children: [
              Container(
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
                        page = 1;
                        provider.selectedCountry = value;
                        provider.selectedCity = country.City(name: "City", countryCode: "", stateCode: "");
                        /*  provider.cityList = [
                          country.City(
                              name: "City", countryCode: "", stateCode: "")
                        ]; */
                        provider.fetchCity();
                        provider.createURL();
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
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: Get.height * 0.052,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: PopupMenuButton<country.City>(
                    itemBuilder: (context) {
                      return provider.cityList.map((str) {
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
                        page = 1;
                        provider.selectedCity = value;
                        provider.createURL();
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(width: Get.width * 0.01),
                        Text(
                          provider.selectedCity.name.toString(),
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
              InkWell(
                onTap: () async {
                  dobPicker();
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    height: Get.height * 0.052,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          provider.dialogCalendarPickerValue.length == 2
                              ? "${DateFormat("dd/MM/yyyy").format(provider.dialogCalendarPickerValue[0]!)} - ${DateFormat("dd/MM/yyyy").format(provider.dialogCalendarPickerValue[1]!)}"
                              : "DOB Range".tr,
                          style: GoogleFonts.workSans(
                            color: const Color(0xFf46464F),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )),
              ),
              dropDown(
                  type: "Profession",
                  list: provider.professionList,
                  dropdownValue: provider.selectedProfession,
                  onChanged: (value) {
                    page = 1;
                    setState(() {
                      provider.selectedProfession = value!;
                    });
                    provider.createURL();
                    FocusScope.of(context).unfocus();
                  }),
            ],
          )
        ],
      ),
    );
  }

  GestureDetector tagContainer({required String text, required isAllow, required onTap, width}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(right: 8, left: isAllow ? 5 : 0),
        height: Get.height * 0.052,
        // width: width ?? Get.width * 0.28,
        decoration: BoxDecoration(
          color: isAllow ? const Color(0xFFAAEDFF) : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: isAllow ? Colors.transparent : const Color(0xFF767680),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            isAllow
                ? const Icon(
                    Icons.done,
                    size: 18,
                  )
                : Container(
                    width: 1,
                  ),
            const SizedBox(width: 10),
            Text(
              text.tr,
              style: GoogleFonts.workSans(
                color: const Color(0xFf46464F),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dropDown({required List<String> list, required String dropdownValue, required ValueChanged<String?> onChanged, required String type}) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: Get.height * 0.052,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: PopupMenuButton<String>(
            itemBuilder: (context) {
              return list.map((str) {
                return PopupMenuItem(
                  value: str,
                  textStyle: GoogleFonts.workSans(
                    color: const Color(0xFf46464F),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  child: Text(
                    str,
                    style: GoogleFonts.workSans(
                      color: const Color(0xFf46464F),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList();
            },
            onSelected: onChanged,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(width: Get.width * 0.01),
                Text(
                  dropdownValue,
                  style: GoogleFonts.workSans(
                    color: const Color(0xFf46464F),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ));
    });
  }

  Widget customContainer({required String text, required onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.5),
          color: containerColor, // Use the _containerColor variable here
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text),
        ),
      ),
    );
  }

  void dobPicker() async {
    const dayTextStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle = TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      lastDate: DateTime.now(),
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.purple[800],
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true ? Colors.white : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    var results = await showCalendarDatePicker2Dialog(
      context: context,
      config: config,
      dialogSize: const Size(325, 400),
      value: provider.dialogCalendarPickerValue,
      borderRadius: BorderRadius.circular(15),
    );
    if (results != null) {
      provider.dialogCalendarPickerValue = results;
      if (results.length == 1) {
        UIHelper.showBottomFlash(context, title: "OTP", message: "Please select DOB date range".tr, isError: false);
        dobPicker();
      } else {
        page = 1;
        provider.createURL();
        FocusScope.of(context).unfocus();
      }
    } else {
      page = 1;
      provider.dialogCalendarPickerValue = [];
      provider.createURL();

      FocusScope.of(context).unfocus();
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
}
