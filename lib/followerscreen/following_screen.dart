import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/widgets/dot_loader.dart';
import 'package:infosha/views/widgets/rating_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:infosha/views/widgets/locked_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infosha/followerscreen/mutual_following_screen.dart';
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';
import 'package:infosha/followerscreen/controller/following_model.dart';
import 'package:infosha/followerscreen/model/following_list_model.dart';
import 'package:infosha/screens/viewUnregistered/component/view_unregistered_user.dart';

class FollowingList extends StatefulWidget {
  String userid;
  FollowingList({required this.userid});

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  late FollowingModel provider;
  ScrollController scrollController = ScrollController();
  bool isLoadingMoreData = false;
  int page = 1;

  @override
  void initState() {
    print("id ==> ${widget.userid}");

    provider = Provider.of<FollowingModel>(context, listen: false);
    Future.microtask(() => context.read<FollowingModel>().fetFollowing(widget.userid));

    scrollController.addListener(_getMoreData);
    super.initState();
  }

  _getMoreData() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100 &&
        isLoadingMoreData == false) {
      setState(() {
        isLoadingMoreData = true;
      });
      page += 1;
      provider.fetchMoreFollowing(widget.userid, page).then((value) {
        setState(() {
          isLoadingMoreData = false;
        });
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          text: "All Followings".tr,
          isHeading: true,
          fontSize: 18.0,
        ),
      ),
      body: Consumer<FollowingModel>(builder: (context, provider, child) {
        return provider.isLoading
            ? const Center(child: CircularProgressIndicator(color: baseColor))
            : provider.followingListModel.data == null
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
                          'No Followings Found'.tr,
                          style: GoogleFonts.workSans(
                            color: const Color(0xFF46464F),
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(color: Colors.black54),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Get.to(() => MutualFollowingList(
                                      userid: widget.userid,
                                      isFromFollowers: false,
                                    ));
                              },
                              child: Text(
                                'Mutual'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: provider.followingListModel.data!.data!.length + 1,
                          separatorBuilder: (context, index) => const Divider(height: 10, thickness: 0),
                          itemBuilder: (context, index) {
                            if (index < provider.followingListModel.data!.data!.length) {
                              var itemData = provider.followingListModel.data!.data![index];
                              return followingContainer(itemData);
                            } else if (isLoadingMoreData) {
                              return
                                  // const Center(
                                  //   child: CircularProgressIndicator(color: baseColor),
                                  // );
                                  const Padding(
                                padding: EdgeInsets.symmetric(vertical: 0),
                                child: Center(
                                  child: DancingDotsLoader(),
                                ),
                              );
                            } else {}
                          },
                        ),
                      ),
                    ],
                  );
      }),
    );
  }

  followingContainer(Data itemData) {
    return InkWell(
      onTap: () {
        if (itemData.userId != null) {
          if (itemData.isLocked != null && itemData.isLocked == false) {
            Get.to(() => ViewProfileScreen(id: itemData.userId.toString()));
          }
        } else {
          if (itemData.isLocked != null && itemData.isLocked == false) {
            Get.to(() => ViewUnregisteredUser(
                contactId: itemData.number.toString(), id: itemData.number.toString(), isOther: true));
          }
        }
      },
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: Get.width * 0.24,
                height: Get.height * 0.114,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: itemData.profile == "https://via.placeholder.com/150" ||
                          itemData.profile == "" ||
                          itemData.profile == null
                      ? Image.asset('images/aysha.png')
                      : isBase64(itemData.profile!)
                          ? Image.memory(
                              base64Decode(itemData.profile!),
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: itemData.profile!,
                              fit: BoxFit.cover,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              itemData.profession ?? '-',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Color(0xFFABAAB4), fontSize: 12),
                            ),
                          ),
                          MyCustomRatingView(
                            starSize: 12.0,
                            ratinigValue:
                                itemData.averageReview == null ? 0.0 : double.parse(itemData.averageReview.toString()),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                constraints: BoxConstraints(minWidth: 1, maxWidth: Get.width * 0.5),
                                child: Text(
                                  itemData.username ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyleWorkSense(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    weight: fontWeightSemiBold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              if (itemData.userId != null)
                                const Icon(
                                  Icons.verified,
                                  color: Color(0xFF007EFF),
                                  size: 20,
                                ),
                              if (itemData.isSubscriptionActive != null && itemData.isSubscriptionActive != false) ...[
                                Image(
                                  height: 20,
                                  image: AssetImage(
                                    itemData.activeSubscriptionPlanName!.contains("lord")
                                        ? APPICONS.lordicon
                                        : itemData.activeSubscriptionPlanName!.contains("god")
                                            ? APPICONS.godstatuspng
                                            : APPICONS.kingstutspicpng,
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Text(
                    itemData.number ?? '',
                    style: const TextStyle(color: Color(0xFFABAAB4), fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          if (itemData.isLocked != null && itemData.isLocked == true) ...[LockWidget()]
        ],
      ),
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
