import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shimmer/shimmer.dart';
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
import '../../followerscreen/followers_list.dart';
import '../home/DraggableHome/dragable_home.dart';
import 'package:infosha/utils/error_boundary.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:infosha/views/widgets/DOBView.dart';
import 'package:infosha/views/widgets/emailView.dart';
import '../../Controller/models/user_full_model.dart';
import 'package:infosha/views/widgets/AddressView.dart';
import 'package:infosha/views/widgets/gender_view.dart';
import 'package:infosha/views/widgets/rating_view.dart';
import 'package:infosha/views/widgets/vote_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:infosha/views/widgets/common_dialog.dart';
import 'package:infosha/Controller/models/user_model.dart';
import 'package:infosha/Controller/Viewmodel/reaction.dart';
import 'package:infosha/views/widgets/stateCountrView.dart';
import 'package:infosha/views/widgets/call_number_view.dart';
import 'package:infosha/followerscreen/following_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:infosha/screens/feed/component/feed_tile.dart';
import 'package:infosha/views/widgets/common_vote_button.dart';
import 'package:infosha/views/widgets/namewithlabel_view.dart';
import 'package:infosha/views/widgets/profile_image_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infosha/views/widgets/Interstitial_screen.dart';
import 'package:infosha/views/widgets/like_dislike_button.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/feed/controller/feed_model.dart';
import 'package:infosha/screens/ProfileScreen/profilerating.dart';
import 'package:infosha/views/widgets/ads_after_three_visit.dart';
import 'package:infosha/views/widgets/profile_image_view_me.dart';
import 'package:flutter_feed_reaction/widgets/emoji_reaction.dart';
import 'package:infosha/screens/ProfileScreen/visitor_screen.dart';
import 'package:infosha/screens/ProfileScreen/edit_my_profile.dart';
import 'package:infosha/Controller/models/profile_rating_model.dart';
import 'package:infosha/followerscreen/mutual_followers_screen.dart';
import 'package:infosha/followerscreen/mutual_following_screen.dart';
import 'package:infosha/screens/otherprofile/add_review_dialog.dart';
import 'package:infosha/screens/otherprofile/vote_bottom_sheet.dart';
import 'package:infosha/screens/otherprofile/show_review_dialog.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';
import 'package:infosha/views/widgets/social_media_facebook_view.dart';
import 'package:infosha/Controller/models/user_model.dart' as userModel;
import 'package:infosha/screens/otherprofile/edit/edit_bio_screen.dart';
import 'package:infosha/screens/otherprofile/reaction_bottomsheet.dart';
import 'package:infosha/views/widgets/nicknameForUnregisteredUser.dart';
import 'package:infosha/views/widgets/social_media_instagram_view.dart';
import 'package:infosha/screens/otherprofile/all_followers_otheruser.dart';
import 'package:infosha/Controller/models/profession_by_other_user_model.dart';
import 'package:infosha/screens/otherprofile/edit/edit_profession_dialog.dart';
import 'package:infosha/screens/subscription/component/subscription_screen.dart';
import 'package:infosha/screens/otherprofile/edit/edit_social_medial_screen.dart';
import 'package:infosha/screens/viewUnregistered/model/unregistered_user_model.dart';
import 'package:infosha/screens/viewUnregistered/component/review_vote_bottomsheet.dart';
import 'package:infosha/screens/viewUnregistered/model/unregistered_user_model.dart' as te;
import 'package:infosha/screens/viewUnregistered/component/edit_profession_dailog_unregister.dart';

// ignore: must_be_immutable
class ViewProfileScreen extends StatefulWidget {
  String id;

  ViewProfileScreen({Key? key, required this.id}) : super(key: key);

  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  int selectedLikeState = -1;
  late UserViewModel provider;
  late FeedModel providerFeed;
  UserFullModel? viewProfileModel;
  bool isLoading = false;
  ProfessionByOtherUserModel? professionByOtherUserModel;

  // var formKey = GlobalKey<FormState>();
  TextEditingController replyController = TextEditingController();
  int selectedTile = -1, selectedReactionId = -1;
  String byOtherUserName = 'By Other User', byOtherUserProfession = '-';
  bool showDeletedComment = false;
  List<String> temp1 = [];
  Widget? currentPage;
  List<te.GetNickName> popularNumbers = [];
  List<Map<dynamic, dynamic>> data = [];
  var maxOccurrence = 0;
  List<te.GetNickName> nickNameList = [];

