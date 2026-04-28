import 'dart:ui';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/config/const.dart';
import 'package:infosha/views/colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:video_player/video_player.dart';
import 'package:infosha/views/vote_button_small.dart';
import 'package:infosha/views/widgets/vote_button.dart';
import 'package:infosha/views/widgets/locked_widget.dart';
import 'package:infosha/Controller/Viewmodel/reaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infosha/views/widgets/feed_vote_button.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:infosha/screens/feed/component/edit_feed.dart';
import 'package:infosha/screens/feed/component/view_feed.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/feed/controller/feed_model.dart';
import 'package:infosha/screens/feed/model/feed_list_model.dart';
import 'package:flutter_feed_reaction/widgets/emoji_reaction.dart';
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';
import 'package:infosha/screens/otherprofile/reaction_bottomsheet.dart';
import 'package:infosha/Controller/name_gender_storing_controller.dart';
import 'package:infosha/screens/feed/component/comment_bottomsheet.dart';
import 'package:infosha/screens/feed/component/view_feed_bottomsheet.dart';
import 'package:infosha/screens/feed/component/feed_reaction_bottomsheet.dart';
import 'package:infosha/screens/subscription/component/subscription_screen.dart';
import 'package:infosha/screens/viewUnregistered/component/view_unregistered_user.dart';

