import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/utils/utils.dart';
import 'package:infosha/config/const.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/DraggableHome/dragable_home.dart';
import 'package:infosha/utils/error_boundary.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:infosha/views/widgets/DOBView.dart';
import 'package:infosha/views/widgets/emailView.dart';
import 'package:infosha/views/widgets/gender_view.dart';
import 'package:infosha/views/widgets/rating_view.dart';
import 'package:infosha/views/widgets/vote_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:infosha/views/widgets/common_dialog.dart';
import 'package:infosha/views/widgets/nickname_view.dart';
import 'package:infosha/Controller/models/user_model.dart';
import 'package:infosha/Controller/Viewmodel/reaction.dart';
import 'package:infosha/followerscreen/followers_list.dart';
import 'package:infosha/followerscreen/followerscreen.dart';
import 'package:infosha/views/widgets/call_number_view.dart';
import 'package:infosha/followerscreen/following_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:infosha/screens/feed/component/feed_tile.dart';
import 'package:infosha/views/widgets/common_vote_button.dart';
import 'package:infosha/views/widgets/namewithlabel_view.dart';
import 'package:infosha/views/widgets/state_country_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infosha/views/widgets/like_dislike_button.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/feed/controller/feed_model.dart';
import 'package:infosha/screens/ProfileScreen/profilerating.dart';
import 'package:infosha/views/widgets/profile_image_view_me.dart';
import 'package:flutter_feed_reaction/widgets/emoji_reaction.dart';
import 'package:infosha/screens/ProfileScreen/visitor_screen.dart';
import 'package:infosha/screens/ProfileScreen/edit_my_profile.dart';
import 'package:infosha/Controller/models/profile_rating_model.dart';
import 'package:infosha/screens/otherprofile/add_review_dialog.dart';
import 'package:infosha/screens/otherprofile/vote_bottom_sheet.dart';
import 'package:infosha/screens/otherprofile/show_review_dialog.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';
import 'package:infosha/views/widgets/social_media_facebook_view.dart';
import 'package:infosha/screens/otherprofile/reaction_bottomsheet.dart';
import 'package:infosha/views/widgets/addressview_unregister_view.dart';
import 'package:infosha/views/widgets/social_media_instagram_view.dart';
import 'package:infosha/screens/allKingsGods/component/all_king_god.dart';
import 'package:infosha/Controller/models/profession_by_other_user_model.dart';
import 'package:infosha/screens/subscription/component/subscription_screen.dart';
import 'package:infosha/screens/viewUnregistered/model/unregistered_user_model.dart';
import 'package:infosha/screens/viewUnregistered/component/review_vote_bottomsheet.dart';
import 'package:infosha/screens/viewUnregistered/model/unregistered_user_model.dart' as te;
import 'package:infosha/screens/viewUnregistered/component/edit_profession_dailog_unregister.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedLikeState = -1;

  var formKey = GlobalKey<FormState>();
  TextEditingController replyController = TextEditingController();
  late UserViewModel provider;
  late FeedModel providerFeed;
  int selectedTile = -1, selectedReactionId = -1;
  bool showDeletedComment = false;
  List<te.GetNickName> popularNumbers = [];
  List<Map<dynamic, dynamic>> data = [];
  var maxOccurrence = 0;
  List<String> temp1 = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    provider = Provider.of<UserViewModel>(context, listen: false);
    providerFeed = Provider.of<FeedModel>(context, listen: false);

    setState(() {
      if (Provider.of<UserViewModel>(context, listen: false).userModel.likeStatus == true) {
        selectedLikeState = 0;
      } else if (Provider.of<UserViewModel>(context, listen: false).userModel.dislikeStatus == true) {
        selectedLikeState = 1;
      } else {
        selectedLikeState = -1;
      }
    });

    List<te.GetNickName>? mainList = [];
    setState(() {
      if (provider.userModel != null && provider.userModel.getNickName != null) {
        mainList.addAll(provider.userModel.getNickName!);
      }
    });

    for (int i = 0; i < mainList.length; i++) {
      if (mainList[i].name!.contains(';')) {
        List<String> separatedNames = mainList[i].name!.split(';');
        var temp = separatedNames.join(", ");
        temp1.addAll(temp.split(","));
      }
    }

    for (int i = 0; i < temp1.length; i++) {
      mainList.add(GetNickName(addedBy: "Anonymous", name: temp1[i]));
    }

    mainList.removeWhere((element) => element.name!.contains(';'));

    List<GetNickName> allName = [];
    allName.addAll(mainList);
    mainList.clear();
    Map<String, Set<String>> nameMap = {};

    for (var entry in allName) {
      String name = entry.name!.trim();
      String addedBy = entry.addedBy!.trim();

      if (!nameMap.containsKey(name)) {
        nameMap[name] = {};
      }

      if (addedBy == 'Anonymous') {
        if (!nameMap[name]!.contains('Anonymous')) {
          nameMap[name]!.add('Anonymous');
          mainList.add(entry);
        }
      } else {
        if (!nameMap[name]!.contains(addedBy)) {
          nameMap[name]!.add(addedBy);
          mainList.add(entry);
        }
      }
    }

    Map<String, int> nameCount = {};

    for (var item in mainList) {
      List<String> names = item.name!.split(';').map((e) => e.trim()).toList();
      for (var name in names) {
        nameCount[name] = (nameCount[name] ?? 0) + 1;
      }
    }

    String mostUsedName = '';
    int maxCount = 0;

    nameCount.forEach((name, count) {
      if (count > maxCount) {
        mostUsedName = name;
        maxCount = count;
      }
    });

    // popularNumbers.add(GetNickName(addedBy: "", name: mostUsedName));
    if (mostUsedName.isNotEmpty) {
      popularNumbers.add(GetNickName(addedBy: "", name: mostUsedName));
    }

    Future.delayed(Duration(milliseconds: 1000), () {
      provider.notifyListeners();
    });
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    setState(() {
      if (provider.userModel.likeStatus == true) {
        selectedLikeState = 0;
      } else if (provider.userModel.dislikeStatus == true) {
        selectedLikeState = 1;
      } else {
        selectedLikeState = -1;
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  refreshData() async {
    provider.userModel = await provider.getUserProfileById(Params.UserToken);
    setState(() {
      if (provider.userModel.likeStatus == true) {
        selectedLikeState = 0;
      } else if (provider.userModel.dislikeStatus == true) {
        selectedLikeState = 1;
      } else {
        selectedLikeState = -1;
      }
    });
  }

  refreshInitialData() async {
    provider.userModel = await provider.getUserProfileById(Params.UserToken);
  }

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: VisibilityDetector(
        key: const Key('profile_screen_visibility_detector'),
        onVisibilityChanged: (visibilityInfo) {
          final isVisible = visibilityInfo.visibleFraction > 0;
          // You can update a provider or variable here if needed
          if (providerFeed.isProfileScreenVisible != isVisible) {
            providerFeed.isProfileScreenVisible = isVisible;
            debugPrint("Profile Screen visibility updated: $isVisible");
          }
        },
        child: Scaffold(
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: baseColor,
                    ),
                  )
                : Consumer<UserViewModel>(builder: (context, provider, child) {
                    return RefreshIndicator(
                      edgeOffset: Get.height * 0.45,
                      onRefresh: () async {
                        refreshData();
                      },
                      child: DraggableHome(
                        centerTitle: false,
                        headerBottomBar: Container(
                          transform: Matrix4.translationValues(0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LikeDislikeButton(
                                usercounts: int.parse(provider.userModel.likeCount.toString()),
                                isLikeButton: true,
                                likestatus: 0,
                                isActive: selectedLikeState == 0,
                                onTap: () {
                                  if ((provider.userModel.is_subscription_active == true &&
                                          provider.userModel.active_subscription_plan_name!.contains("god")) ||
                                      (provider.userModel.is_subscription_active == true &&
                                          provider.userModel.active_subscription_plan_name!.contains("king"))) {
                                    VoteBottomSheet().showVote(context, provider.userModel.number!, true);
                                  }
                                },
                                oncallback: (value) {
                                  if (value != null) {
                                    setState(() {
                                      if (selectedLikeState == 0) {
                                        selectedLikeState = -1;
                                        provider.likeDislike(provider.userModel.number, true).then((value) {
                                          setState(() {
                                            provider.userModel.likeCount = value.data!.likeCount;
                                            provider.userModel.dislikeCount = value.data!.dislikeCount;
                                            provider.userModel.likeStatus = false;
                                            provider.userModel.dislikeStatus = false;
                                            selectedLikeState = -1;
                                          });
                                        });
                                      } else {
                                        selectedLikeState = value;
                                        provider.likeDislike(provider.userModel.number, true).then((value) {
                                          setState(() {
                                            provider.userModel.likeCount = value.data!.likeCount;
                                            provider.userModel.dislikeCount = value.data!.dislikeCount;
                                            provider.userModel.likeStatus = true;
                                            provider.userModel.dislikeStatus = false;
                                            selectedLikeState = 0;
                                          });
                                        });
                                      }
                                    });
                                  }
                                },
                              ),
                              UIHelper.horizontalSpaceSm,
                              LikeDislikeButton(
                                usercounts: int.parse(provider.userModel.dislikeCount.toString()),
                                isLikeButton: false,
                                likestatus: 1,
                                isActive: selectedLikeState == 1,
                                onTap: () {
                                  if ((provider.userModel.is_subscription_active == true &&
                                          provider.userModel.active_subscription_plan_name!.contains("god")) ||
                                      (provider.userModel.is_subscription_active == true &&
                                          provider.userModel.active_subscription_plan_name!.contains("king"))) {
                                    VoteBottomSheet().showVote(context, provider.userModel.number!, false);
                                  }
                                },
                                oncallback: (value) {
                                  setState(() {
                                    if (value != null) {
                                      setState(() {
                                        if (selectedLikeState == 1) {
                                          selectedLikeState = -1;
                                          provider.likeDislike(provider.userModel.number, false).then((value) {
                                            setState(() {
                                              provider.userModel.likeCount = value.data!.likeCount;
                                              provider.userModel.dislikeCount = value.data!.dislikeCount;
                                              provider.userModel.likeStatus = false;
                                              provider.userModel.dislikeStatus = false;
                                            });
                                          });
                                        } else {
                                          selectedLikeState = value;
                                          provider.likeDislike(provider.userModel.number, false).then((value) {
                                            setState(() {
                                              provider.userModel.likeCount = value.data!.likeCount;
                                              provider.userModel.dislikeCount = value.data!.dislikeCount;
                                              provider.userModel.likeStatus = false;
                                              provider.userModel.dislikeStatus = true;
                                            });
                                          });
                                        }
                                      });
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        title: Row(
                          children: [
                            provider.userModel.profile!.profileUrl != "https://via.placeholder.com/150"
                                ? ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: provider.userModel.profile!.profileUrl!,
                                      width: Get.width * 0.08,
                                      height: Get.height * 0.04,
                                      fit: BoxFit.fill,
                                      errorWidget: (context, url, error) => CircleAvatar(
                                        radius: Get.height * 0.026,
                                        child: CustomText(
                                          text: UIHelper.getShortName(
                                              string: provider.userModel.profile!.profileUrl, limitTo: 2),
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          weight: fontWeightMedium,
                                        ),
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: Get.height * 0.026,
                                    child: CustomText(
                                      text: UIHelper.getShortName(string: provider.userModel.username, limitTo: 2),
                                      fontSize: 20.0,
                                      color: Colors.black,
                                      weight: fontWeightMedium,
                                    ),
                                  ),
                            UIHelper.horizontalSpaceSm,
                            SizedBox(
                              width: Get.width * 0.46,
                              child: CustomText(
                                text: provider.userModel.username!,
                                fontSize: 16.0,
                                weight: fontWeightMedium,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        alwaysShowLeadingAndAction: true,
                        headerExpandedHeight: 0.75,
                        expandedHeight: MediaQuery.of(context).size.height * 0.79,
                        headerWidget: headerWidget(provider),
                        actions: [cancelSubscription()],
                        curvedBodyRadius: 0,
                        body: [
                          Consumer<UserViewModel>(builder: (context, provider, child) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              child: Consumer<UserViewModel>(builder: (context, provider, child) {
                                return Column(
                                  children: [
                                    headerWithEdit(
                                        label: "Bio".tr,
                                        ontap: () {
                                          Get.to(() => const EditMyProfile())!.then((value) async {
                                            provider.userModel = await provider.getUserProfileById(Params.UserToken);
                                            setState(() {});
                                          });
                                        }),
                                    UIHelper.verticalSpaceSm,
                                    Row(
                                      children: [
                                        const Image(
                                          color: Color(0xFF767680),
                                          height: 20,
                                          width: 20,
                                          image: AssetImage("images/person.png"),
                                        ),
                                        const SizedBox(width: 20),
                                        GenderView(
                                            nickName: provider.userModel.getGender != null &&
                                                    provider.userModel.getGender!.isNotEmpty
                                                ? provider.userModel.getGender ?? []
                                                : [])
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Image(
                                          color: Color(0xFF767680),
                                          height: 20,
                                          width: 20,
                                          image: AssetImage("images/cases.png"),
                                        ),
                                        const SizedBox(width: 20),
                                        DOBView(
                                            nickName: provider.userModel.getDob != null &&
                                                    provider.userModel.getDob!.isNotEmpty
                                                ? provider.userModel.getDob ?? []
                                                : []),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Image(
                                          color: Color(0xFF767680),
                                          height: 20,
                                          width: 20,
                                          image: AssetImage("images/locationnn.png"),
                                        ),
                                        const SizedBox(width: 20),
                                        StateCountryView(
                                            nickName: provider.userModel.getAddressOther != null &&
                                                    provider.userModel.getAddressOther!.isNotEmpty
                                                ? provider.userModel.getAddressOther ?? []
                                                : []),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Image(
                                          color: Color(0xFF767680),
                                          height: 20,
                                          width: 20,
                                          image: AssetImage("images/location.png"),
                                        ),
                                        const SizedBox(width: 20),
                                        AddressUnregisterView(
                                            nickName: provider.userModel.getAddress != null &&
                                                    provider.userModel.getAddress!.isNotEmpty
                                                ? provider.userModel.getAddress ?? []
                                                : []),
                                      ],
                                    ),
                                    UIHelper.verticalSpaceMd,
                                    headerWithEdit(
                                        label: "Social Media".tr,
                                        ontap: () {
                                          Get.to(() => const EditMyProfile())!.then((value) async {
                                            provider.userModel = await provider.getUserProfileById(Params.UserToken);
                                            setState(() {});
                                          });
                                        }),
                                    UIHelper.verticalSpaceSm,
                                    SizedBox(
                                      width: Get.width,
                                      child: Wrap(
                                        spacing: 20.0,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Image(
                                                color: Color(0xFF767680),
                                                height: 20,
                                                width: 20,
                                                image: AssetImage("images/message.png"),
                                              ),
                                              const SizedBox(width: 10),
                                              provider.userModel.getEmail != null &&
                                                      provider.userModel.getEmail!.isNotEmpty
                                                  ? EmailView(
                                                      nickName: provider.userModel.getEmail!.isNotEmpty
                                                          ? provider.userModel.getEmail ?? []
                                                          : [])
                                                  : CustomText(
                                                      text: '--',
                                                      fontSize: 16.0.sp,
                                                      weight: fontWeightMedium,
                                                      color: Colors.black,
                                                    ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Image(
                                                height: 20,
                                                width: 20,
                                                image: AssetImage("images/facebook.png"),
                                              ),
                                              const SizedBox(width: 10),
                                              provider.userModel.getSocial != null &&
                                                      provider.userModel.getSocial!.isNotEmpty
                                                  ? SocialMediaFacebookView(
                                                      nickName: provider.userModel.getSocial!.isNotEmpty
                                                          ? provider.userModel.getSocial ?? []
                                                          : [])
                                                  : CustomText(
                                                      text: '--',
                                                      fontSize: 16.0.sp,
                                                      weight: fontWeightMedium,
                                                      color: Colors.black,
                                                    ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Image(
                                                height: 20,
                                                width: 20,
                                                image: AssetImage("images/instagram.png"),
                                              ),
                                              const SizedBox(width: 10),
                                              provider.userModel.getSocialOther != null &&
                                                      provider.userModel.getSocialOther!.isNotEmpty
                                                  ? SocialMediaInstagramView(
                                                      nickName: provider.userModel.getSocialOther!.isNotEmpty
                                                          ? provider.userModel.getSocialOther ?? []
                                                          : [])
                                                  : CustomText(
                                                      text: '--',
                                                      fontSize: 16.0.sp,
                                                      weight: fontWeightMedium,
                                                      color: Colors.black,
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    UIHelper.verticalSpaceMd,
                                    if ((provider.userModel.followers != null &&
                                            provider.userModel.followers!.isNotEmpty) &&
                                        (provider.userModel.is_subscription_active == true &&
                                            provider.userModel.active_subscription_plan_name!.contains("god"))) ...[
                                      headerWithEdit(
                                        label: "Followers".tr,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (provider.userModel.is_subscription_active == true &&
                                                provider.userModel.active_subscription_plan_name!.contains("god")) {
                                              Get.to(() => FollowersListScreen(
                                                    number: provider.userModel.number.toString(),
                                                    id: provider.userModel.id.toString(),
                                                  ));
                                            }
                                          },
                                          child: Text(
                                            "See All".tr,
                                            style: const TextStyle(
                                                color: Color(0xFf1B2870),
                                                fontSize: 14,
                                                decoration: TextDecoration.underline),
                                          ),
                                        ),
                                      ),
                                      UIHelper.verticalSpaceSm,
                                      SizedBox(
                                        height: Get.height * 0.25,
                                        child: ListView.builder(
                                            itemCount: provider.userModel.followers!.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return followerAdaptor(provider.userModel.followers![index]);
                                            }),
                                      ),
                                    ],
                                    UIHelper.verticalSpaceMd,
                                    headerWithEdit(
                                      label: "Reviews".tr,
                                      child: Container(),
                                    ),
                                    UIHelper.verticalSpaceSm,
                                    if (provider.userModel.reviewList != null) ...[
                                      ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemCount: provider.userModel.reviewList!.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return reviewAdaptor(context, provider.userModel.reviewList![index], index,
                                              provider.userModel.reviewList!);
                                        },
                                        separatorBuilder: (context, index) => const Divider(
                                          height: 20,
                                          color: Colors.transparent,
                                        ),
                                      )
                                    ],
                                    if ((provider.userModel.is_subscription_active != null
                                            ? provider.userModel.is_subscription_active == true
                                            : false) &&
                                        (provider.userModel.active_subscription_plan_name != null
                                            ? provider.userModel.active_subscription_plan_name
                                                .toString()
                                                .contains("god")
                                            : false)) ...[
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            showDeletedComment = !showDeletedComment;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                          margin: const EdgeInsets.symmetric(vertical: 15),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(22), color: const Color(0xFFE12C2C)),
                                          child: Text(
                                              showDeletedComment
                                                  ? "Hide deleted comments".tr
                                                  : "Show deleted comments".tr,
                                              style: GoogleFonts.workSans(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ),
                                      )
                                    ]
                                  ],
                                );
                              }),
                            );
                          }),
                        ],
                        fullyStretchable: false,
                        backgroundColor: Colors.white,
                        appBarColor: Colors.white,
                      ),
                    );
                  })),
      ),
    );
  }

  /// used to show each review used in listview
  reviewAdaptor(
    BuildContext context,
    ReviewList model,
    int index,
    List<ReviewList> list,
  ) {
    // used to sort comments
    provider.userModel.reviewList![index].repliesComment!.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    // used to get reaction id from name
    selectedReactionId = getReactionId(model.reactionName ?? "");

    // used visiblity to hide comment if delete by user and for other user except god. God can see deleted comments
    return Visibility(
      visible: model.is_deleted_comment.toString() == "0" ||
          (showDeletedComment && model.is_deleted_comment.toString() == "1"),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: model.is_deleted_comment.toString() == "1" ? const Color(0xFFFFE1E1) : const Color(0xFFF2F7F7),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (model.user_nickname != "Anonymous") {
                      Get.to(() => ViewProfileScreen(id: list[index].reviewerId.toString()));
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        // width: Get.width * 0.24,
                        // height: Get.height * 0.115,
                        margin: const EdgeInsets.only(left: 8, top: 8),
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(Get.height * 0.057),
                            child: model.user_nickname == "Anonymous"
                                ? Image.asset('images/aysha.png')
                                : model.profileUrl == null || model.profileUrl == "https://via.placeholder.com/150"
                                    ? Image.asset('images/aysha.png')
                                    : isBase64(model.profileUrl!)
                                        ? Image.memory(base64Decode(model.profileUrl!), fit: BoxFit.cover)
                                        : CachedNetworkImage(
                                            imageUrl: model.profileUrl!,
                                            fit: BoxFit.fill,
                                            errorWidget: (context, url, error) => Image.asset('images/aysha.png'),
                                            placeholder: (context, url) => const Center(
                                              child: CircularProgressIndicator(color: baseColor),
                                            ),
                                          ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            /* provider.userModel.is_subscription_active ==
                                        false &&
                                    provider.userModel.is_subscription_active !=
                                        null
                                ? "Anonymous"
                                : */ /* provider.userModel.is_subscription_active == true &&
                                        (provider.userModel
                                                .active_subscription_plan_name!
                                                .contains("god") ||
                                            provider.userModel
                                                .active_subscription_plan_name!
                                                .contains("king"))
                                    ?  */
                            model.user_nickname ?? "" /* : "Anonymous" */,
                            style: const TextStyle(fontSize: 12),
                          ),
                          subtitle: Text(
                            Jiffy.parse(model.createdAt != null
                                    ? utcToLocal(model.createdAt.toString())
                                    : DateTime.now().toString())
                                .fromNow(),
                            style: const TextStyle(color: Color(0xFFABAAB4), fontSize: 13),
                          ),
                          trailing: SizedBox(
                            height: Get.height * 0.05,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyCustomRatingView(
                                  starSize: 12.0,
                                  ratinigValue: model.rating != null ? double.parse(model.rating.toString()) : 0.0,
                                ),
                                popupMenu(
                                  model.reviewerId.toString(),
                                  index,
                                  model.id.toString(),
                                  false,
                                  model.is_deleted_comment,
                                ),
                              ],
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(right: 1, left: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ViewProfileScreen(id: list[index].reviewerId.toString()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          model.comment ?? "",
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF767680),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlutterFeedReaction(
                      reactions: EmojiReactions.reactions,
                      spacing: 0.0,
                      dragStart: 20,
                      dragSpace: 40.0,
                      containerWidth: Get.width * 0.9,
                      prefix: Consumer<UserViewModel>(builder: (context, provider, child) {
                        return SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              getReactionEmoji(selectedReactionId),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  ReactionBottomSheet().showReactions(context, model.id.toString());
                                },
                                child: Text(model.totalReactionCount.toString(),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      }),
                      onReactionSelected: (val) {
                        String name = getReactionName(val.id);
                        setState(() {
                          selectedReactionId = val.id;
                          model.reactionName = name;
                        });

                        UserViewModel provider = Provider.of(context, listen: false);
                        provider.addReaction(model.id.toString(), name).then((value) {
                          setState(() {
                            if (int.parse(model.totalReactionCount.toString()) > value) {
                              selectedReactionId = -1;
                              model.reactionName = null;
                            }
                            model.totalReactionCount = value;
                          });
                        });
                      },
                      onPressed: () {
                        /* if (model.reactionName != null &&
                            model.reactionName != "null") {
                          String name = selectedReactionId == 0
                              ? "love"
                              : selectedReactionId == 1
                                  ? "wow"
                                  : selectedReactionId == 2
                                      ? "lol"
                                      : selectedReactionId == 3
                                          ? "sad"
                                          : "angry";
    
                          UserViewModel provider =
                              Provider.of(context, listen: false);
                          provider
                              .addReaction(model.id.toString(), name)
                              .then((value) {
                            setState(() {
                              model.totalReactionCount = value;
                              model.reactionName = null;
                              selectedReactionId = -1;
                            });
                          });
                        } */
                        ReactionBottomSheet().showReactions(context, model.id.toString());
                        // Get.bottomSheet(AllReactionSheet(),
                        //     isScrollControlled: true, isDismissible: true);
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: 1,
                      height: 24,
                      color: Colors.black38,
                    ),
                    CommonVoteButton(
                      usercounts: int.parse(model.likeCount.toString()),
                      isLikeButton: true,
                      likestatus: 0,
                      isActive: model.isLiked ?? false,
                      color: Colors.white,
                      onTap: () {
                        if ((provider.userModel.is_subscription_active == true &&
                                provider.userModel.active_subscription_plan_name!.contains("god")) ||
                            (provider.userModel.is_subscription_active == true &&
                                provider.userModel.active_subscription_plan_name!.contains("king"))) {
                          ReviewVoteBottomSheet().showReviewVote(context, model.id.toString(), true);
                        }
                      },
                      oncallback: (value) {
                        provider.likeDislikeReview(model.id.toString(), true).then((value) {
                          if (value.status == 0) {
                            setState(() {
                              model.isLiked = true;
                              model.isDisliked = false;
                              model.likeCount = value.likeCount;
                              model.dislikeCount = value.disLikeCount;
                            });
                          } else {
                            setState(() {
                              model.isLiked = false;
                              model.isDisliked = false;
                              model.likeCount = value.likeCount;
                              model.dislikeCount = value.disLikeCount;
                            });
                          }
                        });
                      },
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: Colors.black38,
                    ),
                    CommonVoteButton(
                      usercounts: int.parse(model.likeCount.toString()),
                      isLikeButton: true,
                      likestatus: 0,
                      isActive: model.isLiked ?? false,
                      color: Colors.white,
                      onTap: () {
                        if ((provider.userModel.is_subscription_active == true &&
                                provider.userModel.active_subscription_plan_name!.contains("god")) ||
                            (provider.userModel.is_subscription_active == true &&
                                provider.userModel.active_subscription_plan_name!.contains("king"))) {
                          ReviewVoteBottomSheet().showReviewVote(context, model.id.toString(), false);
                        }
                      },
                      oncallback: (value) {
                        provider.likeDislikeReview(model.id.toString(), false).then((value) {
                          if (value.status == 1) {
                            setState(() {
                              model.isLiked = false;
                              model.isDisliked = true;
                              model.likeCount = value.likeCount;
                              model.dislikeCount = value.disLikeCount;
                            });
                          } else {
                            setState(() {
                              model.isLiked = false;
                              model.isDisliked = false;
                              model.likeCount = value.likeCount;
                              model.dislikeCount = value.disLikeCount;
                            });
                          }
                        });
                      },
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: Colors.black38,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (selectedTile == index) {
                            selectedTile = -1;
                          } else {
                            selectedTile = index;
                          }
                        });
                      },
                      child: SizedBox(
                        width: Get.width * 0.15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            selectedTile == index
                                ? const Image(
                                    height: 17,
                                    // width: 30,
                                    image: AssetImage('images/fillComment.png'))
                                : const Image(
                                    height: 17,
                                    // width: 30,
                                    image: AssetImage('images/comments.png')),
                            const SizedBox(width: 10),
                            Text(model.repliesCommentCount.toString(),
                                style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                /// used to hide reply section and show when it is expanded
                Visibility(
                    visible: selectedTile == index,
                    child: Column(
                      children: [
                        const Divider(
                          height: 1,
                          color: Colors.black,
                        ),
                        Container(
                          width: Get.width,
                          color: const Color(0xFfEDF1F1),
                          child: Row(
                            children: [
                              if (model.is_deleted_comment.toString() != "1") ...[
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    alignment: Alignment.center,
                                    child: Form(
                                      key: model.formKey,
                                      child: TextFormField(
                                        key: Key(index.toString()),
                                        controller: replyController,
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return "Please write reply".tr;
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(left: 10),
                                            focusedBorder: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(3.0),
                                                ),
                                                borderSide: BorderSide(color: Color(0xFf767680), width: 2)),
                                            border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(3.0),
                                                ),
                                                borderSide: BorderSide(color: Color(0xFf767680), width: 2)),
                                            hintText: "Write Reply...".tr,
                                            hintStyle: textStyleWorkSense(
                                                fontSize: 14.0,
                                                color: const Color(0xFF46464F),
                                                weight: fontWeightRegular)),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Consumer<UserViewModel>(builder: (context, provider, child) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (model.formKey!.currentState!.validate()) {
                                          provider
                                              .addReply(model.id.toString(), replyController.text.trim(),
                                                  provider.userModel.id.toString())
                                              .then((value) {
                                            setState(() {
                                              provider.userModel.reviewList = value;
                                              provider.userModel.reviewList!
                                                  .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

                                              replyController.clear();
                                            });
                                          });
                                        }
                                      },
                                      child: provider.isAddComment
                                          ? const CircularProgressIndicator(color: baseColor)
                                          : Image.asset(
                                              "images/sendIcon.png",
                                              height: Get.height * 0.06,
                                              // width: Get.width * 0.2,
                                            ),
                                    );
                                  }),
                                )
                              ]
                            ],
                          ),
                        ),

                        /// used to show comment reply list
                        if (provider.userModel.reviewList![index].repliesComment != null)
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: provider.userModel.reviewList![index].repliesComment!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, innerIndex) {
                              var replyData = provider.userModel.reviewList![index].repliesComment![innerIndex];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => ViewProfileScreen(id: replyData.commentUserId.toString()));
                                },
                                child: Visibility(
                                  visible: replyData.is_deleted_comment_reply.toString() == "0" ||
                                      (showDeletedComment && replyData.is_deleted_comment_reply.toString() == "1"),
                                  child: Column(
                                    children: [
                                      Container(
                                        color: replyData.is_deleted_comment_reply.toString() == "1"
                                            ? const Color(0xFFFFE1E1)
                                            : const Color(0xFFEDF1F1),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(left: 8),
                                              width: Get.width * 0.24,
                                              height: Get.height * 0.115,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(65),
                                                child: replyData.profileUrl == null ||
                                                        replyData.profileUrl == "https://via.placeholder.com/150"
                                                    ? Image.asset('images/aysha.png')
                                                    : isBase64(replyData.profileUrl!)
                                                        ? Image.memory(base64Decode(replyData.profileUrl!),
                                                            fit: BoxFit.cover)
                                                        : CachedNetworkImage(
                                                            imageUrl: replyData.profileUrl!,
                                                            fit: BoxFit.fill,
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
                                                title: Text(
                                                  Jiffy.parse(replyData.createdAt != null
                                                          ? utcToLocal(replyData.createdAt!)
                                                          : DateTime.now().toString())
                                                      .fromNow(),
                                                  style: const TextStyle(color: Color(0xFFABAAB4), fontSize: 13),
                                                ),
                                                subtitle: Text(
                                                  replyData.username ?? "Anonymous",
                                                  style: textStyleWorkSense(),
                                                ),
                                                trailing: popupMenu(replyData.commentUserId.toString(), index,
                                                    replyData.id.toString(), true, replyData.is_deleted_comment_reply),
                                                contentPadding: const EdgeInsets.only(right: 1, left: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: innerIndex ==
                                                      provider.userModel.reviewList![index].repliesComment!.length - 1
                                                  ? const Radius.circular(15)
                                                  : const Radius.circular(0),
                                              bottomRight: innerIndex ==
                                                      provider.userModel.reviewList![index].repliesComment!.length - 1
                                                  ? const Radius.circular(15)
                                                  : const Radius.circular(0)),
                                          color: replyData.is_deleted_comment_reply.toString() == "1"
                                              ? const Color(0xFFFFE1E1)
                                              : const Color(0xFFEDF1F1),
                                        ),
                                        padding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              replyData.comment ?? "",
                                              textAlign: TextAlign.justify,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF767680),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// NOT USED NOW use for reference
  InkWell addReviewButton() {
    return InkWell(
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            children: [
              const Icon(
                Icons.star_border_outlined,
                color: whiteColor,
                size: 18,
              ),
              const SizedBox(width: 5),
              CustomText(
                text: "Add review".tr,
                fontSize: 15.0.sp,
                weight: fontWeightMedium,
                color: whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// used to check if given string is image data is base64 data or not
  bool isBase64(String str) {
    try {
      base64.decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// used to show each followers and used in listview
  followerAdaptor(FollowersList data) {
    return InkWell(
      onTap: () {
        Get.to(() => ViewProfileScreen(id: data.followerId.toString()));
      },
      child: Card(
        color: lightBlue,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: Get.width * 0.4,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: Get.width * 0.24,
                height: Get.height * 0.115,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(65),
                  child: data.user.profile!.profileUrl == null ||
                          data.user.profile!.profileUrl! == "https://via.placeholder.com/150"
                      ? Image.asset('images/aysha.png')
                      : isBase64(data.user.profile!.profileUrl!)
                          ? Image.memory(base64Decode(data.user.profile!.profileUrl!), fit: BoxFit.cover)
                          : CachedNetworkImage(
                              imageUrl: data.user.profile!.profileUrl!,
                              fit: BoxFit.fill,
                              errorWidget: (context, url, error) => Image.asset('images/aysha.png'),
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(color: baseColor),
                              ),
                            ),
                ),
              ),

              /// used to show rating of followers
              MyCustomRatingView(
                starSize: 12.0,
                ratinigValue: data.user.averageRating == null ? 0.0 : double.parse(data.user.averageRating.toString()),
              ),
              CustomText(
                text: data.user.profile!.profession != null ? data.user.profile!.profession ?? '--' : "--",
                fontSize: 12.0,
                weight: fontWeightMedium,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: Get.width * 0.25),
                    child: AutoSizeText(
                      data.user.username ?? "",
                      maxLines: 1,
                      minFontSize: 10,
                      maxFontSize: 16.0,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: textStyleWorkSense(weight: fontWeightSemiBold, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 5),

                  ///used to show icon based on subscription plan
                  if (data.user.active_subscription_plan_name != null) ...[
                    Image.asset(
                      data.user.active_subscription_plan_name.activeSubscriptionPlanName.contains("lord")
                          ? APPICONS.lordicon
                          : data.user.active_subscription_plan_name.activeSubscriptionPlanName.contains("god")
                              ? APPICONS.godstatuspng
                              : APPICONS.kingstutspicpng,
                      width: 16.0,
                    ),
                    const Spacer(),
                    const SizedBox(width: 5),
                  ],
                  // used to show berified icon for followers
                  const Icon(
                    Icons.verified,
                    color: Color(0xFF007EFF),
                    size: 14.0,
                  ),
                ],
              ),
              //used to show number and redirect to callpad
              CallNumberView(
                userID: data.user.id.toString(),
                name: data.user.username,
                phoneNumber: data.user.number,
                color: Colors.grey,
                size: 12.0,
                callBack: () async {
                  ProfileRatingModel profile = await Utils.getUserRating(data.user.id.toString());
                  if (profile.data != null && profile.data!.isNotEmpty) {
                    if (profile.data!.first.isShowRating == 0) {
                      Get.dialog(ShowReviewDialog(
                        id: data.user.number!,
                        profile: profile,
                        userID: data.user.id.toString(),
                      ));
                    }
                  } else {
                    Get.dialog(AddReviewDialog(
                      id: data.user.number!,
                      userID: data.user.id.toString(),
                    )).then((value) async {
                      var temp = await provider.viewProfile(data.user.id);
                      await Utils.updateRating(profile.data!.first.id.toString());
                      setState(() {
                        data.user.averageRating = (temp.data != null && temp.data!.averageRating != null)
                            ? double.parse(temp.data!.averageRating.toString())
                            : 0.0;
                      });
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  /// used for top header
  Widget headerWidget(UserViewModel provider) {
    return Consumer<UserViewModel>(builder: (context, provider, child) {
      return Column(
        children: [
          ShapeOfView(
            elevation: 3.0,
            shape: ArcShape(direction: ArcDirection.Outside, height: 30, position: ArcPosition.Bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.76,
              width: Get.width,
              color: secondaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UIHelper.verticalSpaceL,
                  userProfilePhotoModel(provider.userModel.profile!.profileUrl, provider.userModel.username),
                  UIHelper.verticalSpaceSm,
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ProfileRating(id: provider.userModel.id.toString()));
                    },
                    child: MyCustomRatingView(
                      starSize: 19.0,
                      ratinigValue: provider.userModel.avg_review == null
                          ? 0.0
                          : double.parse(provider.userModel.avg_review.toString()),
                      extratext: "${"by".tr} ${provider.userModel.num_of_review_user ?? 0}",
                      fontcolor: whiteColor,
                      fontsize: 13.0,
                    ),
                  ),
                  UIHelper.verticalSpaceSm,
                  NamewithlabelView(
                    displayName: provider.userModel.username!,
                    fontsize: 18.0.sp,
                    iconsize: 22.0,
                    iconname: provider.userModel.is_subscription_active == true
                        ? provider.userModel.active_subscription_plan_name
                        : null,
                    showIcon: provider.userModel.is_subscription_active,
                  ),
                  UIHelper.verticalSpaceSm,

                  /// used to show nickname list given by other users
                  NicknameView(nickName: provider.userModel.getNickName ?? []),
                  UIHelper.verticalSpaceSm,

                  /// used to show number and redirect dialpad
                  CallNumberView(
                    userID: provider.userModel.id.toString(),
                    name: provider.userModel.username,
                    phoneNumber: "${provider.userModel.counryCode ?? ""} ${provider.userModel.number}",
                    callBack: () async {
                      ProfileRatingModel profile = await Utils.getUserRating(provider.userModel.id.toString());
                      if (profile.data != null && profile.data!.isNotEmpty) {
                        if (profile.data!.first.isShowRating == 0) {
                          Get.dialog(ShowReviewDialog(
                            id: "${provider.userModel.counryCode ?? ""} ${provider.userModel.number}",
                            profile: profile,
                            userID: provider.userModel.id.toString(),
                          ));
                        }
                      } else {
                        Get.dialog(AddReviewDialog(
                          id: "${provider.userModel.counryCode ?? ""} ${provider.userModel.number}",
                          userID: provider.userModel.id.toString(),
                        )).then((value) async {
                          var temp = await provider.viewProfile(provider.userModel.id);
                          setState(() {
                            provider.userModel.averageRating = (temp.data != null && temp.data!.averageRating != null)
                                ? double.parse(temp.data!.averageRating.toString())
                                : 0.0;
                          });
                        });
                      }
                    },
                  ),
                  headerWithEdit(
                      label: "Profession".tr,
                      color: whiteColor,
                      ontap: () {
                        Get.bottomSheet(
                                EditProfessionDialogUnregister(isAdd: true, id: provider.userModel.number, isMe: true),
                                isScrollControlled: true)
                            .then((value) async {
                          provider.userModel = await provider.getUserProfileById(Params.UserToken);
                        });
                        /* Get.to(() => const EditMyProfile())!
                            .then((value) async {
                          provider.userModel = await provider
                              .getUserProfileById(Params.UserToken);
                        }); */
                      }),
                  const Divider(
                    color: whiteColor,
                    thickness: 0.3,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        professionBox(
                            byuser: "By User", professiontext: provider.userModel.profile!.profession, show: false),
                        professionBox(
                            byuser: provider.professionByOtherUserModel != null &&
                                    provider.professionByOtherUserModel!.data!.isNotEmpty
                                ? provider.professionByOtherUserModel!.data!.first.username
                                : "By Other User".tr,
                            professiontext: provider.professionByOtherUserModel != null &&
                                    provider.professionByOtherUserModel!.data!.isNotEmpty
                                ? provider.professionByOtherUserModel!.data!.first.profession
                                : "Model".tr,
                            show: true),
                      ],
                    ),
                  ),
                  const Divider(
                    color: whiteColor,
                    thickness: 0.3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      followerBox(
                        quantity: provider.userModel.followersCount.toString(),
                        text: "Followers".tr,
                        onTap: () {
                          if (provider.userModel.is_subscription_active == true &&
                              provider.userModel.active_subscription_plan_name!.contains("god")) {
                            if (provider.userModel.followers != null && provider.userModel.followers!.isNotEmpty) {
                              Get.to(() => FollowersListScreen(
                                    number: provider.userModel.number.toString(),
                                    id: provider.userModel.id.toString(),
                                  ));
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CommonDialog(
                                  title:
                                      "To see the follower/contact list of the person, you must purchase status subscription of God",
                                  buttonTitle: "Subscribe Now",
                                );
                              },
                            );
                          }
                        },
                      ),
                      Container(
                        width: 1,
                        height: 50.0,
                        color: lightGrey,
                      ),
                      followerBox(
                        quantity: provider.userModel.followingCount.toString(),
                        text: "Following".tr,
                        onTap: () {
                          if (provider.userModel.is_subscription_active == true &&
                              provider.userModel.active_subscription_plan_name!.contains("god")) {
                            if (provider.userModel.followingCount != null && provider.userModel.followingCount != 0) {
                              Get.to(() => FollowingList(userid: provider.userModel.id.toString()));
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CommonDialog(
                                  title:
                                      "To see the following/contact list of the person, you must purchase status subscription of God",
                                  buttonTitle: "Subscribe Now",
                                );
                              },
                            );
                          }
                        },
                      )
                    ],
                  ),
                  const Divider(
                    color: whiteColor,
                    thickness: 0.3,
                  ),
                  followerBox(
                    quantity: provider.userModel.visitsCount?.toString() ?? '0',
                    text: "Visits".tr,
                    onTap: () {
                      if (provider.userModel.is_subscription_active == true &&
                          provider.userModel.active_subscription_plan_name!.contains("god")) {
                        if (provider.userModel.visitsCount != null && provider.userModel.visitsCount != 0) {
                          Get.to(() => VisitorScreen(id: provider.userModel.id.toString()));
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CommonDialog(
                              title:
                                  "To see the Visits list of the person, you must purchase status subscription of God",
                              buttonTitle: "Subscribe Now",
                            );
                          },
                        );
                      }
                    },
                  ),
                  UIHelper.verticalSpaceMd,
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  /// used to show profession by me and other users
  Expanded professionBox({required byuser, required professiontext, required show}) {
    return Expanded(
        child: show == false
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: byuser,
                    fontSize: 14.0,
                    color: whiteColor,
                    weight: fontWeightMedium,
                  ),
                  UIHelper.verticalSpaceSm,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 17,
                        child: Image(
                          alignment: Alignment.center,
                          image: AssetImage(APPICONS.casespng),
                        ),
                      ),
                      UIHelper.horizontalSpaceSm,
                      CustomText(
                        text: professiontext,
                        fontSize: 12.0,
                        color: lightGrey,
                        weight: fontWeightRegular,
                      ),
                    ],
                  )
                ],
              )
            : PopupMenuButton(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                constraints:
                    BoxConstraints(maxHeight: Get.height * 0.6, maxWidth: Get.width * 0.7, minWidth: Get.width * 0.4),
                position: PopupMenuPosition.under,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: "By Other User".tr,
                          // text: provider.byOtherUserName,
                          fontSize: 14.0,
                          color: whiteColor,
                          weight: fontWeightMedium,
                        ),
                        if (provider.professionByOtherUserModel != null &&
                            provider.professionByOtherUserModel!.data!.isNotEmpty)
                          Image(
                            fit: BoxFit.cover,
                            height: 35,
                            width: 35,
                            filterQuality: FilterQuality.high,
                            image: AssetImage(
                              APPICONS.copyicon,
                            ),
                          ),
                      ],
                    ),
                    UIHelper.verticalSpaceSm1,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 17,
                          child: Image(
                            alignment: Alignment.center,
                            image: AssetImage(APPICONS.casespng),
                          ),
                        ),
                        UIHelper.horizontalSpaceSm,
                        CustomText(
                          text: provider.byOtherUserProfession,
                          fontSize: 12.0,
                          color: lightGrey,
                          weight: fontWeightRegular,
                        ),
                      ],
                    )
                  ],
                ),
                itemBuilder: (context) {
                  return provider.professionByOtherUserModel!.data!.map((e) {
                    return PopupMenuItem<ProfessionByOtherUserModelData>(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        value: e,
                        child: RichText(
                            text: TextSpan(children: [
                          WidgetSpan(
                              child: CustomText(
                            text: e.profession!,
                            color: Colors.black,
                            fontSize: 16.sp,
                            weight: fontWeightMedium,
                          )),
                          WidgetSpan(
                              child: CustomText(
                            text: (provider.userModel.is_subscription_active != null &&
                                        provider.userModel.is_subscription_active == true) &&
                                    (provider.userModel.active_subscription_plan_name!.contains("god") ||
                                        provider.userModel.active_subscription_plan_name!.contains("king"))
                                ? " (${e.username})"
                                : " (Subscription required)",
                            color: hintColor,
                            fontSize: 14.sp,
                            weight: fontWeightRegular,
                          ))
                        ])));
                  }).toList();
                },
                onSelected: (data) {
                  setState(() {
                    provider.byOtherUserName = data.username ?? "By Other User";
                    provider.byOtherUserProfession = data.profession ?? "-";
                  });
                },
              ));
  }

  Expanded followerBox({required quantity, required text, void Function()? onTap, void Function()? mutualOnTap}) {
    return Expanded(
        child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: quantity,
            fontSize: 24.0,
            color: whiteColor,
            weight: fontWeightSemiBold,
          ),
          UIHelper.verticalSpaceSm1,
          CustomText(
            text: text,
            fontSize: 12.0,
            color: lightGrey,
            weight: fontWeightRegular,
          ),
        ],
      ),
    ));
  }

  Widget headerWithEdit({required label, color, child, ontap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          fontSize: 18.0.sp,
          weight: fontWeightBold,
          color: color ?? Colors.black,
        ),
        child ??
            GestureDetector(
              onTap: ontap,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                color: primaryColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: GestureDetector(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit_outlined,
                          color: whiteColor,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        CustomText(
                          text: "Edit",
                          fontSize: 15.0.sp,
                          weight: fontWeightMedium,
                          color: whiteColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ],
    );
  }

  /// used to open facebook
  void openFacebookProfile(String userId) async {
    final url = 'https://www.facebook.com/$userId';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Could not launch $url');
    }
  }

  /// used to open instagram
  void openInstagramProfile(String userId) async {
    final url = 'https://www.instagram.com/$userId';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Could not launch $url');
    }
  }

  /// used to open email
  void openEmail(String emailAddress) async {
    final url = 'mailto:$emailAddress';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Could not launch $url');
    }
  }

  /// used to show popup menu
  popupMenu(String userid, int index, String commentid, bool isReply, isDeleted) {
    return PopupMenuButton(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      offset: const Offset(0, 6),
      position: PopupMenuPosition.under,
      iconSize: 22,
      icon: const Icon(
        Icons.more_vert,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      itemBuilder: (context) {
        return [
          if ((provider.userModel.is_subscription_active != null &&
                  provider.userModel.is_subscription_active == true) &&
              (provider.userModel.active_subscription_plan_name != null &&
                  (provider.userModel.active_subscription_plan_name!.contains("god") ||
                      provider.userModel.active_subscription_plan_name!.contains("king")))) ...[
            // if (Params.Id == userid && isDeleted == 0) ...[
            PopupMenuItem<int>(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                value: 0,
                onTap: () async {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            // shadowColor: Colors.transparent,
                            elevation: 0,
                            shape: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            title: Column(
                              children: [
                                Center(
                                  child: Text(
                                    'Are you sure you want to delete?'.tr,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                  ),
                                ),
                              ],
                            ),
                            content: Text(
                              'In order to delete this comment, you have to purchase status subscriptions'.tr,
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),

                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: Text(
                                  'Cancel'.tr,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff1B2870),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'OK');
                                  if (isReply == false) {
                                    provider.deleteReviews(commentid).then((value) async {
                                      var temp = await provider.getUserProfileById(Params.UserToken);
                                      setState(() {
                                        provider.userModel.reviewList = temp.reviewList;
                                        provider.userModel.reviewList!
                                            .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                                      });
                                    });
                                  } else {
                                    provider.deleteReplyCommenet(commentid).then((value) async {
                                      var temp = await provider.getUserProfileById(Params.UserToken);
                                      setState(() {
                                        provider.userModel.reviewList = temp.reviewList;
                                        provider.userModel.reviewList!
                                            .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                                      });
                                    });
                                  }
                                },
                                child: Text(
                                  'Continue'.tr,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff1B2870),
                                  ),
                                ),
                              ),
                            ],
                          ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    const Image(
                      image: AssetImage("images/delete.png"),
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text("Delete Comment".tr),
                  ],
                )),
          ],
          if (Params.Id != userid) ...[
            PopupMenuItem<int>(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                value: 1,
                onTap: () {
                  provider.reportUser(userid);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    Image.asset(
                      'images/reportUser.png',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 20),
                    Text("Report User".tr),
                  ],
                )),
          ],
        ];
      },
    );
  }

  cancelSubscription() {
    return PopupMenuButton(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      elevation: 10,
      offset: const Offset(-10, 5),
      position: PopupMenuPosition.under,
      iconSize: 22,
      icon: const Icon(
        Icons.more_vert,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      itemBuilder: (context) {
        return [
          if (provider.userModel.is_subscription_active ?? false) ...[
            PopupMenuItem<int>(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              value: 0,
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    // shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    title: Column(
                      children: [
                        Center(
                          child: Text(
                            'Are you sure you want to cancel subscription?'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                      ],
                    ),

                    content: Text(
                      'After canceling subscription you will not be able to access some features'.tr,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),

                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: Text(
                          'Cancel'.tr,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xff1B2870),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                          provider.cancelSubscription();
                        },
                        child: Text(
                          'Continue'.tr,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xff1B2870),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  const Image(
                    image: AssetImage("images/cancelPayment.png"),
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("Cancel Subscription".tr),
                ],
              ),
            ),
          ],
          if (provider.userModel.is_subscription_active == true &&
                  provider.userModel.active_subscription_plan_name != null
              ? provider.userModel.active_subscription_plan_name!.contains("god")
              : false) ...[
            PopupMenuItem<int>(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              value: 1,
              onTap: () {
                Get.to(() => const GodKingUsers());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.person,
                    color: Color(0xFF767680),
                  ),
                  const SizedBox(width: 10),
                  Text("View Gods and Kings User".tr),
                ],
              ),
            ),
          ],
          if (provider.userModel.is_subscription_active == null ||
              provider.userModel.is_subscription_active == false) ...[
            PopupMenuItem<int>(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              value: 2,
              onTap: () {
                Get.to(() => SubscriptionScreen(isNewUser: false));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.wallet,
                    color: Color(0xFF767680),
                  ),
                  const SizedBox(width: 10),
                  Text("Purchase Subscription".tr),
                ],
              ),
            )
          ],
          if (provider.userModel.is_subscription_active == true &&
                  provider.userModel.active_subscription_plan_name != null
              ? provider.userModel.active_subscription_plan_name!.contains("god") ||
                  provider.userModel.active_subscription_plan_name!.contains("king")
              : false) ...[
            PopupMenuItem<int>(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              value: 3,
              onTap: () {
                provider.lookProfile(provider.userModel.isLocked ?? false ? false : true).then((value) {
                  refreshData();
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  Icon(provider.userModel.isLocked ?? false ? Icons.lock_open_rounded : Icons.lock,
                      color: const Color(0xFF767680)),
                  const SizedBox(width: 10),
                  Text(provider.userModel.isLocked ?? false ? "Unlock Profile".tr : "Lock Profile".tr),
                ],
              ),
            ),
          ],
        ];
      },
    );
  }
}

/// used show profile image list
Widget userProfilePhotoModel(url, name) {
  return Consumer<UserViewModel>(builder: (context, provider, child) {
    return ProfileImageViewMe(
      nickName: provider.userModel.getProfiles ?? [],
      name: provider.userModel.username ?? "NA",
    );
  });
}