  void callback(Widget nextPage) {
    provider.viewProfile(widget.id.toString()).then((value) {
      viewProfileModel = value;
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint("id ==> ${widget.id}");

    provider = Provider.of<UserViewModel>(context, listen: false);
    providerFeed = Provider.of<FeedModel>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    provider.viewProfile(widget.id.toString()).then((value) {
      viewProfileModel = value;

      if (viewProfileModel != null &&
          viewProfileModel!.data != null &&
          viewProfileModel!.data!.reviewList != null &&
          viewProfileModel!.data!.reviewList!.isNotEmpty) {
        viewProfileModel!.data!.reviewList!.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        viewProfileModel!.data!.reviewList!.sort((a, b) => a.is_deleted_comment!.compareTo(b.is_deleted_comment!));
      }

      provider.getProfessionByOtherUser(widget.id.toString(), false).then((value) {
        professionByOtherUserModel = value;

        if (professionByOtherUserModel!.data!.isNotEmpty) {
          byOtherUserName = professionByOtherUserModel!.data!.first.username!;
          byOtherUserProfession = professionByOtherUserModel!.data!.first.profession!;
        }

        setState(() {
          if (viewProfileModel!.data!.likeStatus == true) {
            selectedLikeState = 0;
          } else if (viewProfileModel!.data!.dislikeStatus == true) {
            selectedLikeState = 1;
          } else {
            selectedLikeState = -1;
          }
        });
      });
    }).whenComplete(() {
      /// used to get nickname list
      provider.getNickname(viewProfileModel!.data!.number ?? "").then((value) {
        nickNameList = value;
        List<te.GetNickName>? mainList = [];

        mainList.addAll(nickNameList);

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
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });

      if (provider.userModel.is_subscription_active == null || provider.userModel.is_subscription_active == false) {
        LoadAfterThreeVisit().loadAds(context);
        // InterstitialScreen().showAds();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: VisibilityDetector(
        key: const Key('profile_screen_visibility_detector'),
        onVisibilityChanged: (visibilityInfo) {
          final isVisible = visibilityInfo.visibleFraction > 0;
          // You can update a provider or variable here if needed
          if (providerFeed.isOtherProfileScreenVisible != isVisible) {
            providerFeed.isOtherProfileScreenVisible = isVisible;
            debugPrint("Other Profile Screen visibility updated: $isVisible");
          }
        },
        child: Scaffold(
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: baseColor,
                  ),
                )
              : (viewProfileModel!.data!.isLocked ?? false)
                  ? (getIsUserCanViewTheOpponentProfile(viewProfileModel, provider.userModel)
                      ? getHomeWidget()
                      : SafeArea(
                          child: Stack(
                            children: [
                              Align(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                      size: Get.width * 0.2,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Profile is locked",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                ),
                              )
                            ],
                          ),
                        ))
                  : getHomeWidget(),
        ),
      ),
    );
  }

  getIsUserCanViewTheOpponentProfile(UserFullModel? viewProfileModel, UserModel appUser) {
    if ((appUser.is_subscription_active == true &&
        ((appUser.active_subscription_plan_name!.contains("god")) ||
            appUser.active_subscription_plan_name!.contains("king")))) {
      return true;
    } else {
      return false;
    }
    // if(viewProfileModel != null && viewProfileModel.data != null) {
    //   if ((appUser.is_subscription_active == true && appUser.active_subscription_plan_name!.contains("god"))) {
    //     return true;
    //   } else if ((appUser.is_subscription_active == true && appUser.active_subscription_plan_name!.contains("king")) &&
    //       (viewProfileModel.data!.is_subscription_active == true && viewProfileModel.data!.active_subscription_plan_name!.contains("god"))) {
    //     return false;
    //   } else {
    //     return true;
    //   }
    // } else {
    //   return false;
    // }
  }

  getHomeWidget() {
    return DraggableHome(
      centerTitle: false,
      headerBottomBar: Container(
        transform: Matrix4.translationValues(0, 0, 0),
        child: widget.id.toString() == provider.userModel.id.toString()
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LikeDislikeButton(
                    usercounts: int.parse(viewProfileModel!.data!.likeCount.toString()),
                    isLikeButton: true,
                    likestatus: 0,
                    isActive: selectedLikeState == 0,
                    onTap: () {
                      if ((provider.userModel.is_subscription_active == true &&
                              provider.userModel.active_subscription_plan_name!.contains("god")) ||
                          (provider.userModel.is_subscription_active == true &&
                              provider.userModel.active_subscription_plan_name!.contains("king"))) {
                        VoteBottomSheet().showVote(context, viewProfileModel!.data!.number!, true);
                      }
                    },
                    oncallback: (value) {
                      if (value != null) {
                        setState(() {
                          if (selectedLikeState == 0) {
                            selectedLikeState = -1;
                            provider.likeDislike(viewProfileModel!.data!.number, true).then((value) {
                              setState(() {
                                viewProfileModel!.data!.likeCount = value.data!.likeCount;
                                viewProfileModel!.data!.dislikeCount = value.data!.dislikeCount;
                                viewProfileModel!.data!.likeStatus = value.data!.likeStatus;
                                viewProfileModel!.data!.dislikeStatus = value.data!.dislikeStatus;
                              });
                            });
                          } else {
                            selectedLikeState = value;
                            provider.likeDislike(viewProfileModel!.data!.number, true).then((value) {
                              setState(() {
                                viewProfileModel!.data!.likeCount = value.data!.likeCount;
                                viewProfileModel!.data!.dislikeCount = value.data!.dislikeCount;
                                viewProfileModel!.data!.likeStatus = value.data!.likeStatus;
                                viewProfileModel!.data!.dislikeStatus = value.data!.dislikeStatus;
                              });
                            });
                          }
                        });
                      }
                    },
                  ),
                  UIHelper.horizontalSpaceSm,
                  LikeDislikeButton(
                    usercounts:
                        viewProfileModel!.data != null ? int.parse(viewProfileModel!.data!.dislikeCount.toString()) : 0,
                    isLikeButton: false,
                    likestatus: 1,
                    isActive: selectedLikeState == 1,
                    onTap: () {
                      if ((provider.userModel.is_subscription_active == true &&
                              provider.userModel.active_subscription_plan_name!.contains("god")) ||
                          (provider.userModel.is_subscription_active == true &&
                              provider.userModel.active_subscription_plan_name!.contains("king"))) {
                        VoteBottomSheet().showVote(context, viewProfileModel!.data!.number!, false);
                      }
                    },
                    oncallback: (value) {
                      setState(() {
                        if (value != null) {
                          setState(() {
                            if (selectedLikeState == 1) {
                              selectedLikeState = -1;
                              provider.likeDislike(viewProfileModel!.data!.number, false).then((value) {
                                setState(() {
                                  viewProfileModel!.data!.likeCount = value.data!.likeCount;
                                  viewProfileModel!.data!.dislikeCount = value.data!.dislikeCount;
                                  viewProfileModel!.data!.likeStatus = value.data!.likeStatus;
                                  viewProfileModel!.data!.dislikeStatus = value.data!.dislikeStatus;
                                });
                              });
                            } else {
                              selectedLikeState = value;
                              provider.likeDislike(viewProfileModel!.data!.number, false).then((value) {
                                setState(() {
                                  viewProfileModel!.data!.likeCount = value.data!.likeCount;
                                  viewProfileModel!.data!.dislikeCount = value.data!.dislikeCount;
                                  viewProfileModel!.data!.likeStatus = value.data!.likeStatus;
                                  viewProfileModel!.data!.dislikeStatus = value.data!.dislikeStatus;
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
          viewProfileModel!.data!.profile!.profileUrl != "https://via.placeholder.com/150"
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: viewProfileModel?.data?.profile?.profileUrl ?? "",
                    width: Get.width * 0.08,
                    height: Get.height * 0.04,
                    fit: BoxFit.fill,
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: Get.height * 0.026,
                      child: CustomText(
                        text: UIHelper.getShortName(string: viewProfileModel!.data!.username, limitTo: 2),
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
                    text: UIHelper.getShortName(string: viewProfileModel!.data!.username, limitTo: 2),
                    fontSize: 20.0,
                    color: Colors.black,
                    weight: fontWeightMedium,
                  ),
                ),
          UIHelper.horizontalSpaceSm,
          SizedBox(
            width: Get.width * 0.44,
            child: CustomText(
              text: viewProfileModel!.data!.username ?? "",
              fontSize: 16.0,
              weight: fontWeightMedium,
              color: Colors.black,
            ),
          )
        ],
      ),
      actions: [
        UIHelper.horizontalSpaceSm,
        PopupMenuButton(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          // constraints: const BoxConstraints(maxHeight: 150, maxWidth: 190),
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
              if (provider.userModel.id.toString() != widget.id) ...[
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
                                        'Are you sure you want to block?'.tr,
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
                                      provider.blockUser(viewProfileModel!.data!.id.toString());
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage("images/delete.png"),
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Block User".tr),
                      ],
                    )),
                PopupMenuItem<int>(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    value: 1,
                    onTap: () {
                      provider.reportUser(viewProfileModel!.data!.id.toString());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'images/reportUser.png',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Report User".tr),
                      ],
                    ))
              ],
              if (provider.userModel.is_subscription_active != null &&
                  provider.userModel.is_subscription_active == true &&
                  provider.userModel.active_subscription_plan_name!.contains("god")) ...[
                PopupMenuItem<int>(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    value: 1,
                    onTap: () {
                      Get.to(() => VisitorScreen(id: viewProfileModel!.data!.id.toString()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          "images/visitor.png",
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Visitor".tr),
                      ],
                    )),
              ]
            ];
          },
        )
      ],
      headerExpandedHeight: 0.72,
      expandedHeight: MediaQuery.of(context).size.height * 0.83,
      alwaysShowLeadingAndAction: true,
      headerWidget: headerWidget(viewProfileModel),
      curvedBodyRadius: 0,
      body: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Consumer<UserViewModel>(builder: (context, provider, child) {
            return Column(
              children: [
                headerWithEdit(
                    label: "Bio".tr,
                    ontap: () {
                      if (provider.userModel.id.toString() == widget.id) {
                        Get.to(() => const EditMyProfile())!.then((value) {
                          provider.getProfessionByOtherUser(widget.id.toString(), false).then((value) {
                            professionByOtherUserModel = value;

                            setState(() {
                              if (professionByOtherUserModel!.data!.isNotEmpty) {
                                byOtherUserName = professionByOtherUserModel!.data!.first.username!;
                                byOtherUserProfession = professionByOtherUserModel!.data!.first.profession!;
                              }
                            });
                          });
                          provider.viewProfile(widget.id.toString()).then((value) {
                            viewProfileModel = value;
                            provider.notifyListeners();
                            setState(() {});
                          });
                        });
                      } else {
                        Get.to(() =>
                                EditBioScreen(isMyProfile: false, id: widget.id, viewProfileModel: viewProfileModel!))!
                            .then((value) {
                          provider.getProfessionByOtherUser(widget.id.toString(), false).then((value) {
                            professionByOtherUserModel = value;

                            setState(() {
                              if (professionByOtherUserModel!.data!.isNotEmpty) {
                                byOtherUserName = professionByOtherUserModel!.data!.first.username!;
                                byOtherUserProfession = professionByOtherUserModel!.data!.first.profession!;
                              }
                            });
                          });
                          provider.viewProfile(widget.id.toString()).then((value) {
                            viewProfileModel = value;
                            provider.notifyListeners();
                            setState(() {});
                          });
                        });
                      }
                    },
                    show:
                        true /* provider.userModel.is_subscription_active !=
                                        null
                                    ? provider.userModel.is_subscription_active ??
                                        false
                                    : false */
                    ),
                UIHelper.verticalSpaceSm,
                /* ListTilewidget(
                                txt: viewProfileModel!.data!.profile!.gender !=
                                            null ||
                                        viewProfileModel!.data!.profile!.gender ==
                                            "gender"
                                    ? toBeginningOfSentenceCase(
                                        viewProfileModel!.data!.profile!.gender!)
                                    : "-"), */
                /* ListTilewidget(
                                image: "images/cases.png",
                                txt:
                                    "DOB: ${viewProfileModel!.data!.profile!.dob == "" ? "-" : DateFormat('dd/MM/yyyy').format(DateFormat("dd/MM/yyyy").parse(viewProfileModel!.data!.profile!.dob.toString()))}"), */
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
                        nickName: viewProfileModel!.data!.getGender!.isNotEmpty
                            ? viewProfileModel!.data!.getGender ?? []
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
                        nickName:
                            viewProfileModel!.data!.getDob!.isNotEmpty ? viewProfileModel!.data!.getDob ?? [] : []),
                  ],
                ),
                const SizedBox(height: 5),

                /* ListTilewidget(
                                image: "images/locationnn.png",
                                txt: viewProfileModel!.data!.profile != null
                                    ? "${viewProfileModel!.data!.profile!.city != null ? "${toBeginningOfSentenceCase(viewProfileModel!.data!.profile!.city)}, " : ""}${viewProfileModel!.data!.profile!.state != null ? "${toBeginningOfSentenceCase(viewProfileModel!.data!.profile!.state)}, " : ""}${viewProfileModel!.data!.profile!.country != null ? toBeginningOfSentenceCase(viewProfileModel!.data!.profile!.country) : ""}"
                                    : "Location not found"), */
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
                    StateCountryOtherView(
                        nickName: viewProfileModel!.data!.getAddress!.isNotEmpty
                            ? viewProfileModel!.data!.getAddress ?? []
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
                    AddressView(
                      nickName: viewProfileModel!.data!.getAddressOther!.isNotEmpty
                          ? viewProfileModel!.data!.getAddressOther ?? []
                          : [],
                      title: "getAddressOther",
                    ),
                  ],
                ),
                UIHelper.verticalSpaceMd,
                headerWithEdit(
                    label: "Social Media".tr,
                    ontap: () {
                      if (provider.userModel.id.toString() == widget.id) {
                        Get.to(() => const EditMyProfile())!.then((value) {
                          provider.viewProfile(widget.id.toString()).then((value) {
                            viewProfileModel = value;
                            provider.notifyListeners();
                            setState(() {});
                          });
                        });
                      } else {
                        Get.to(() => EditSocialMedialScreen(
                                  isMyProfile: false,
                                  viewProfileModel: viewProfileModel!,
                                  id: widget.id,
                                ))!
                            .then((value) {
                          provider.viewProfile(widget.id.toString()).then((value) {
                            viewProfileModel = value;
                            provider.notifyListeners();
                            setState(() {});
                          });
                        });
                      }
                    },
                    show:
                        true /* provider.userModel.is_subscription_active !=
                                        null
                                    ? provider.userModel.is_subscription_active ??
                                        false
                                    : false */
                    ),
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
                          viewProfileModel!.data!.getEmail != null && viewProfileModel!.data!.getEmail!.isNotEmpty
                              ? EmailView(
                                  nickName: viewProfileModel!.data!.getEmail!.isNotEmpty
                                      ? viewProfileModel!.data!.getEmail ?? []
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
                          viewProfileModel!.data!.getSocial != null && viewProfileModel!.data!.getSocial!.isNotEmpty
                              ? SocialMediaFacebookView(
                                  nickName: viewProfileModel!.data!.getSocial!.isNotEmpty
                                      ? viewProfileModel!.data!.getSocial ?? []
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
                          viewProfileModel!.data!.getSocialOther != null &&
                                  viewProfileModel!.data!.getSocialOther!.isNotEmpty
                              ? SocialMediaInstagramView(
                                  nickName: viewProfileModel!.data!.getSocialOther!.isNotEmpty
                                      ? viewProfileModel!.data!.getSocialOther ?? []
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
                if (viewProfileModel!.data!.profileMany != null && viewProfileModel!.data!.profileMany!.isNotEmpty) ...[
                  headerWithEdit(
                    label: "Added By".tr,
                    child: GestureDetector(
                      onTap: () {
                        if (provider.userModel.is_subscription_active == true &&
                            provider.userModel.active_subscription_plan_name!.contains("god")) {
                          /*Get.to(() => AllFollowersOtheruser(
                                        followersList:
                                            viewProfileModel!.data!.followers!));*/

                          Get.to(() => FollowersListScreen(
                                number: viewProfileModel!.data!.number.toString(),
                                id: viewProfileModel!.data!.id.toString(),
                              ));
                        }
                      },
                      child: Text(
                        "See All".tr,
                        style: const TextStyle(
                            color: Color(0xFf1B2870), fontSize: 14, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  UIHelper.verticalSpaceSm,
                  SizedBox(
                    height: Get.height * 0.25,
                    child: ListView.builder(
                        itemCount: viewProfileModel!.data!.profileMany!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var data = viewProfileModel!.data!.profileMany![index];
                          return addedByContainer(data);
                        }),
                  ),
                ],
                UIHelper.verticalSpaceMd,
                if ((viewProfileModel!.data!.followers != null && viewProfileModel!.data!.followers!.isNotEmpty) &&
                    (provider.userModel.is_subscription_active == true &&
                        provider.userModel.active_subscription_plan_name!.contains("god"))) ...[
                  headerWithEdit(
                    show: true,
                    label: "Followers".tr,
                    child: GestureDetector(
                      onTap: () {
                        /*Get.to(() => AllFollowersOtheruser(
                                      followersList:
                                          viewProfileModel!.data!.followers!));*/

                        if (provider.userModel.is_subscription_active == true &&
                            provider.userModel.active_subscription_plan_name!.contains("god")) {
                          Get.to(() => FollowersListScreen(
                                number: viewProfileModel!.data!.number.toString(),
                                id: viewProfileModel!.data!.id.toString(),
                              ));
                        }
                      },
                      child: Text(
                        "See All".tr,
                        style: const TextStyle(
                            color: Color(0xFf1B2870), fontSize: 14, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  UIHelper.verticalSpaceSm,
                  SizedBox(
                    height: Get.height * 0.25,
                    child: ListView.builder(
                        itemCount: viewProfileModel!.data!.followers!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var data = viewProfileModel!.data!.followers![index];
                          return followerAdaptor(
                              data.id.toString(),
                              data.profile != null ? data.profile!.profileUrl! : "",
                              data.averageRating != null ? double.parse(data.averageRating.toString()) : 0.0,
                              data.profile != null ? data.profile!.profession : "",
                              data.username ?? "",
                              data.active_subscription_plan_name != null
                                  ? data.active_subscription_plan_name ?? ""
                                  : "",
                              data.number ?? "",
                              index);
                        }),
                  ),
                ],
                UIHelper.verticalSpaceSm,
                UIHelper.verticalSpaceMd,
                headerWithEdit(
                    label: "Reviews".tr,
                    child: widget.id.toString() == provider.userModel.id.toString() ? Container() : addReviewButton(),
                    show: true),
                if (viewProfileModel!.data!.reviewList != null) ...[
                  UIHelper.verticalSpaceSm,
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: viewProfileModel!.data!.reviewList!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return reviewAdaptor(context, viewProfileModel!.data!.reviewList![index], index,
                          viewProfileModel!.data!.reviewList!);
                    },
                    separatorBuilder: (context, index) => const Divider(
                      height: 20,
                      color: Colors.transparent,
                    ),
                  ),
                  if ((provider.userModel.is_subscription_active != null
                          ? provider.userModel.is_subscription_active == true
                          : false) &&
                      (provider.userModel.active_subscription_plan_name != null
                          ? provider.userModel.active_subscription_plan_name.toString().contains("god")
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
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(22), color: const Color(0xFFE12C2C)),
                        child: Text(showDeletedComment ? "Hide deleted comments".tr : "Show deleted comments".tr,
                            style: GoogleFonts.workSans(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    )
                  ]
                ],
              ],
            );
          }),
        ),
        UIHelper.verticalSpaceSm,
        (Provider.of<UserViewModel>(context, listen: false).userModel.is_subscription_active != null &&
                    Provider.of<UserViewModel>(context, listen: false).userModel.is_subscription_active == true) &&
                (Provider.of<UserViewModel>(context, listen: false)
                        .userModel
                        .active_subscription_plan_name!
                        .contains("god") ||
                    Provider.of<UserViewModel>(context, listen: false)
                        .userModel
                        .active_subscription_plan_name!
                        .contains("king"))
            ? const SizedBox()
            : Card(
                margin: const EdgeInsets.all(20),
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
      fullyStretchable: false,
      backgroundColor: Colors.white,
      appBarColor: Colors.white,
    );
  }

  SizedBox loadingWidget() {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Column(
        children: [
          SizedBox(
            width: Get.width,
            height: 300,
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              child: ShapeOfView(
                elevation: 3.0,
                shape: ArcShape(direction: ArcDirection.Outside, height: 30, position: ArcPosition.Bottom),
                child: Container(
                  // height: 300,
                  width: Get.width,
                  color: secondaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ),
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

  reviewAdaptor(
    BuildContext context,
    ReviewList model,
    int index,
    List<ReviewList> list,
  ) {
    viewProfileModel!.data!.reviewList![index].repliesComment!.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    selectedReactionId = getReactionId(model.reactionName ?? "");

    return Visibility(
      visible: model.is_deleted_comment.toString() == "0" ||
          (showDeletedComment && model.is_deleted_comment.toString() == "1"),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: GestureDetector(
          onTap: () {
            if (model.user_nickname != "Anonymous") {
              Get.to(() => ViewProfileScreen(id: list[index].reviewerId.toString()));
            }
          },
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
                  Row(
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
                                : */ /*  provider.userModel.is_subscription_active ==
                                            true &&
                                        (provider.userModel
                                                .active_subscription_plan_name!
                                                .contains("god") ||
                                            provider.userModel
                                                .active_subscription_plan_name!
                                                .contains("king"))
                                    ? */
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
                            // width: 108,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyCustomRatingView(
                                  starSize: 12.0,
                                  ratinigValue: model.rating != null ? double.parse(model.rating.toString()) : 0.0,
                                ),
                                // MenuPopupClass(),
                                popupMenu(model.reviewerId.toString(), index, model.id.toString(), false,
                                    model.is_deleted_comment)
                              ],
                            ),
                          ),
                          //subtitle:
                          contentPadding: const EdgeInsets.only(right: 1, left: 10),
                        ),
                      ),
                    ],
                  ),
                  Padding(
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
                            UserViewModel provider =
                                Provider.of(context, listen: false);
                            provider
                                .addReaction(model.id.toString(),
                                    model.reactionName.toString())
                                .then((value) {
                              setState(() {
                                model.totalReactionCount = value;
                                model.reactionName = null;
                                selectedReactionId = -1;
                              });
                            });
                          } */
                          ReactionBottomSheet().showReactions(context, model.id.toString());
                        },
                      )
                      /* MyReactionButton(
                        reactionCount: viewProfileModel!
                            .data!.reviewList![index].totalReactionCount
                            .toString(),
                        commentid: viewProfileModel!.data!.reviewList![index].id
                            .toString(),
                        reactionName: viewProfileModel!
                                .data!.reviewList![index].reactionName ??
                            "null",
                        oncallback: (val) {
                          setState(() {
                            viewProfileModel!
                                .data!.reviewList![index].totalReactionCount = val;
                          });
                        },
                      ) */
                      ,
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
                        // color: Colors.white,
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
                            setState(() {
                              model.isLiked = true;
                              model.isDisliked = false;
                              model.likeCount = value.likeCount;
                              model.dislikeCount = value.disLikeCount;
                            });
                          });
                        },
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: Colors.black38,
                      ),
                      CommonVoteButton(
                        usercounts: int.parse(model.dislikeCount.toString()),
                        isLikeButton: false,
                        likestatus: 0,
                        isActive:
                            model.isLiked == false && (model.likeCount != 0 || model.dislikeCount != 0) ? true : false,
                        // color: Colors.white,
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
                            setState(() {
                              model.isLiked = false;
                              model.isDisliked = true;
                              model.likeCount = value.likeCount;
                              model.dislikeCount = value.disLikeCount;
                            });
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
                                  style:
                                      const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                      visible: selectedTile == index,
                      child: Column(
                        children: [
                          const Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                          Container(
                            // height: 100,
                            width: Get.width,

                            color: const Color(0xFfEDF1F1),
                            child: Row(children: [
                              if (model.is_deleted_comment.toString() != "1") ...[
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    alignment: Alignment.center,
                                    child: Form(
                                      key: model.formKey,
                                      child: TextFormField(
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                                  widget.id.toString())
                                              .then((value) {
                                            setState(() {
                                              viewProfileModel!.data!.reviewList = value;
                                              viewProfileModel!.data!.reviewList!
                                                  .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                                              viewProfileModel!.data!.reviewList!.sort(
                                                  (a, b) => a.is_deleted_comment!.compareTo(b.is_deleted_comment!));
                                              if (viewProfileModel!.data!.reviewList![index].repliesComment != null) {
                                                viewProfileModel!.data!.reviewList![index].repliesComment!
                                                    .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                                              }
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
                              ],
                            ]),
                          ),
                          if (viewProfileModel!.data!.reviewList![index].repliesComment != null)
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: viewProfileModel!.data!.reviewList![index].repliesComment!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              // separatorBuilder: (context, index) => const Divider(
                              //     height: 10, color: Colors.transparent),
                              itemBuilder: (context, innerIndex) {
                                var replyData = viewProfileModel!.data!.reviewList![index].repliesComment![innerIndex];

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
                                                  trailing: popupMenu(
                                                      replyData.commentUserId.toString(),
                                                      index,
                                                      replyData.id.toString(),
                                                      true,
                                                      replyData.is_deleted_comment_reply),
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
                                                        viewProfileModel!
                                                                .data!.reviewList![index].repliesComment!.length -
                                                            1
                                                    ? const Radius.circular(15)
                                                    : const Radius.circular(0),
                                                bottomRight: innerIndex ==
                                                        viewProfileModel!
                                                                .data!.reviewList![index].repliesComment!.length -
                                                            1
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
      ),
    );
  }

  InkWell addReviewButton() {
    return InkWell(
      onTap: () async {
        Get.dialog(AddReviewDialog(
          id: viewProfileModel!.data!.number!,
          userID: widget.id,
        )).then((value) async {
          var temp = await provider.viewProfile(widget.id);
          setState(() {
            viewProfileModel!.data!.reviewList = temp.data!.reviewList;
            viewProfileModel!.data!.reviewList!.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
            viewProfileModel!.data!.reviewList!.sort((a, b) => a.is_deleted_comment!.compareTo(b.is_deleted_comment!));
          });
        });
      },
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
              const SizedBox(
                width: 5,
              ),
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

  followerAdaptor(
      String id, String image, double rating, String profession, String name, String plan, String number, int index) {
    var data = viewProfileModel!.data!.followers![index];
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProfileScreen(id: id)));
        // Get.to(() => OtheruserprofileScreen(id: data.id.toString()));
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
                  child: image.isEmpty || image == "https://via.placeholder.com/150"
                      ? Image.asset('images/aysha.png')
                      : isBase64(image)
                          ? Image.memory(base64Decode(image), fit: BoxFit.cover)
                          : CachedNetworkImage(
                              imageUrl: image,
                              fit: BoxFit.fill,
                              errorWidget: (context, url, error) => Image.asset('images/aysha.png'),
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(color: baseColor),
                              ),
                            ),
                ),
              ),
              MyCustomRatingView(
                starSize: 12.0,
                ratinigValue: rating,
              ),
              CustomText(
                text: profession,
                fontSize: 12.0,
                weight: fontWeightMedium,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // width: Get.width * 0.25,
                    // color: Colors.red,
                    constraints: BoxConstraints(maxWidth: Get.width * 0.25),
                    child: AutoSizeText(
                      name,
                      maxLines: 1,
                      minFontSize: 10,
                      maxFontSize: 16.0,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: textStyleWorkSense(weight: fontWeightSemiBold, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (plan.isNotEmpty) ...[
                    Image.asset(
                      plan.contains("lord")
                          ? APPICONS.lordicon
                          : plan.contains("god")
                              ? APPICONS.godstatuspng
                              : APPICONS.kingstutspicpng,
                      width: 16.0,
                    ),
                    const SizedBox(width: 5),
                  ],
                  const Icon(
                    Icons.verified,
                    color: Color(0xFF007EFF),
                    size: 14.0,
                  ),
                ],
              ),
              CallNumberView(
                userID: data.id.toString(),
                name: data.username,
                phoneNumber: number,
                color: Colors.grey,
                size: 12.0,
                callBack: () async {
                  ProfileRatingModel profile = await Utils.getUserRating(data.id.toString());
                  if (profile.data != null && profile.data!.isNotEmpty) {
                    if (profile.data!.first.isShowRating == 0) {
                      Get.dialog(ShowReviewDialog(
                        id: data.number!,
                        profile: profile,
                        userID: data.id.toString(),
                      ));
                    }
                  } else {
                    Get.dialog(AddReviewDialog(
                      id: data.number!,
                      userID: data.id.toString(),
                    )).then((value) async {
                      var temp = await provider.viewProfile(data.id);
                      setState(() {
                        data.averageRating = (temp.data != null && temp.data!.averageRating != null)
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

  Widget ListTilewidget({image, txt, colorr, isFullWidth, isimageicon, ontap}) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: isFullWidth == null ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              color: isimageicon != null ? null : colorr ?? const Color(0xFF767680),
              height: 20,
              width: 20,
              image: AssetImage(
                image ?? "images/person.png",
              ),
            ),
            isFullWidth == null ? UIHelper.horizontalSpaceMd : UIHelper.horizontalSpaceSm,
            SizedBox(
              width: Get.width * 0.8,
              child: CustomText(
                text: txt ?? "Male".tr,
                fontSize: 16.0.sp,
                weight: fontWeightMedium,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget headerWidget(UserFullModel? model) {
    return Column(
      children: [
        ShapeOfView(
          elevation: 3.0,
          shape: ArcShape(direction: ArcDirection.Outside, height: 30, position: ArcPosition.Bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: Get.width,
            color: secondaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UIHelper.verticalSpaceL,
                userProfilePhotoModel(model!.data!.profile!.profileUrl ?? "", model.data!.username ?? ""),
                UIHelper.verticalSpaceSm,
                GestureDetector(
                  onTap: () {
                    Get.to(() => ProfileRating(id: widget.id));
                  },
                  child: MyCustomRatingView(
                    starSize: 19.0,
                    ratinigValue:
                        model.data!.avg_review == null ? 0.0 : double.parse(model.data!.avg_review.toString()),
                    extratext: "${"by".tr} ${model.data!.num_of_review_user ?? 0}",
                    fontcolor: whiteColor,
                    fontsize: 13.0,
                  ),
                ),
                UIHelper.verticalSpaceSm,

                NamewithlabelView(
                  displayName: popularNumbers.isNotEmpty
                      ? popularNumbers.first.name!
                      : model.data!.username != "null"
                          ? model.data!.username!
                          : "" /* model.data!.username != "null"
                      ? model.data!.username!
                      : model.data!.username! */
                  ,
                  fontsize: 18.0.sp,
                  iconsize: 22.0,
                  iconname: model.data!.active_subscription_plan_name,
                  showIcon: true,
                ),
                UIHelper.verticalSpaceSm,
                NicknameUnRegisteredView(nickName: nickNameList),
                UIHelper.verticalSpaceSm,
                CallNumberView(
                  userID: model.data!.id.toString(),
                  name: model.data!.username,
                  phoneNumber: "${model.data!.countryCode ?? ""} ${model.data!.number}",
                  callBack: () async {
                    ProfileRatingModel profile = await Utils.getUserRating(widget.id);
                    if (profile.data != null && profile.data!.isNotEmpty) {
                      if (profile.data!.first.isShowRating == 0) {
                        Get.dialog(ShowReviewDialog(
                          id: viewProfileModel!.data!.number!,
                          profile: profile,
                          userID: widget.id,
                        ));
                      }
                    } else {
                      Get.dialog(AddReviewDialog(
                        id: viewProfileModel!.data!.number!,
                        userID: widget.id,
                      )).then((value) async {
                        var temp = await provider.viewProfile(widget.id);
                        setState(() {
                          viewProfileModel!.data!.reviewList = temp.data!.reviewList;
                          viewProfileModel!.data!.reviewList!.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                          viewProfileModel!.data!.reviewList!
                              .sort((a, b) => a.is_deleted_comment!.compareTo(b.is_deleted_comment!));
                        });
                      });
                    }
                  },
                ),
                headerWithEdit(
                    label: "Profession".tr,
                    color: whiteColor,
                    ontap: () {
                      if (provider.userModel.id.toString() == widget.id) {
                        Get.bottomSheet(
                                EditProfessionDialogUnregister(
                                    isAdd: true, id: provider.userModel.number, isMe: true, callback: callback),
                                isScrollControlled: true)
                            .then((value) {
                          provider.viewProfile(widget.id.toString()).then((value) {
                            viewProfileModel = value;
                            provider.notifyListeners();
                            setState(() {});
                          });
                        });
                      } else {
                        Get.bottomSheet(
                                EditProfessionDialog(
                                  isAdd: true,
                                  id: widget.id,
                                  existingProfession: (professionByOtherUserModel?.data != null &&
                                          professionByOtherUserModel!.data!.isNotEmpty)
                                      ? professionByOtherUserModel!.data!.first.profession
                                      : null,
                                ),
                                isScrollControlled: true)
                            .then((value) {
                          provider.getProfessionByOtherUser(widget.id.toString(), false).then((value) {
                            professionByOtherUserModel = value;

                            setState(() {
                              if (professionByOtherUserModel!.data!.isNotEmpty) {
                                byOtherUserName = professionByOtherUserModel!.data!.first.username!;
                                byOtherUserProfession = professionByOtherUserModel!.data!.first.profession!;
                              }
                            });
                          });
                        });
                      }
                    },
                    show:
                        true /* provider.userModel.is_subscription_active != null
                        ? provider.userModel.is_subscription_active ?? false
                        : false */
                    ),
                const Divider(
                  color: whiteColor,
                  thickness: 0.3,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      professionBox(
                          byuser: "By User".tr, professiontext: model.data!.profile!.profession ?? "-", show: false),
                      professionBox(
                          byuser: /* professionByOtherUserModel != null &&
                                  professionByOtherUserModel!.data!.isNotEmpty
                              ? professionByOtherUserModel!.data!.first.username
                              : */
                              "By Other User".tr,
                          professiontext:
                              professionByOtherUserModel != null && professionByOtherUserModel!.data!.isNotEmpty
                                  ? professionByOtherUserModel!.data!.first.profession
                                  : "Model".tr,
                          show: true),
                    ],
                  ),
                ),
                const Divider(
                  color: whiteColor,
                  thickness: 0.3,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     followerBox(
                //       quantity: model.data != null
                //           ? model.data!.followersCount.toString()
                //           : "0",
                //       text: "Followers".tr,
                //       onTap: () {
                //         if (provider.userModel.is_subscription_active == true &&
                //             provider.userModel.active_subscription_plan_name!
                //                 .contains("god")) {
                //           if (viewProfileModel!.data!.followers != null &&
                //               viewProfileModel!.data!.followers!.isNotEmpty) {
                //             Get.to(() => FollowersListScreen(
                //                 number:
                //                     viewProfileModel!.data!.number.toString()));
                //           }
                //         } else {
                //           showDialog(
                //             context: context,
                //             builder: (context) {
                //               return CommonDialog(
                //                 title:
                //                     "To see the following/contact list of the person, you must purchase status subscription of God",
                //                 buttonTitle: "Subscribe Now",
                //               );
                //             },
                //           );
                //         }
                //       },
                //     ),
                //     Container(
                //       width: 1,
                //       height: 50.0,
                //       color: lightGrey,
                //     ),
                //     followerBox(
                //       quantity: model.data != null
                //           ? model.data!.followingCount.toString()
                //           : "0",
                //       text: "Following".tr,
                //       onTap: () {
                //         if (provider.userModel.is_subscription_active == true &&
                //             provider.userModel.active_subscription_plan_name!
                //                 .contains("god")) {
                //           Get.to(() =>
                //               FollowingList(userid: model.data!.id.toString()));
                //         } else {
                //           showDialog(
                //             context: context,
                //             builder: (context) {
                //               return CommonDialog(
                //                 title:
                //                     "To see the following/contact list of the person, you must purchase status subscription of God",
                //                 buttonTitle: "Subscribe Now",
                //               );
                //             },
                //           );
                //         }
                //       },
                //     ),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    followerBox(
                        quantity: model.data != null ? model.data!.followersCount.toString() : "0",
                        text: "Followers".tr,
                        mutual: model.data != null ? model.data!.mutualFollowers.toString() : "0",
                        onTap: () {
                          if (provider.userModel.is_subscription_active == true &&
                              provider.userModel.active_subscription_plan_name!.contains("god")) {
                            if (viewProfileModel!.data!.followers != null &&
                                viewProfileModel!.data!.followers!.isNotEmpty) {
                              Get.to(() => FollowersListScreen(
                                    number: viewProfileModel!.data!.number.toString(),
                                    id: viewProfileModel!.data!.id.toString(),
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
                        onTapMutual: () {
                          if (provider.userModel.is_subscription_active == true &&
                              provider.userModel.active_subscription_plan_name!.contains("god")) {
                            Get.to(() => MutualFollowersList(
                                  number: viewProfileModel!.data!.number.toString(),
                                  id: viewProfileModel!.data!.id.toString(),
                                ));
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CommonDialog(
                                  title:
                                      "To see the mutual follower/contact list of the person, you must purchase status subscription of God",
                                  buttonTitle: "Subscribe Now",
                                );
                              },
                            );
                          }
                        }),
                    Container(
                      width: 1,
                      height: 50.0,
                      color: lightGrey,
                    ),
                    followerBox(
                        quantity: model.data != null ? model.data!.followingCount.toString() : "0",
                        text: "Following".tr,
                        mutual: model.data != null ? model.data!.mutualFollowings.toString() : "0",
                        onTap: () {
                          if (provider.userModel.is_subscription_active == true &&
                              provider.userModel.active_subscription_plan_name!.contains("god")) {
                            Get.to(() => FollowingList(userid: model.data!.id.toString()));
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
                        onTapMutual: () {
                          if (provider.userModel.is_subscription_active == true &&
                              provider.userModel.active_subscription_plan_name!.contains("god")) {
                            Get.to(() => MutualFollowingList(
                                  userid: model.data!.id.toString(),
                                  isFromFollowers: false,
                                ));
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CommonDialog(
                                  title:
                                      "To see the mutual following/contact list of the person, you must purchase status subscription of God",
                                  buttonTitle: "Subscribe Now",
                                );
                              },
                            );
                          }
                        }),
                  ],
                ),
                const Divider(
                  color: whiteColor,
                  thickness: 0.3,
                ),
                UIHelper.verticalSpaceSm1,
                followerBox(
                    quantity: model.data?.visitsCount != null ? model.data!.visitsCount.toString() : "0",
                    text: "Visits".tr,
                    mutual: null,
                    onTap: () {
                      if (provider.userModel.is_subscription_active == true &&
                          provider.userModel.active_subscription_plan_name!.contains("god")) {
                        if (viewProfileModel!.data!.visitsCount != null) {
                          Get.to(() => VisitorScreen(
                                id: viewProfileModel!.data!.id.toString(),
                              ));
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
                    onTapMutual: () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
                    Row(children: [
                      CustomText(
                        text: "By Other User".tr,
                        // text: byOtherUserName,
                        fontSize: 14.0,
                        color: whiteColor,
                        weight: fontWeightMedium,
                      ),
                      if (professionByOtherUserModel != null) ...[
                        if (professionByOtherUserModel!.data!.isNotEmpty) ...[
                          Image(
                            fit: BoxFit.cover,
                            height: 35,
                            width: 35,
                            filterQuality: FilterQuality.high,
                            image: AssetImage(
                              APPICONS.copyicon,
                            ),
                          ),
                        ]
                      ],
                    ]),
                    UIHelper.verticalSpaceSm1,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 17,
                          child: Image(
                            alignment: Alignment.center,
                            image: AssetImage(APPICONS.casespng),
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: Get.width * 0.385,
                          child: CustomText(
                            text: byOtherUserProfession,
                            fontSize: 12.0,
                            color: lightGrey,
                            weight: fontWeightRegular,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                itemBuilder: (context) {
                  return professionByOtherUserModel!.data!.map((e) {
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
                    byOtherUserName = data.username ?? "By Other User";
                    byOtherUserProfession = data.profession ?? "-";
                  });
                },
              ));
  }

  Expanded followerBox(
      {required quantity, required text, void Function()? onTap, void Function()? onTapMutual, mutual}) {
    if (mutual == "null") {
      mutual = "0";
    }
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
          mutual != null && mutual != 0
              ? GestureDetector(
                  onTap: onTapMutual,
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(top: 15, bottom: 8, left: 40, right: 40),
                    child: CustomText(
                      text: "Mutual: $mutual",
                      fontSize: 14.0,
                      color: lightGrey,
                      weight: fontWeightMedium,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    ));
  }

  Widget headerWithEdit({required label, color, child, ontap, bool? show}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          fontSize: 18.0.sp,
          weight: fontWeightBold,
          color: color ?? Colors.black,
        ),
        if (show ?? false) ...[
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
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            text: "Edit".tr,
                            fontSize: 15.0.sp,
                            weight: fontWeightMedium,
                            color: whiteColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
        ],
      ],
    );
  }

  Widget userProfilePhotoModel(String url, String name) {
    /* return ProfileImageView(
        nickName: viewProfileModel!.data!.getProfile ?? [],
        name: viewProfileModel!.data!.username ?? "NA");
 */

    return provider.userModel.id.toString() == widget.id
        ? ProfileImageViewMe(
            nickName: viewProfileModel!.data!.getProfile!
                .map((e) => userModel.GetProfiles(addedBy: e.addedBy, profile: e.profile))
                .toList(),
            name: viewProfileModel!.data!.username ?? "NA")
        : ProfileImageView(
            nickName: viewProfileModel!.data!.getProfile ?? [], name: viewProfileModel!.data!.username ?? "NA");
  }

  void openFacebookProfile(String userId) async {
    final url = 'https://www.facebook.com/$userId';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint('Could not launch $url');
    }
  }

  void openInstagramProfile(String userId) async {
    final url = 'https://www.instagram.com/$userId';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint('Could not launch $url');
    }
  }

  void openEmail(String emailAddress) async {
    final url = 'mailto:$emailAddress';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint('Could not launch $url');
    }
  }

  popupMenu(String userid, int index, String commentid, bool isReply, isDeleted) {
    return PopupMenuButton(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      // constraints:
      //     const BoxConstraints(maxHeight: 150, maxWidth: 190),
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
          if (Params.Id == userid && isDeleted == 0) ...[
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
                                      var temp = await provider.viewProfile(widget.id);
                                      setState(() {
                                        viewProfileModel!.data!.reviewList = temp.data!.reviewList;
                                        viewProfileModel!.data!.reviewList!
                                            .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                                        viewProfileModel!.data!.reviewList!
                                            .sort((a, b) => a.is_deleted_comment!.compareTo(b.is_deleted_comment!));
                                      });
                                    });
                                  } else {
                                    provider.deleteReplyCommenet(commentid).then((value) async {
                                      var temp = await provider.viewProfile(widget.id);
                                      setState(() {
                                        viewProfileModel!.data!.reviewList = temp.data!.reviewList;
                                        viewProfileModel!.data!.reviewList!
                                            .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                                        viewProfileModel!.data!.reviewList!
                                            .sort((a, b) => a.is_deleted_comment!.compareTo(b.is_deleted_comment!));
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                ))
          ],
          if (Params.Id != userid) ...[
            PopupMenuItem<int>(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                value: 1,
                onTap: () {
                  provider.reportUser(viewProfileModel!.data!.id.toString());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'images/reportUser.png',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text("Report User".tr),
                  ],
                )),
          ],
        ];
      },
    );
  }

  dialogListTile({image, txt, colorr, isFullWidth, isimageicon, ontap}) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: isFullWidth == null ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              color: isimageicon != null ? null : colorr ?? const Color(0xFF767680),
              height: 20,
              width: 20,
              image: AssetImage(
                image ?? "images/person.png",
              ),
            ),
            isFullWidth == null ? UIHelper.horizontalSpaceMd : UIHelper.horizontalSpaceSm,
            SizedBox(
              width: Get.width * 0.53,
              child: CustomText(
                text: txt ?? "Male".tr,
                fontSize: 16.0.sp,
                weight: fontWeightMedium,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  dialogTilewidget({image, txt, colorr, isFullWidth, isimageicon, ontap}) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: isFullWidth == null ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              color: isimageicon != null ? null : colorr ?? const Color(0xFF767680),
              height: 20,
              width: 20,
              image: AssetImage(
                image ?? "images/person.png",
              ),
            ),
            isFullWidth == null ? UIHelper.horizontalSpaceMd : UIHelper.horizontalSpaceSm,
            SizedBox(
              width: Get.width * 0.53,
              child: CustomText(
                text: txt ?? "Male".tr,
                fontSize: 16.0.sp,
                weight: fontWeightMedium,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  viewDetails(ProfileMany data) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              elevation: 0,
              shape: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          'Added By'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: Get.width * 0.2,
                            height: Get.height * 0.097,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: data.addedUser!.profile!.profileUrl == null ||
                                      data.addedUser!.profile!.profileUrl == "https://via.placeholder.com/150"
                                  ? Image.asset('images/aysha.png')
                                  : CachedNetworkImage(
                                      imageUrl: data.addedUser!.profile!.profileUrl!,
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
                              contentPadding: const EdgeInsets.only(left: 5),
                              title: Text(
                                data.addedUser!.username ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                data.addedUser!.number ?? '',
                                style: const TextStyle(color: Color(0xFFABAAB4), fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade500,
                  ),
                  SizedBox(height: Get.height * 0.01),
                  Center(
                    child: Text(
                      'Added Details'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: Get.width * 0.2,
                        height: Get.height * 0.097,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: data.profileUrl == null || data.profileUrl == "https://via.placeholder.com/150"
                              ? Image.asset('images/aysha.png')
                              : CachedNetworkImage(
                                  imageUrl: data.profileUrl!,
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
                          contentPadding: const EdgeInsets.only(left: 5),
                          title: Text(
                            data.nickname == null
                                ? viewProfileModel!.data!.username == null
                                    ? ""
                                    : viewProfileModel!.data!.username!
                                : data.nickname!,
                            style: const TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            viewProfileModel!.data!.number ?? '',
                            style: const TextStyle(color: Color(0xFFABAAB4), fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  dialogListTile(txt: data.gender != null ? toBeginningOfSentenceCase(data.gender) : "-"),
                  dialogListTile(
                      image: "images/cases.png",
                      txt:
                          "DOB: ${data.dob == null ? "-" : DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-dd").parse(data.dob.toString()))}"),
                  dialogListTile(
                      image: "images/locationnn.png",
                      txt: data.city != null && data.country != null && data.state != null
                          ? "${data.city != null ? "${toBeginningOfSentenceCase(data.city)}, " : ""}${data.state != null ? "${toBeginningOfSentenceCase(data.state)}, " : ""}${data.country != null ? toBeginningOfSentenceCase(data.country) : ""}"
                          : "Location not found"),
                  dialogListTile(image: "images/location.png", txt: data.address ?? "Address not found"),
                  SizedBox(height: Get.height * 0.02),
                  SizedBox(
                    width: Get.width,
                    child: Wrap(
                      spacing: 20.0,
                      children: [
                        dialogTilewidget(
                            ontap: () {
                              if (data.email != null) {
                                openEmail(data.email!);
                              }
                            },
                            image: "images/message.png",
                            txt: data.email != null ? data.email ?? '--' : "--",
                            isFullWidth: false,
                            isimageicon: true),
                        /* Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Image(
                              color: Color(0xFF767680),
                              height: 20,
                              width: 20,
                              image: AssetImage("images/message.png"),
                            ),
                            const SizedBox(width: 10),
                            viewProfileModel!.data!.getEmail != null &&
                                    viewProfileModel!.data!.getEmail!.isNotEmpty
                                ? EmailView(
                                    nickName: viewProfileModel!
                                            .data!.getEmail!.isNotEmpty
                                        ? viewProfileModel!.data!.getEmail!
                                        : [])
                                : CustomText(
                                    text: '--',
                                    fontSize: 16.0.sp,
                                    weight: fontWeightMedium,
                                    color: Colors.black,
                                  ),
                          ],
                        ), */
                        dialogTilewidget(
                            ontap: () {
                              if (data.facebookId != null) {
                                openFacebookProfile(data.facebookId!);
                              }
                            },
                            image: "images/facebook.png",
                            txt: data.facebookId != null ? data.facebookId ?? '--' : "--",
                            isimageicon: true,
                            isFullWidth: false),
                        dialogTilewidget(
                            ontap: () {
                              if (data.instagramId != null) {
                                openInstagramProfile(data.instagramId!);
                              }
                            },
                            image: "images/instagram.png",
                            txt: data.instagramId != null ? data.instagramId ?? '--' : "--",
                            isimageicon: true,
                            isFullWidth: false),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  addedByContainer(ProfileMany data) {
    return InkWell(
      onTap: () {
        viewDetails(data);
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
                width: Get.width * 0.2,
                height: Get.height * 0.097,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: data.addedUser!.profile!.profileUrl == null ||
                          data.addedUser!.profile!.profileUrl == "https://via.placeholder.com/150"
                      ? Image.asset('images/aysha.png')
                      : CachedNetworkImage(
                          imageUrl: data.addedUser!.profile!.profileUrl!,
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) => Image.asset('images/aysha.png'),
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(color: baseColor),
                          ),
                        ),
                ),
              ),
              MyCustomRatingView(
                starSize: 12.0,
                ratinigValue: double.parse(
                    data.addedUser!.averageRating != null ? data.addedUser!.averageRating.toString() : "0"),
              ),
              CustomText(
                text: data.addedUser!.profile!.profession ?? '-',
                fontSize: 12.0,
                weight: fontWeightMedium,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // width: Get.width * 0.25,
                    // color: Colors.red,
                    constraints: BoxConstraints(maxWidth: Get.width * 0.25),
                    child: AutoSizeText(
                      data.addedUser!.username ?? "",
                      maxLines: 1,
                      minFontSize: 10,
                      maxFontSize: 16.0,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: textStyleWorkSense(weight: fontWeightSemiBold, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (data.addedUser!.isSubscriptionActive != null && data.addedUser!.isSubscriptionActive == true) ...[
                    Image.asset(
                      data.addedUser!.activeSubscriptionPlanName.contains("lord")
                          ? APPICONS.lordicon
                          : data.addedUser!.activeSubscriptionPlanName.contains("god")
                              ? APPICONS.godstatuspng
                              : APPICONS.kingstutspicpng,
                      width: 16.0,
                    ),
                    const SizedBox(width: 5),
                  ],
                  const Icon(
                    Icons.verified,
                    color: Color(0xFF007EFF),
                    size: 14.0,
                  ),
                ],
              ),
              CallNumberView(
                userID: data.addedUser!.id.toString(),
                name: data.addedUser!.username,
                phoneNumber: data.addedUser!.number ?? '',
                color: Colors.grey,
                size: 12.0,
                callBack: () async {
                  ProfileRatingModel profile = await Utils.getUserRating(data.addedUser!.id.toString());
                  if (profile.data != null && profile.data!.isNotEmpty) {
                    if (profile.data!.first.isShowRating == 0) {
                      Get.dialog(ShowReviewDialog(
                        id: data.addedUser!.number!,
                        profile: profile,
                        userID: data.addedUser!.id.toString(),
                      ));
                    }
                  } else {
                    Get.dialog(AddReviewDialog(
                      id: data.addedUser!.number!,
                      userID: data.addedUser!.id.toString(),
                    )).then((value) async {
                      var temp = await provider.viewProfile(data.addedUser!.id);
                      setState(() {
                        data.addedUser!.averageRating = temp.data?.averageRating ?? 0.0;
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
}