class FeedTile extends StatefulWidget {
  int index;
  final bool isVisible;
  final VoidCallback onButtonTap;
  FeedTile({super.key, required this.index, required this.onButtonTap, required this.isVisible});

  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> with AutomaticKeepAliveClientMixin {
  VideoPlayerController? controller;
  // bool showComment = false;
  late FeedModel provider;
  late UserViewModel userProvider;
  int selectedReactionId = -1;
  final nameAndGenderStoringController = Get.find<NameAndGenderStoringController>();
  String loggedinUser = '';
  bool isSubscriptionActive = false;
  String activeSubscriptionPlanName = '';
  bool isReactionCooldown = false;

  /// Monotonic counter of reaction requests sent from this widget.
  /// Only the latest in-flight request may write the count back, so a slow
  /// older response cannot overwrite a newer optimistic value (avoids
  /// 1 → 0 → 1 flicker when the user taps quickly).
  int _reactionRequestSeq = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    provider = Provider.of<FeedModel>(context, listen: false);
    userProvider = Provider.of<UserViewModel>(context, listen: false);
    if (provider.feedListModel.data!.data![widget.index].fileUrl != null) {
      if (provider.feedListModel.data!.data![widget.index].fileUrl!.contains('.mp4') ||
          provider.feedListModel.data!.data![widget.index].fileUrl!.contains('.m4v') ||
          provider.feedListModel.data!.data![widget.index].fileUrl!.contains('.mov')) {
        initializaVideo();
      }
    }
    getUserData().then((data) {
      if (!mounted) return;
      setState(() {
        loggedinUser = data["name"];
        isSubscriptionActive = data["subscriptionStatus"];
        activeSubscriptionPlanName = data["subscriptionPlanName"];
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    /* if (provider.feedListModel.data!.data![widget.index].fileUrl != null) {
      if (provider.feedListModel.data!.data![widget.index].fileUrl!
              .contains('.mp4') ||
          provider.feedListModel.data!.data![widget.index].fileUrl!
              .contains('.m4v') ||
          provider.feedListModel.data!.data![widget.index].fileUrl!
              .contains('.mov')) {
        if (controller != null) {
          controller!.dispose();
        }
      }
    } */
  }

  Future<void> initializaVideo() async {
    controller = VideoPlayerController.networkUrl(Uri.parse(provider.feedListModel.data!.data![widget.index].fileUrl!))
      ..initialize().then((value) {
        // setState(() {});
      })
      ..setLooping(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedModel>(builder: (context, provider, child) {
      final items = provider.feedListModel.data?.data;
      // Safety check 1: list is null or empty
      if (items == null || items.isEmpty) {
        return const SizedBox(); // or shimmer
      }

      // Safety check 2: index is out of range
      if (widget.index >= items.length) {
        return const SizedBox(); // prevents RangeError
      }

      return Container(
        margin: const EdgeInsets.all(10.0),
        // height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (provider.feedListModel.data!.data![widget.index].feed_item_type == "activity")
              headingContainer(
                  provider.feedListModel.data!.data![widget.index].user!.profile!.profileUrl ?? "",
                  provider.feedListModel.data!.data![widget.index].user == null
                      ? ""
                      : provider.feedListModel.data!.data![widget.index].user!.username ?? "",
                  provider.feedListModel.data!.data![widget.index].user == null
                      ? ""
                      : provider.feedListModel.data!.data![widget.index].user!.number ?? "",
                  provider.feedListModel.data!.data![widget.index].user!.id.toString(),
                  provider.feedListModel.data!.data![widget.index].id.toString(),
                  provider.feedListModel.data!.data![widget.index].user!.activeSubscriptionPlanName != null
                      ? provider.feedListModel.data!.data![widget.index].user!.activeSubscriptionPlanName ?? ""
                      : "",
                  true,
                  (provider.feedListModel.data!.data![widget.index].user!.isLocked != null &&
                      provider.feedListModel.data!.data![widget.index].user!.isLocked == true)!,
                  provider.feedListModel.data!.data![widget.index].user!.isRegisteredUser),
            if (provider.feedListModel.data!.data![widget.index].feed_item_type == "post")
              headingContainerPost(
                  provider.feedListModel.data!.data![widget.index].user!.profile!.profileUrl ?? "",
                  provider.feedListModel.data!.data![widget.index].user == null
                      ? ""
                      : provider.feedListModel.data!.data![widget.index].user!.username ?? "",
                  provider.feedListModel.data!.data![widget.index].user == null
                      ? ""
                      : provider.feedListModel.data!.data![widget.index].user!.number ?? "",
                  provider.feedListModel.data!.data![widget.index].user!.id.toString(),
                  provider.feedListModel.data!.data![widget.index].id.toString(),
                  provider.feedListModel.data!.data![widget.index].user!.activeSubscriptionPlanName != null
                      ? provider.feedListModel.data!.data![widget.index].user!.activeSubscriptionPlanName ?? ""
                      : "",
                  true,
                  (provider.feedListModel.data!.data![widget.index].user!.isLocked != null &&
                      provider.feedListModel.data!.data![widget.index].user!.isLocked == true),
                  provider.feedListModel.data!.data![widget.index].user!.isRegisteredUser),
            if (provider.feedListModel.data!.data![widget.index].fileUrl != null &&
                (provider.feedListModel.data!.data![widget.index].fileUrl!.contains(".png") ||
                    provider.feedListModel.data!.data![widget.index].fileUrl!.contains(".jpg") ||
                    provider.feedListModel.data!.data![widget.index].fileUrl!.contains(".jpeg") ||
                    provider.feedListModel.data!.data![widget.index].fileUrl!.contains(".webp"))) ...[
              imagePostContainer()
            ],
            if (provider.feedListModel.data!.data![widget.index].fileUrl != null &&
                (provider.feedListModel.data!.data![widget.index].fileUrl!.contains('.mp4') ||
                    provider.feedListModel.data!.data![widget.index].fileUrl!.contains('.m4v') ||
                    provider.feedListModel.data!.data![widget.index].fileUrl!.contains('.mov'))) ...[
              videoPostContainer()
            ],
            if (provider.feedListModel.data!.data![widget.index].description != null &&
                provider.feedListModel.data!.data![widget.index].feed_item_type == "post") ...[textPostContainer()],
            if (provider.feedListModel.data!.data![widget.index].feed_item_type == "activity" &&
                (provider.feedListModel.data!.data![widget.index].activity_type == "nickname_updated" ||
                    provider.feedListModel.data!.data![widget.index].activity_type == "review_created")) ...[
              updateTextPostContainerForNickname(
                  provider.feedListModel.data!.data![widget.index].user == null
                      ? ""
                      : provider.feedListModel.data!.data![widget.index].user!.number ?? "",
                  provider.feedListModel.data!.data![widget.index].user!.id.toString(),
                  provider.feedListModel.data!.data![widget.index].user!.isRegisteredUser,
                  provider.feedListModel.data!.data![widget.index].userId.toString())
            ],
            if (provider.feedListModel.data!.data![widget.index].feed_item_type == "activity" &&
                provider.feedListModel.data!.data![widget.index].activity_type == "profile_photo_updated") ...[
              updateTextPostContainerForProfilePhoto(provider.feedListModel.data!.data![widget.index].userId.toString(),
                  provider.feedListModel.data!.data![widget.index].user!.number ?? "")
            ],
            if (provider.feedListModel.data!.data![widget.index].feed_item_type == "activity" &&
                provider.feedListModel.data!.data![widget.index].activity_type == "bio_update") ...[
              updateTextPostContainerForNickname(
                  provider.feedListModel.data!.data![widget.index].user == null
                      ? ""
                      : provider.feedListModel.data!.data![widget.index].user!.number ?? "",
                  provider.feedListModel.data!.data![widget.index].user!.id.toString(),
                  provider.feedListModel.data!.data![widget.index].user!.isRegisteredUser,
                  provider.feedListModel.data!.data![widget.index].userId.toString())
            ],
            if (provider.feedListModel.data!.data![widget.index].feed_item_type == "activity" &&
                provider.feedListModel.data!.data![widget.index].activity_type == "social_update") ...[
              updateTextPostContainerForNickname(
                  provider.feedListModel.data!.data![widget.index].user == null
                      ? ""
                      : provider.feedListModel.data!.data![widget.index].user!.number ?? "",
                  provider.feedListModel.data!.data![widget.index].user!.id.toString(),
                  provider.feedListModel.data!.data![widget.index].user!.isRegisteredUser,
                  provider.feedListModel.data!.data![widget.index].userId.toString())
            ],
            //akash basu nicknamed kunal singh as kunal Kumar singh.
            //Kunal k singh has updated his nickname.
            //akash basu has written a new review for kunal k singh
            //Kunal k singh has updated his address.
            //akash basu has updated the email address of kunal k singh.
            //akash basu has updated the address details of kunal k singh.

            voteContainer()
          ],
        ),
      );
    });
  }

  // bool isFollowerExist(int id) {
  //   return userProvider.userModel.followers!.any((f) => f.followerId == id);
  // }

  bool isFollowerExist(int id) {
    final followers = userProvider.userModel?.followers;

    if (followers == null) return false;

    return followers.any((f) => f.followerId == id);
  }

  headingContainer(String image, String name, String number, String id, String feedid, String plan, bool isActive,
      bool isLocked, bool? isRegieteredUser) {
    // bool isFollower = isFollowerExist(int.parse(id));
    bool isFollower = false;

    if (id != null && id.isNotEmpty) {
      isFollower = isFollowerExist(int.tryParse(id) ?? -1);
    }

    final bool shouldBlur = (isSubscriptionActive == false && activeSubscriptionPlanName == '' && name != loggedinUser);
    print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print(image);

    return GestureDetector(
      onTap: () {
        // Get.to(() => ViewProfileScreen(id: id));
        // if (shouldBlur && name != loggedinUser) {
        //   Get.to(() => SubscriptionScreen(isNewUser: false));
        // } else {
        //   Get.to(() => ViewProfileScreen(id: id));
        // }
        if (isRegieteredUser!) {
          Get.to(() => ViewProfileScreen(id: id));
        } else {
          Get.to(() => ViewUnregisteredUser(contactId: number, id: number, isOther: true));
        }
      },
      child: Stack(
        children: [
          ImageFiltered(
            imageFilter:
                // (shouldBlur && !isLocked) ? ImageFilter.blur(sigmaX: 5, sigmaY: 5) : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Opacity(
              // opacity: (shouldBlur && !isLocked) ? 0.8 : 1.0,

              opacity: 1.0,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(Get.height * 0.05),
                        child: image.isEmpty
                            ? Image.asset(APPICONS.profileicon)
                            : isBase64(image)
                                ? Image.memory(base64Decode(image), fit: BoxFit.cover)
                                : CachedNetworkImage(
                                    imageUrl: image,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => Image.asset(APPICONS.profileicon),
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(color: baseColor),
                                    ),
                                  ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 0),
                      title: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          CustomText(
                            text: name,
                            color: const Color(0xFF46464F),
                            weight: fontWeightSemiBold,
                            fontSize: 14,
                          ),
                          const SizedBox(width: 10),
                          if (plan.isNotEmpty)
                            Image(
                              height: 30,
                              image: AssetImage(
                                plan.contains("lord")
                                    ? APPICONS.lordicon
                                    : plan.contains("god")
                                        ? APPICONS.godstatuspng
                                        : APPICONS.kingstutspicpng,
                              ),
                            ),
                        ],
                      ),
                      subtitle: CustomText(
                        text: number,
                        color: const Color(0xFFABAAB4),
                        weight: fontWeightSemiBold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // if (shouldBlur && isLocked && name != loggedinUser) LockWidget(),
          // if (shouldBlur && !isLocked && name != loggedinUser)
          //   Positioned.fill(
          //     child: Center(
          //       child: Icon(
          //         Icons.lock,
          //         color: Colors.black.withOpacity(0.5),
          //         size: 40,
          //       ),
          //     ),
          //   ),

          if (isLocked && name != loggedinUser) LockWidget(),
        ],
      ),
    );
  }

  headingContainerPost(String image, String name, String number, String id, String feedid, String plan, bool isActive,
      bool isLocked, bool? isRegieteredUser) {
    print("===============================================================");
    print(image);
    return GestureDetector(
      onTap: () {
        // if (shouldBlur) {
        //   Get.to(() => SubscriptionScreen(
        //         isNewUser: false,
        //       ));
        // } else {
        //   Get.to(() => ViewProfileScreen(id: id));
        // }
        if (isRegieteredUser!) {
          Get.to(() => ViewProfileScreen(id: id));
        } else {
          Get.to(() => ViewUnregisteredUser(contactId: number, id: number, isOther: true));
        }

        /* Get.to(() => ViewFeed(
            postUrl: provider.feedListModel.data!.data![widget.index].id
                .toString())); */
      },
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(Get.height * 0.05),
                    child: image.isEmpty
                        ? Image.asset(APPICONS.profileicon)
                        : isBase64(image)
                            ? Image.memory(base64Decode(image), fit: BoxFit.cover)
                            : CachedNetworkImage(
                                imageUrl: image,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Image.asset(APPICONS.profileicon),
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(color: baseColor),
                                ),
                              ),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 0),
                  title: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomText(
                        text: name,
                        color: const Color(0xFF46464F),
                        weight: fontWeightSemiBold,
                        fontSize: 14,
                      ),
                      SizedBox(width: 10),
                      if (plan.isNotEmpty) ...[
                        // const SizedBox(width: 5),
                        Image(
                          height: 30,
                          image: AssetImage(plan.contains("lord")
                              ? APPICONS.lordicon
                              : plan.contains("god")
                                  ? APPICONS.godstatuspng
                                  : APPICONS.kingstutspicpng),
                        ),
                      ],
                      /* const Icon(
                            Icons.verified,
                            color: Color(0xFF007EFF),
                            size: 18,
                          ), */
                    ],
                  ),
                  subtitle: CustomText(
                    text: number,
                    color: const Color(0xFFABAAB4),
                    weight: fontWeightSemiBold,
                    fontSize: 14,
                  ),
                  trailing: PopupMenuButton(
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
                        if (Params.Id == id) ...[
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
                                                  'Are you sure you want to delete?'.tr,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                                ),
                                              ),
                                            ],
                                          ),

                                          content: Text(
                                            'In order to delete this comment, you have to purchase status subscriptions'
                                                .tr,
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
                                                provider.deleteFeed(feedid);
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 10),
                                  const Image(
                                    image: AssetImage("images/delete.png"),
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text("Delete Post".tr),
                                ],
                              )),
                          PopupMenuItem<int>(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              value: 3,
                              onTap: () {
                                Get.to(() => EditFeed(feedListData: provider.feedListModel.data!.data![widget.index]));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 10),
                                  const Image(
                                    image: AssetImage("images/edit.png"),
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text("Edit Post".tr),
                                ],
                              ))
                        ],
                        if (Params.Id != id.toString()) ...[
                          PopupMenuItem<int>(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              value: 1,
                              onTap: () {
                                provider.feedReport(id);
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
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text("Report User".tr),
                                ],
                              )),
                          PopupMenuItem<int>(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              value: 2,
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
                                            'In order to delete this comment, you have to purchase status subscriptions'
                                                .tr,
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
                                                provider.blockUser(id);
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
                                  Text("Block User".tr),
                                ],
                              ))
                        ],
                      ];
                    },
                  ),
                ),
              ),
            ],
          ),
          if (isLocked && name != loggedinUser) ...[LockWidget()]
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

  headingCommentContainer(String image, String name, String number, String id, String feedid) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ViewProfileScreen(id: id));
      },
      child: Row(
        children: [
          SizedBox(
            width: Get.width * 0.21,
            height: Get.height * 0.1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: image.isEmpty
                  ? Image.asset(APPICONS.profileicon)
                  : isBase64(image)
                      ? Image.memory(base64Decode(image), fit: BoxFit.cover)
                      : CachedNetworkImage(
                          imageUrl: image,
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) => Image.asset(APPICONS.profileicon),
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(color: baseColor),
                          ),
                        ),
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 10),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    text: name,
                    color: const Color(0xFF46464F),
                    weight: fontWeightSemiBold,
                    fontSize: 14,
                  ),
                  /* UIHelper.horizontalSpaceSm,
                  Image(
                    height: 20,
                    image: AssetImage(
                      APPICONS.lordicon,
                    ),
                  ), */
                ],
              ),
              subtitle: CustomText(
                text: number,
                color: const Color(0xFFABAAB4),
                weight: fontWeightSemiBold,
                fontSize: 14,
              ),
              trailing: Params.Id == id.toString()
                  ? const SizedBox.shrink()
                  : PopupMenuButton(
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
                          if (Params.Id == id) ...[
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
                                                    'Are you sure you want to delete?'.tr,
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            content: Text(
                                              'In order to delete this comment, you have to purchase status subscriptions'
                                                  .tr,
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
                                                  provider.deleteFeed(feedid);
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 10),
                                    const Image(
                                      image: AssetImage("images/delete.png"),
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text("Delete Post".tr),
                                  ],
                                )),
                            PopupMenuItem<int>(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                value: 3,
                                onTap: () {
                                  Get.to(
                                      () => EditFeed(feedListData: provider.feedListModel.data!.data![widget.index]));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 10),
                                    const Image(
                                      image: AssetImage("images/edit.png"),
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text("Edit Post".tr),
                                  ],
                                ))
                          ],
                          if (Params.Id != id) ...[
                            PopupMenuItem<int>(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                value: 1,
                                onTap: () {
                                  provider.feedReport(id);
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
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text("Report User".tr),
                                  ],
                                )),
                            PopupMenuItem<int>(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                value: 2,
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
                                              'In order to delete this comment, you have to purchase status subscriptions'
                                                  .tr,
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
                                                  provider.blockUser(id);
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
                                    Text("Block User".tr),
                                  ],
                                ))
                          ],
                        ];
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  imagePostContainer() {
    return GestureDetector(
      onTap: () {
        Get.to(() => ViewFeed(postUrl: provider.feedListModel.data!.data![widget.index].id.toString()));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
        height: Get.height * 0.44,
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: provider.feedListModel.data!.data![widget.index].fileUrl == null
              ? Image.asset(APPICONS.profileicon)
              : CachedNetworkImage(
                  imageUrl: provider.feedListModel.data!.data![widget.index].fileUrl ?? "",
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: baseColor)),
                  errorWidget: (context, url, error) {
                    return Image.asset(APPICONS.profileicon);
                  },
                ),
        ),
      ),
    );
  }

  videoPostContainer() {
    return VisibilityDetector(
      key: Key(widget.index.toString()),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction < 0.9) {
          if (mounted) {
            controller!.pause();
            setState(() {});
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
        height: Get.height * 0.44,
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: controller!.value.isInitialized == false
              ? const CircularProgressIndicator(color: baseColor)
              : InkWell(
                  onTap: () {
                    setState(() {
                      if (controller!.value.isPlaying) {
                        controller!.pause();
                      } else {
                        controller!.play();
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SizedBox.expand(
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: SizedBox(
                                  width: constraints.maxWidth * controller!.value.aspectRatio,
                                  height: controller!.value.aspectRatio,
                                  child: VideoPlayer(
                                    controller!,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (controller!.value.isPlaying == false) ...[
                        const Align(
                            child: Icon(
                          Icons.play_circle_outline_rounded,
                          color: Colors.white,
                          size: 50,
                        ))
                      ]
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  int safeCount(int value) => value < 0 ? 0 : value;

  int nextReactionCount(String? previousReactionName, String nextReactionName, int previousCount) {
    if (previousReactionName == null) {
      return previousCount + 1;
    }
    if (previousReactionName == nextReactionName) {
      return safeCount(previousCount - 1);
    }
    return previousCount;
  }

  voteContainer() {
    var model = provider.feedListModel.data!.data![widget.index];
    final String comment =
        provider.feedListModel.data!.data![widget.index].totalRepliesComment == 1 ? "comment" : "comments";
    selectedReactionId = getReactionId(model.reactionName ?? "");

    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    FeedReactionBottomSheet()
                        .showReactions(context, provider.feedListModel.data!.data![widget.index].id.toString());
                  },
                  child: Row(
                    children: [
                      Image(
                        width: 40,
                        image: AssetImage(provider.convertReactionIdToPathNew(-1)),
                      ),
                      const SizedBox(width: 5),
                      Text(provider.feedListModel.data!.data![widget.index].totalReactionCount.toString(),
                          style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    CommentBottomSheet().showComments(context, widget.index);
                  },
                  child: Text(
                      "${provider.feedListModel.data!.data![widget.index].totalRepliesComment.toString()} $comment",
                      style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlutterFeedReaction(
                reactions: EmojiReactions.reactions,
                spacing: 0.0,
                dragStart: 20,
                dragSpace: 40.0,
                containerWidth: Get.width * .9,
                prefix: Consumer<FeedModel>(builder: (context, provider, child) {
                  return Container(
                    height: 50,
                    constraints: BoxConstraints(minWidth: Get.width * 0.3, maxHeight: Get.width * 0.35),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        selectedReactionId == -1
                            ? const SizedBox(width: 30, child: Text('👍', style: TextStyle(fontSize: 22)))
                            : getReactionEmoji(selectedReactionId),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(5),
                          child: Text(getReactionName(selectedReactionId),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: selectedReactionId == -1 ? Colors.black : primaryColor,
                                  fontWeight: selectedReactionId == -1 ? FontWeight.normal : FontWeight.w600)),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     FeedReactionBottomSheet().showReactions(context, provider.feedListModel.data!.data![widget.index].id.toString());
                        //   },
                        //   child: Container(
                        //     color: Colors.white,
                        //     padding: const EdgeInsets.all(5),
                        //     child: Text(getReactionName(selectedReactionId),
                        //         style: TextStyle(
                        //             fontSize: 14,
                        //             color: selectedReactionId == -1 ? Colors.black : primaryColor,
                        //             fontWeight: selectedReactionId == -1 ? FontWeight.normal : FontWeight.w600)),
                        //   ),
                        // )
                      ],
                    ),
                  );
                }),
                // onReactionSelected: (val) {
                //   String name = getReactionName(val.id);
                //   setState(() {
                //     selectedReactionId = val.id;
                //     provider.feedListModel.data!.data![widget.index].reactionName = name;
                //   });

                //   provider.addFeedReaction(provider.feedListModel.data!.data![widget.index].id.toString(), name).then((value) {
                //     setState(() {
                //       if (int.parse(provider.feedListModel.data!.data![widget.index].totalReactionCount.toString()) > value) {
                //         selectedReactionId = -1;
                //         provider.feedListModel.data!.data![widget.index].reactionName = null;
                //       }
                //       provider.feedListModel.data!.data![widget.index].totalReactionCount = value;
                //     });
                //   });
                // },

                onReactionSelected: (val) {
                  String name = getReactionName(val.id);

                  final model = provider.feedListModel.data!.data![widget.index];
                  final previousReactionName = model.reactionName;
                  final previousReactionCount = model.totalReactionCount ?? 0;
                  final isRemovingReaction = previousReactionName == name;

                  // Save previous states (for rollback)
                  final prevReactionId = selectedReactionId;
                  final prevReactionName = previousReactionName;
                  final prevReactionCount = model.totalReactionCount;
                  final requestId = ++_reactionRequestSeq;

                  // ---- OPTIMISTIC UI UPDATE ----
                  setState(() {
                    selectedReactionId = isRemovingReaction ? -1 : val.id;
                    model.reactionName = isRemovingReaction ? null : name;
                    model.totalReactionCount = nextReactionCount(previousReactionName, name, previousReactionCount);
                  });

                  // ---- CALL API ----
                  provider.addFeedReaction(model.id.toString(), name).then((countFromApi) {
                    if (countFromApi == null) {
                      throw Exception("Failed to update reaction count");
                    }
                    if (requestId != _reactionRequestSeq) return; // a newer tap is in flight
                    if (model.totalReactionCount == countFromApi) return; // already in sync
                    setState(() {
                      model.totalReactionCount = countFromApi;
                    });
                  }).catchError((_) {
                    // ---- API FAILED → ROLLBACK ----
                    if (requestId != _reactionRequestSeq) return;
                    setState(() {
                      selectedReactionId = prevReactionId;
                      model.reactionName = prevReactionName;
                      model.totalReactionCount = prevReactionCount;
                    });
                  });
                },

                // onPressed: () {
                //   if (model.reactionName != null) {
                //     provider.addFeedReaction(provider.feedListModel.data!.data![widget.index].id.toString(), model.reactionName!).then((value) {
                //       setState(() {
                //         selectedReactionId = -1;
                //         provider.feedListModel.data!.data![widget.index].reactionName = null;

                //         provider.feedListModel.data!.data![widget.index].totalReactionCount = value;
                //       });
                //     });
                //   } else {
                //     provider.addFeedReaction(provider.feedListModel.data!.data![widget.index].id.toString(), "like").then((value) {
                //       setState(() {
                //         selectedReactionId = 0;
                //         provider.feedListModel.data!.data![widget.index].reactionName = "like";

                //         provider.feedListModel.data!.data![widget.index].totalReactionCount = value;
                //       });
                //     });
                //   }
                // },

                onPressed: () {
                  final model = provider.feedListModel.data!.data![widget.index];

                  final prevReactionId = selectedReactionId;
                  final prevReactionName = model.reactionName;
                  final prevReactionCount = model.totalReactionCount;
                  final requestId = ++_reactionRequestSeq;

                  // User removes reaction
                  if (model.reactionName != null) {
                    // OPTIMISTIC UPDATE
                    setState(() {
                      selectedReactionId = -1;
                      model.reactionName = null;
                      model.totalReactionCount = safeCount((prevReactionCount ?? 0) - 1);
                    });

                    provider.addFeedReaction(model.id.toString(), prevReactionName!).then((countApi) {
                      if (countApi == null) {
                        throw Exception("Failed to remove reaction count");
                      }
                      if (requestId != _reactionRequestSeq) return;
                      if (model.totalReactionCount == countApi) return;
                      setState(() {
                        model.totalReactionCount = countApi;
                      });
                    }).catchError((_) {
                      // ROLLBACK
                      if (requestId != _reactionRequestSeq) return;
                      setState(() {
                        selectedReactionId = prevReactionId;
                        model.reactionName = prevReactionName;
                        model.totalReactionCount = prevReactionCount;
                      });
                    });
                  } else {
                    // First time like
                    const newReaction = "like";

                    // OPTIMISTIC UPDATE
                    setState(() {
                      selectedReactionId = 0;
                      model.reactionName = newReaction;
                      model.totalReactionCount = (prevReactionCount ?? 0) + 1;
                    });

                    provider.addFeedReaction(model.id.toString(), newReaction).then((countApi) {
                      if (countApi == null) {
                        throw Exception("Failed to add reaction count");
                      }
                      if (requestId != _reactionRequestSeq) return;
                      if (model.totalReactionCount == countApi) return;
                      setState(() {
                        model.totalReactionCount = countApi;
                      });
                    }).catchError((_) {
                      // ROLLBACK
                      if (requestId != _reactionRequestSeq) return;
                      setState(() {
                        selectedReactionId = prevReactionId;
                        model.reactionName = prevReactionName;
                        model.totalReactionCount = prevReactionCount;
                      });
                    });
                  }
                },
              ),
              Container(
                width: 1,
                height: 24,
                color: Colors.black38,
              ),
              SizedBox(
                width: Get.width * 0.3,
                child: InkWell(
                  onTap: () {
                    CommentBottomSheet().showComments(context, widget.index);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.isVisible
                          ? const Image(
                              height: 17,
                              // width: 30,
                              image: AssetImage('images/fillComment.png'))
                          : const Image(
                              height: 17,
                              // width: 30,
                              image: AssetImage('images/comments.png')),
                      const SizedBox(width: 10),
                      Text("Comments",
                          style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 24,
                color: Colors.black38,
              ),
              SizedBox(
                width: Get.width * 0.25,
                child: InkWell(
                  onTap: () async {
                    Share.share('https://infosha.org/feed/${provider.feedListModel.data!.data![widget.index].id}');
                  },
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                            height: 17,
                            // width: 30,
                            image: AssetImage(APPICONS.shareIcon)),
                        const SizedBox(width: 10),
                        Text("Share".tr,
                            style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // commentContainer()
        ],
      );
    });
  }

  textPostContainer() {
    return GestureDetector(
      onTap: () {
        Get.to(() => ViewFeed(postUrl: provider.feedListModel.data!.data![widget.index].id.toString()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              height: 5,
              thickness: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              provider.feedListModel.data!.data![widget.index].description ?? "",
              style: GoogleFonts.workSans(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              height: 5,
              thickness: 2,
            ),
          )
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> getUserData() async {
    var prefs = await SharedPreferences.getInstance();

    return {
      "name": prefs.getString("Name") ?? "",
      "subscriptionStatus": prefs.getBool("Subscription_Status") ?? false,
      "subscriptionPlanName": prefs.getString("Subscription_Plan_Name") ?? "",
    };
  }

  updateTextPostContainerForNickname(String number, String id, bool? isRegieteredUser, String userId) {
    final description = provider.feedListModel.data!.data![widget.index].description ?? "";
    // print(description);
    String blurredText = "";
    String restText = '';
    final words = description.split(' ');
    String oldName = "";
    String newName = "";

    if (words.isNotEmpty) {
      if (words.contains("has") || words.contains("nicknamed")) {
        int ind = words.contains("has") ? description.indexOf("has") : description.indexOf("nicknamed");
        blurredText = description.substring(0, ind);

        restText = description.substring(ind);
        print("REst Text==> ${restText}");
        if (restText.contains("nicknamed")) {
          oldName = restText
              .split(' ')
              .sublist(restText.split(' ').indexOf("nicknamed") + 1, restText.split(' ').indexOf("as"))
              .join(' ');
          newName =
              restText.split(' ').sublist(restText.split(' ').indexOf("as") + 1, restText.split(' ').length).join(' ');
          // print(oldName);
          // print(newName);
        }
      }

      return GestureDetector(
        onTap: () {
          Get.to(() => ViewFeed(postUrl: provider.feedListModel.data!.data![widget.index].id.toString()));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(height: 5, thickness: 2),
            ),

            /// 🔒 When user is NOT subscribed
            if (isSubscriptionActive == false && activeSubscriptionPlanName == '')
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.workSans(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      // Blurred name logic
                      //blurredText.length - 1 != loggedinUser.length replaced by blurredText.substring(0, blurredText.length - 1).toLowerCase() != loggedinUser.toLowerCase() on 23/12/2025
                      if (!words.contains("Anonymous") &&
                          !words.contains("his") &&
                          !words.contains("her") &&
                          blurredText.substring(0, blurredText.length - 1).toLowerCase() != loggedinUser.toLowerCase())
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: ClipRect(
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 6),
                              child: Text(
                                blurredText,
                                style: GoogleFonts.workSans(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Visible name for anonymous
                      if (words.contains("Anonymous") ||
                          words.contains("his") ||
                          words.contains("her") ||
                          blurredText.substring(0, blurredText.length - 1).toLowerCase() == loggedinUser.toLowerCase())
                        TextSpan(
                          text: blurredText,
                          style: GoogleFonts.workSans(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      // Rest of the text
                      if (!restText.contains("nicknamed") &&
                          (!words.contains("Anonymous") ||
                              !words.contains("his") ||
                              !words.contains("her") ||
                              blurredText.substring(0, blurredText.length - 1).toLowerCase() ==
                                  loggedinUser.toLowerCase()))
                        TextSpan(text: restText),

                      if (restText.contains("nicknamed") &&
                          (!words.contains("Anonymous") ||
                              !words.contains("his") ||
                              !words.contains("her") ||
                              blurredText.substring(0, blurredText.length - 1).toLowerCase() ==
                                  loggedinUser.toLowerCase()))
                        // TextSpan(text: restText),
                        ...buildClickableDescription(
                          restText,
                          oldName,
                          newName,
                          number,
                          id,
                          isRegieteredUser,
                        ),

                      // 🔒 Inline subscribe link
                      if (!words.contains("Anonymous") &&
                          !words.contains("his") &&
                          !words.contains("her") &&
                          blurredText.substring(0, blurredText.length - 1).toLowerCase() != loggedinUser.toLowerCase())
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => SubscriptionScreen(
                                    isNewUser: false,
                                  ));
                            },
                            child: Text(
                              " [ 🔒 Subscribe to view details ]",
                              style: GoogleFonts.workSans(
                                color: Colors.blueAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            // ✅ When user IS subscribed
            if (isSubscriptionActive != false && activeSubscriptionPlanName != '' && !description.contains("nicknamed"))
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  description,
                  style: GoogleFonts.workSans(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            if (isSubscriptionActive != false && activeSubscriptionPlanName != '' && description.contains("nicknamed"))
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.workSans(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    children: buildClickableDescription(description, oldName, newName, number, id, isRegieteredUser,
                        userId: userId),
                  ),
                ),
              ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(height: 5, thickness: 2),
            ),
          ],
        ),
      );
    }
  }

  updateTextPostContainerForProfilePhoto(String userId, String number) {
    final description = provider.feedListModel.data!.data![widget.index].description ?? "";
    // print(description);

    String blurredText = "";
    String restText = '';
    final parts = description.split(" ");
    if (parts.contains("has") && parts.contains("from")) {
      int ind = description.indexOf("from");
      restText = description.substring(0, ind + "from".length + 1);

      blurredText = description.substring(ind + "from".length + 1);
    } else if (parts.contains("has") && !parts.contains("from")) {
      int ind = description.indexOf("has");
      blurredText = description.substring(0, ind);

      restText = description.substring(ind);
      print("REst Text==> ${restText}");
    }

    return GestureDetector(
      onTap: () {
        Get.to(() => ViewFeed(
              postUrl: provider.feedListModel.data!.data![widget.index].id.toString(),
            ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(height: 5, thickness: 2),
          ),

          // 🔒 If user has no active subscription
          if (isSubscriptionActive == false && activeSubscriptionPlanName == '')
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.workSans(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    if (!parts.contains("his") && !parts.contains("her")) TextSpan(text: restText),
                    //blurredText.length - 1 != loggedinUser.length replaced by blurredText.substring(0, blurredText.length - 1).toLowerCase() != loggedinUser.toLowerCase() on 23/12/2025
                    if (!parts.contains("his") &&
                        !parts.contains("her") &&
                        blurredText.substring(0, blurredText.length - 1).toLowerCase() != loggedinUser.toLowerCase())
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: ClipRect(
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 6),
                            child: Text(
                              blurredText,
                              style: GoogleFonts.workSans(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (!parts.contains("his") &&
                        !parts.contains("her") &&
                        blurredText.substring(0, blurredText.length - 1).toLowerCase() == loggedinUser.toLowerCase())
                      TextSpan(text: blurredText),
                    if (parts.contains("his") || parts.contains("her")) TextSpan(text: blurredText + restText),
                    if (!parts.contains("his") &&
                        !parts.contains("her") &&
                        blurredText.substring(0, blurredText.length - 1).toLowerCase() != loggedinUser.toLowerCase())
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => SubscriptionScreen(isNewUser: false));
                          },
                          child: Text(
                            " [ 🔒 Subscribe to view details ]",
                            style: GoogleFonts.workSans(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

          // ✅ If user has an active subscription
          if (isSubscriptionActive != false && activeSubscriptionPlanName != '' && description.contains("from"))
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(children: [
                Expanded(
                    child: Wrap(children: [
                  if (description.split("from")[0].isNotEmpty)
                    Text(
                      description.split("from")[0] + "from",
                      style: GoogleFonts.workSans(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (description.split("from")[0].isEmpty)
                    Text(
                      number + "from",
                      style: GoogleFonts.workSans(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ViewProfileScreen(id: userId!));
                    },
                    child: Text(
                      description.split("from")[1],
                      style: GoogleFonts.workSans(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ]))
              ]),
            ),

          if (isSubscriptionActive != false && activeSubscriptionPlanName != '' && !description.contains("from"))
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                description,
                style: GoogleFonts.workSans(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(height: 5, thickness: 2),
          ),
        ],
      ),
    );
  }

  List<InlineSpan> buildClickableDescription(
      String text, String oldName, String newName, String number, String id, bool? isRegieteredUser,
      {String? userId}) {
    List<InlineSpan> spans = [];

    // Split entire text into three sections:
    // [before oldName] [oldName] [middle text including 'as'] [newName] [after newName]

    if (oldName.isNotEmpty && newName.length > 1) {
      final beforeOld = text.split("nicknamed")[0];
      final name = beforeOld.split("has")[0];

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            onTap: () {
              Get.to(() => ViewProfileScreen(id: userId!));
            },
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );

      // 1) Text before old name
      spans.add(TextSpan(text: "has nicknamed "));

      // 2) Old name clickable
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            onTap: () {
              if (isRegieteredUser!) {
                Get.to(() => ViewProfileScreen(id: id));
              } else {
                Get.to(() => ViewUnregisteredUser(contactId: number, id: number, isOther: true));
              }
            },
            child: Text(
              oldName,
              style: const TextStyle(
                color: Color.fromARGB(255, 243, 130, 122),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );

      spans.add(TextSpan(text: " as "));

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            onTap: () {
              if (isRegieteredUser!) {
                Get.to(() => ViewProfileScreen(id: id));
              } else {
                Get.to(() => ViewUnregisteredUser(contactId: number, id: number, isOther: true));
              }
            },
            child: Text(
              newName,
              style: const TextStyle(
                color: Color.fromARGB(255, 46, 208, 52),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );

      return spans;
    } else {
      print(text);
      text = text.replaceAll("nicknamed", "saved");
      text = text.replaceAll("has", "");
      text = text.replaceAll("as", "");
      text = text;
      print(text);
      final name = text.split("saved")[0].trim();

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            onTap: () {
              Get.to(() => ViewProfileScreen(id: userId!));
            },
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );

      if (oldName.isEmpty && newName.length > 1) {
        //userX has saved 9398377155 as userB
        spans.add(TextSpan(text: " has saved the "));

        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () {
                if (isRegieteredUser!) {
                  Get.to(() => ViewProfileScreen(id: id));
                } else {
                  Get.to(() => ViewUnregisteredUser(contactId: number, id: number, isOther: true));
                }
              },
              child: Text(
                number,
                style: const TextStyle(
                  color: Color.fromARGB(255, 243, 130, 122),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );

        spans.add(TextSpan(text: " as "));

        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () {
                if (isRegieteredUser!) {
                  Get.to(() => ViewProfileScreen(id: id));
                } else {
                  Get.to(() => ViewUnregisteredUser(contactId: number, id: number, isOther: true));
                }
              },
              child: Text(
                newName,
                style: const TextStyle(
                  color: Color.fromARGB(255, 46, 208, 52),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );

        return spans;
      } else if (oldName.isNotEmpty && (newName.length == 1 && newName.contains("."))) {
        //userX has saved userA without a nickname.
        spans.add(TextSpan(text: " has saved "));
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () {
                if (isRegieteredUser!) {
                  Get.to(() => ViewProfileScreen(id: id));
                } else {
                  Get.to(() => ViewUnregisteredUser(contactId: number, id: number, isOther: true));
                }
              },
              child: Text(
                oldName,
                style: const TextStyle(
                  color: Color.fromARGB(255, 243, 130, 122),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
        spans.add(TextSpan(text: " without a nickname."));

        return spans;
      } else if (oldName.isEmpty && (newName.length == 1 && newName.contains("."))) {
        //userX has saved 9398377155 without a nickname.
        spans.add(TextSpan(text: " has saved the "));
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () {
                if (isRegieteredUser!) {
                  Get.to(() => ViewProfileScreen(id: id));
                } else {
                  Get.to(() => ViewUnregisteredUser(contactId: number, id: number, isOther: true));
                }
              },
              child: Text(
                number,
                style: const TextStyle(
                  color: Color.fromARGB(255, 243, 130, 122),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
        spans.add(TextSpan(text: " without a nickname."));

        return spans;
      }

      return spans;
    }
  }

  /* commentContainer() {
    if (!widget.isVisible) {
      return Container();
    }
    // return Visibility(
    //   visible: widget.isVisible,
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            height: 5,
            thickness: 2,
          ),
        ),
        Container(
          width: Get.width,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  // height: Get.height * 0.055,
                  alignment: Alignment.center,
                  child: Form(
                    key: provider
                        .feedListModel.data!.data![widget.index].formKey,
                    child: TextFormField(
                      focusNode: provider
                          .feedListModel.data!.data![widget.index].focusNode,
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: Key(widget.index.toString()),
                      controller: provider.feedListModel.data!
                          .data![widget.index].replyController!,
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
                              borderSide: BorderSide(
                                  color: Color(0xFf767680), width: 2)),
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(3.0),
                              ),
                              borderSide: BorderSide(
                                  color: Color(0xFf767680), width: 2)),
                          hintText: "Write Reply...".tr,
                          hintStyle: textStyleWorkSense(
                              fontSize: 14.0,
                              color: const Color(0xFF46464F),
                              weight: fontWeightRegular)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: Get.width * 0.02),
              GestureDetector(
                onTap: () {
                  if (provider.feedListModel.data!.data![widget.index].formKey!
                      .currentState!
                      .validate()) {
                    provider
                        .addFeedReply(
                            provider.feedListModel.data!.data![widget.index].id
                                .toString(),
                            provider.feedListModel.data!.data![widget.index]
                                .replyController!.text
                                .trim())
                        .then((value) {
                      provider.fetchPostsData(widget.index).then((value) {
                        setState(() {
                          provider.feedListModel.data!.data![widget.index] =
                              value;
                        });
                      });
                      provider.feedListModel.data!.data![widget.index]
                          .replyController!
                          .clear();

                      provider
                          .feedListModel.data!.data![widget.index].focusNode!
                          .unfocus();
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
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: provider.feedListModel.data!.data![widget.index]
                      .repliesComment!.isEmpty
                  ? 10
                  : 0),
          child: Text(
            "Comments",
            style: GoogleFonts.workSans(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (provider.feedListModel.data!.data![widget.index].repliesComment !=
            null) ...[
          ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: provider
                .feedListModel.data!.data![widget.index].repliesComment!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var data = provider.feedListModel.data!.data![widget.index]
                  .repliesComment![index];
              return replyCommentContainer(index, data);
            },
          ),
          const Padding(
            padding: EdgeInsets.all(5.0),
            child: Divider(
              height: 10,
              thickness: 2,
              color: Colors.transparent,
            ),
          ),
        ]
      ],
    );
  }
 */
  replyCommentContainer(int index, RepliesComment data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: headingCommentContainer(
                data.profile ?? "", data.username ?? "", data.number ?? "", data.addedBy.toString(), "")),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 10, bottom: 15, top: 5),
          child: Text(
            data.comment ?? "",
            style: GoogleFonts.workSans(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

int getReactionId(String reactionName) {
  const reactionMap = {
    "like": 0,
    "dislike": 1,
    "love": 2,
    "haha": 3,
    "wow": 4,
    "angry": 5,
    "cry": 6,
    "facepalm": 7,
  };
  return reactionMap[reactionName] ?? -1;
}

String getReactionName(int id) {
  const reactionMap = {
    0: "like",
    1: "dislike",
    2: "love",
    3: "haha",
    4: "wow",
    5: "angry",
    6: "cry",
    7: "facepalm",
  };

  return reactionMap[id] ?? "like";
}

String getEmoji(String name) {
  const reactionMap = {
    "like": '👍',
    "dislike": '👎',
    "love": '❤️',
    "haha": '😂',
    "wow": '😮',
    "angry": '😡',
    "cry": '😢',
    "facepalm": '🤦‍♂️',
  };

  return reactionMap[name] ?? "👍";
}

Widget getReactionEmoji(int id) {
  return Consumer<FeedModel>(builder: (context, provider, child) {
    return id == 0
        ? const SizedBox(width: 30, child: Text('👍', style: TextStyle(fontSize: 22)))
        : id == 1
            ? const SizedBox(width: 30, child: Text('👎', style: TextStyle(fontSize: 22)))
            : id == 3
                ? const SizedBox(width: 30, child: Text('😂', style: TextStyle(fontSize: 22)))
                : id == 7
                    ? const SizedBox(width: 30, child: Text('🤦‍♂️', style: TextStyle(fontSize: 22)))
                    : Image(
                        width: id == -1 ? 40 : 30.0,
                        image: AssetImage(provider.convertReactionIdToPathNew(id)),
                      );
  });
}

class DynamicEmojiRow extends StatelessWidget {
  final List<String> emojis;

  DynamicEmojiRow({required this.emojis});

  @override
  Widget build(BuildContext context) {
    double emojiWidth = 30;
    double overlap = 15;
    double totalWidth = (emojis.length * emojiWidth) - overlap * (emojis.length - 1);

    return Container(
      height: 30,
      constraints: BoxConstraints(
        maxWidth: totalWidth,
        minWidth: 1,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: _buildEmojiWidgets(emojis, emojiWidth, overlap),
      ),
    );
  }

  List<Widget> _buildEmojiWidgets(List<String> emojis, double emojiWidth, double overlap) {
    List<Widget> emojiWidgets = [];

    for (int i = 0; i < emojis.length; i++) {
      emojiWidgets.add(
        Positioned(
          left: i * (emojiWidth - overlap), // Position each emoji with overlap
          child: Text(
            emojis[i],
            style: TextStyle(fontSize: 22), // Adjust font size as needed
          ),
        ),
      );
    }
    return emojiWidgets;
  }
}
