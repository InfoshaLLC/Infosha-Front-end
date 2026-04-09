import 'dart:ui';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:infosha/main.dart';
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
import 'package:infosha/views/widgets/vote_button.dart';
import 'package:infosha/views/widgets/locked_widget.dart';
import 'package:infosha/Controller/Viewmodel/reaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infosha/views/widgets/feed_vote_button.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:infosha/screens/feed/component/edit_feed.dart';
import 'package:infosha/screens/feed/component/feed_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/feed/controller/feed_model.dart';
import 'package:infosha/screens/feed/model/feed_list_model.dart';
import 'package:flutter_feed_reaction/widgets/emoji_reaction.dart';
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';
import 'package:infosha/Controller/name_gender_storing_controller.dart';
import 'package:infosha/screens/otherprofile/reaction_bottomsheet.dart';
import 'package:infosha/screens/feed/component/comment_bottomsheet.dart';
import 'package:infosha/screens/feed/component/view_feed_bottomsheet.dart';
import 'package:infosha/screens/feed/component/feed_reaction_bottomsheet.dart';
import 'package:infosha/screens/subscription/component/subscription_screen.dart';
import 'package:infosha/screens/viewUnregistered/component/view_unregistered_user.dart';

class ViewFeed extends StatefulWidget {
  String postUrl;

  ViewFeed({required this.postUrl});

  @override
  State<ViewFeed> createState() => _ViewFeedState();
}

class _ViewFeedState extends State<ViewFeed> {
  late FeedModel provider;
  VideoPlayerController? controller;
  bool isVisible = false;
  late UserViewModel userProvider;
  final nameAndGenderStoringController = Get.find<NameAndGenderStoringController>();
  int selectedReactionId = -1;
  String loggedinUser = '';
  bool isSubscriptionActive = false;
  String activeSubscriptionPlanName = '';
  bool get _isVideo {
    final fileUrl = provider.viewFeedListModel.data?.data?.first.fileUrl;
    if (fileUrl == null) return false;
    // A more robust check for video file extensions.
    return ['.mp4', '.m4v', '.mov'].any((ext) => fileUrl.toLowerCase().endsWith(ext));
  }

  @override
  void initState() {
    super.initState();
    provider = Provider.of<FeedModel>(context, listen: false);
    userProvider = Provider.of<UserViewModel>(context, listen: false);

    List<String> parts = widget.postUrl.split('/');
    String feedId = parts.last;
    debugPrint('Feed ID: $feedId');

    Future.microtask(() {
      context.read<FeedModel>().fetchSinglePosts(feedId).then((_) {
        if (_isVideo && mounted) {
          _initializeVideo();
        }
      });
    });
    initialDynamic = "null";

    getUserData().then((data) {
      setState(() {
        loggedinUser = data["name"];
        isSubscriptionActive = data["subscriptionStatus"];
        activeSubscriptionPlanName = data["subscriptionPlanName"];
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    // Clear the data for this specific feed view from the provider to release memory.
    provider.clearViewFeedData();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    final fileUrl = provider.viewFeedListModel.data?.data?.first.fileUrl;
    if (fileUrl == null) return;
    controller = VideoPlayerController.networkUrl(Uri.parse(fileUrl))
      ..initialize().then((value) {
        if (mounted) setState(() {});
      })
      ..setLooping(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1EBEC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0BA7C1),
        title: Text(
          "Feeds".tr,
          style: textStyleWorkSense(fontSize: 22),
        ),
      ),
      body: Consumer<FeedModel>(builder: (context, provider, child) {
        return provider.isViewLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: baseColor,
                ),
              )
            : Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      APPICONS.feedBackground,
                      height: Get.height * 0.4,
                      width: Get.width,
                      fit: BoxFit.fill,
                    ),
                  ),
                  provider.viewFeedListModel.data == null
                      ? SizedBox(
                          width: Get.width,
                          height: Get.height,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.not_interested,
                                size: 50,
                                color: Colors.black,
                              ),
                              Text(
                                "Post Not Found",
                                style: TextStyle(color: Colors.black, fontSize: 24),
                              )
                            ],
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.all(10.0),
                          width: Get.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2)]),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (provider.viewFeedListModel.data!.data![0].feed_item_type == "activity")
                                  headingContainer(
                                      provider.viewFeedListModel.data!.data![0].user!.profile!.profileUrl ?? "",
                                      provider.viewFeedListModel.data!.data![0].user == null
                                          ? ""
                                          : provider.viewFeedListModel.data!.data![0].user!.username ?? "",
                                      provider.viewFeedListModel.data!.data![0].user == null
                                          ? ""
                                          : provider.viewFeedListModel.data!.data![0].user!.number ?? "",
                                      provider.viewFeedListModel.data!.data![0].user!.id.toString(),
                                      provider.viewFeedListModel.data!.data![0].id.toString(),
                                      provider.viewFeedListModel.data!.data![0].user!.activeSubscriptionPlanName != null
                                          ? provider
                                                  .viewFeedListModel.data!.data![0].user!.activeSubscriptionPlanName ??
                                              ""
                                          : "",
                                      true,
                                      (provider.viewFeedListModel.data!.data![0].user!.isLocked != null &&
                                          provider.viewFeedListModel.data!.data![0].user!.isLocked == true),
                                      provider.viewFeedListModel.data!.data![0].user!.isRegisteredUser),
                                if (provider.viewFeedListModel.data!.data![0].feed_item_type == "post")
                                  headingContainerPost(
                                      provider.viewFeedListModel.data!.data![0].user!.profile!.profileUrl ?? "",
                                      provider.viewFeedListModel.data!.data![0].user == null
                                          ? ""
                                          : provider.viewFeedListModel.data!.data![0].user!.username ?? "",
                                      provider.viewFeedListModel.data!.data![0].user == null
                                          ? ""
                                          : provider.viewFeedListModel.data!.data![0].user!.number ?? "",
                                      provider.viewFeedListModel.data!.data![0].user!.id.toString(),
                                      provider.viewFeedListModel.data!.data![0].id.toString(),
                                      provider.viewFeedListModel.data!.data![0].user!.activeSubscriptionPlanName != null
                                          ? provider
                                                  .viewFeedListModel.data!.data![0].user!.activeSubscriptionPlanName ??
                                              ""
                                          : "",
                                      true,
                                      (provider.viewFeedListModel.data!.data![0].user!.isLocked != null &&
                                          provider.viewFeedListModel.data!.data![0].user!.isLocked == true),
                                      provider.viewFeedListModel.data!.data![0].user!.isRegisteredUser),
                                if (provider.viewFeedListModel.data!.data![0].fileUrl != null &&
                                    (provider.viewFeedListModel.data!.data![0].fileUrl!.contains(".png") ||
                                        provider.viewFeedListModel.data!.data![0].fileUrl!.contains(".jpg") ||
                                        provider.viewFeedListModel.data!.data![0].fileUrl!.contains(".jpeg") ||
                                        provider.viewFeedListModel.data!.data![0].fileUrl!.contains(".webp"))) ...[
                                  imagePostContainer()
                                ],
                                if (provider.viewFeedListModel.data!.data![0].fileUrl != null &&
                                    (provider.viewFeedListModel.data!.data![0].fileUrl!.contains('.mp4') ||
                                        provider.viewFeedListModel.data!.data![0].fileUrl!.contains('.m4v') ||
                                        provider.viewFeedListModel.data!.data![0].fileUrl!.contains('.mov'))) ...[
                                  videoPostContainer()
                                ],
                                if (provider.viewFeedListModel.data!.data![0].description != null &&
                                    provider.viewFeedListModel.data!.data![0].feed_item_type == "post") ...[
                                  textPostContainer()
                                ],
                                if (provider.viewFeedListModel.data!.data![0].feed_item_type == "activity" &&
                                    (provider.viewFeedListModel.data!.data![0].activity_type == "nickname_updated" ||
                                        provider.viewFeedListModel.data!.data![0].activity_type ==
                                            "review_created")) ...[
                                  updateTextPostContainerForNickname(
                                      provider.viewFeedListModel.data!.data![0].user == null
                                          ? ""
                                          : provider.viewFeedListModel.data!.data![0].user!.number ?? "",
                                      provider.viewFeedListModel.data!.data![0].user!.id.toString(),
                                      provider.viewFeedListModel.data!.data![0].user!.isRegisteredUser,
                                      provider.viewFeedListModel.data!.data![0].userId.toString())
                                ],
                                if (provider.viewFeedListModel.data!.data![0].feed_item_type == "activity" &&
                                    provider.viewFeedListModel.data!.data![0].activity_type ==
                                        "profile_photo_updated") ...[
                                  updateTextPostContainerForProfilePhoto(
                                      provider.viewFeedListModel.data!.data![0].userId.toString(),
                                      provider.viewFeedListModel.data!.data![0].user!.number ?? "")
                                ],
                                if (provider.viewFeedListModel.data!.data![0].feed_item_type == "activity" &&
                                    provider.viewFeedListModel.data!.data![0].activity_type == "bio_update") ...[
                                  updateTextPostContainerForNickname(
                                      provider.viewFeedListModel.data!.data![0].user == null
                                          ? ""
                                          : provider.viewFeedListModel.data!.data![0].user!.number ?? "",
                                      provider.viewFeedListModel.data!.data![0].user!.id.toString(),
                                      provider.viewFeedListModel.data!.data![0].user!.isRegisteredUser,
                                      provider.viewFeedListModel.data!.data![0].userId.toString())
                                ],
                                if (provider.viewFeedListModel.data!.data![0].feed_item_type == "activity" &&
                                    provider.viewFeedListModel.data!.data![0].activity_type == "social_update") ...[
                                  updateTextPostContainerForNickname(
                                      provider.viewFeedListModel.data!.data![0].user == null
                                          ? ""
                                          : provider.viewFeedListModel.data!.data![0].user!.number ?? "",
                                      provider.viewFeedListModel.data!.data![0].user!.id.toString(),
                                      provider.viewFeedListModel.data!.data![0].user!.isRegisteredUser,
                                      provider.viewFeedListModel.data!.data![0].userId.toString())
                                ],
                                voteContainer()
                              ],
                            ),
                          ),
                        ),
                ],
              );
      }),
    );
  }

  headingContainer(String image, String name, String number, String id, String feedid, String plan, bool isActive,
      bool isLocked, bool? isRegieteredUser) {
    return GestureDetector(
      onTap: () {
        if (isRegieteredUser!) {
          Get.to(() => ViewProfileScreen(id: id));
        } else {
          Get.to(() => ViewUnregisteredUser(contactId: number, id: number, isOther: true));
        }
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
                                // Resize image in memory to the size of the widget to save RAM.
                                // Assuming a 3x pixel density, a radius of ~40 logical pixels -> 240 physical pixels.
                                memCacheWidth: 240,
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
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CustomText(
                        text: name,
                        color: const Color(0xFF46464F),
                        weight: fontWeightSemiBold,
                        fontSize: 14,
                      ),
                      const SizedBox(width: 10),
                      if (plan.isNotEmpty) ...[
                        // const SizedBox(width: 5),
                        Image(
                          height: 30,
                          image: AssetImage(plan.contains("lord")
                              ? APPICONS.lordicon
                              : plan.contains("god")
                                  ? APPICONS.godstatuspng
                                  : APPICONS.kingstutspicpng),
                        )
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
                ),
              ),
            ],
          ),
          if (isLocked) ...[LockWidget()]
        ],
      ),
    );
  }

  headingContainerPost(String image, String name, String number, String id, String feedid, String plan, bool isActive,
      bool isLocked, bool? isRegieteredUser) {
    return GestureDetector(
      onTap: () {
        if (isRegieteredUser!) {
          Get.to(() => ViewProfileScreen(id: id));
        } else {
          Get.to(() => ViewUnregisteredUser(contactId: number, id: number, isOther: true));
        }
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
                    children: [
                      CustomText(
                        text: name,
                        color: const Color(0xFF46464F),
                        weight: fontWeightSemiBold,
                        fontSize: 14,
                      ),
                      SizedBox(width: 10),
                      if (plan.isNotEmpty) ...[
                        Image(
                          height: 30,
                          image: AssetImage(plan.contains("lord")
                              ? APPICONS.lordicon
                              : plan.contains("god")
                                  ? APPICONS.godstatuspng
                                  : APPICONS.kingstutspicpng),
                        ),
                      ],
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
                                Get.to(() => EditFeed(feedListData: provider.viewFeedListModel.data!.data![0]));
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
                          memCacheWidth: 240,
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
                                  Get.to(() => EditFeed(feedListData: provider.viewFeedListModel.data!.data![0]));
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
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      height: Get.height * 0.44,
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: provider.viewFeedListModel.data!.data![0].fileUrl == null
            ? Image.asset(APPICONS.profileicon)
            : CachedNetworkImage(
                // Resize image in memory to save RAM.
                // Let's assume a max width of the screen (e.g. 400 logical pixels) and 3x density.
                memCacheWidth: 1200,
                imageUrl: provider.viewFeedListModel.data!.data![0].fileUrl!,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: baseColor)),
                errorWidget: (context, url, error) {
                  return Image.asset(APPICONS.profileicon);
                },
              ),
      ),
    );
  }

  videoPostContainer() {
    return VisibilityDetector(
      key: Key("0"),
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
          child: controller == null
              ? const CircularProgressIndicator(color: baseColor)
              : controller!.value.isInitialized == false
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

  voteContainer() {
    var model = provider.viewFeedListModel.data!.data![0];
    final String comment = provider.viewFeedListModel.data!.data![0].totalRepliesComment == 1 ? "comment" : "comments";
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
                        .showReactions(context, provider.viewFeedListModel.data!.data![0].id.toString());
                  },
                  child: Row(
                    children: [
                      Image(
                        width: 40,
                        image: AssetImage(provider.convertReactionIdToPathNew(-1)),
                      ),
                      const SizedBox(width: 5),
                      Text(provider.viewFeedListModel.data!.data![0].totalReactionCount.toString(),
                          style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    CommentBottomSheet().showComments(context, 0);
                  },
                  child: Text("${provider.viewFeedListModel.data!.data![0].totalRepliesComment.toString()} $comment",
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
                containerWidth: Get.width * 0.9,
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
                      ],
                    ),
                  );
                }),
                // onReactionSelected: (val) {
                //   String name = getReactionName(val.id);
                //   setState(() {
                //     selectedReactionId = val.id;
                //     provider.viewFeedListModel.data!.data![0].reactionName = name;
                //   });

                //   provider.addFeedReaction(provider.viewFeedListModel.data!.data![0].id.toString(), name).then((value) {
                //     setState(() {
                //       if (int.parse(provider.viewFeedListModel.data!.data![0].totalReactionCount.toString()) > value) {
                //         selectedReactionId = -1;
                //         provider.viewFeedListModel.data!.data![0].reactionName = null;
                //       }
                //       provider.viewFeedListModel.data!.data![0].totalReactionCount = value;
                //     });
                //   });
                // },

                onReactionSelected: (val) {
                  String name = getReactionName(val.id);

                  final model = provider.viewFeedListModel.data!.data![0];

                  // Save previous states (for rollback)
                  final prevReactionId = selectedReactionId;
                  final prevReactionName = model.reactionName;
                  final prevReactionCount = model.totalReactionCount;

                  // ---- OPTIMISTIC UI UPDATE ----
                  setState(() {
                    selectedReactionId = val.id;
                    model.reactionName = name;
                    model.totalReactionCount = prevReactionCount! + 1; // instant update
                  });

                  // ---- CALL API ----
                  provider.addFeedReaction(model.id.toString(), name).then((countFromApi) {
                    // If API response is valid → set correct count
                    setState(() {
                      // model.totalReactionCount = countFromApi;
                      if (countFromApi >= model.totalReactionCount!) {
                        model.totalReactionCount = countFromApi;
                      }
                    });
                  }).catchError((_) {
                    // ---- API FAILED → ROLLBACK ----
                    setState(() {
                      selectedReactionId = prevReactionId;
                      model.reactionName = prevReactionName;
                      model.totalReactionCount = prevReactionCount;
                    });
                  });
                },

                // onPressed: () {
                //   if (provider.viewFeedListModel.data!.data![0].reactionName != null) {
                //     provider
                //         .addFeedReaction(
                //             provider.viewFeedListModel.data!.data![0].id.toString(), provider.viewFeedListModel.data!.data![0].reactionName!)
                //         .then((value) {
                //       selectedReactionId = -1;
                //       provider.viewFeedListModel.data!.data![0].reactionName = null;

                //       provider.viewFeedListModel.data!.data![0].totalReactionCount = value;
                //       setState(() {});
                //     });
                //   } else {
                //     provider.addFeedReaction(provider.viewFeedListModel.data!.data![0].id.toString(), "like").then((value) {
                //       selectedReactionId = 0;
                //       provider.viewFeedListModel.data!.data![0].reactionName = "like";

                //       provider.viewFeedListModel.data!.data![0].totalReactionCount = value;
                //       setState(() {});
                //     });
                //   }
                // },
                onPressed: () {
                  final model = provider.viewFeedListModel.data!.data![0];

                  final prevReactionId = selectedReactionId;
                  final prevReactionName = model.reactionName;
                  final prevReactionCount = model.totalReactionCount;

                  // User removes reaction
                  if (model.reactionName != null) {
                    // OPTIMISTIC UPDATE
                    setState(() {
                      selectedReactionId = -1;
                      model.reactionName = null;
                      // model.totalReactionCount = prevReactionCount! - 1;
                      model.totalReactionCount = safeCount(prevReactionCount! - 1);
                    });

                    provider.addFeedReaction(model.id.toString(), prevReactionName!).then((countApi) {
                      setState(() {
                        model.totalReactionCount = countApi;
                      });
                    }).catchError((_) {
                      // ROLLBACK
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
                      model.totalReactionCount = prevReactionCount! + 1;
                    });

                    provider.addFeedReaction(model.id.toString(), newReaction).then((countApi) {
                      setState(() {
                        model.totalReactionCount = countApi;
                      });
                    }).catchError((_) {
                      // ROLLBACK
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
                    CommentBottomSheet().showComments(context, 0);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isVisible
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
                          style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
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
                    Share.share('https://infosha.org/feed/${provider.viewFeedListModel.data!.data![0].id}');
                  },
                  child: SizedBox(
                    // width: 40,
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
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            provider.viewFeedListModel.data!.data![0].description ?? "",
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
    );
  }

  /* commentContainer() {
    return Visibility(
      visible: isVisible,
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
                      key: provider.viewFeedListModel.data!.data![0].formKey,
                      child: TextFormField(
                        focusNode:
                            provider.viewFeedListModel.data!.data![0].focusNode,
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: Key("1"),
                        controller: provider
                            .viewFeedListModel.data!.data![0].replyController!,
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
                    if (provider
                        .viewFeedListModel.data!.data![0].formKey!.currentState!
                        .validate()) {
                      provider
                          .addFeedReply(
                              provider.viewFeedListModel.data!.data![0].id
                                  .toString(),
                              provider.viewFeedListModel.data!.data![0]
                                  .replyController!.text
                                  .trim())
                          .then((value) {
                        provider.fetchPostsData(0).then((value) {
                          setState(() {
                            provider.viewFeedListModel.data!.data![0] = value;
                          });
                        });
                        provider
                            .viewFeedListModel.data!.data![0].replyController!
                            .clear();

                        provider.viewFeedListModel.data!.data![0].focusNode!
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
                bottom: provider.viewFeedListModel.data!.data![0]
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
          if (provider.viewFeedListModel.data!.data![0].repliesComment !=
              null) ...[
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: provider
                  .viewFeedListModel.data!.data![0].repliesComment!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var data = provider
                    .viewFeedListModel.data!.data![0].repliesComment![index];
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
      ),
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
        /* Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                VoteButtonSmall(
                  usercounts: 10,
                  isLikeButton: true,
                  likestatus: 0,
                  isActive: false,
                  color: Colors.white,
                  oncallback: (value) {},
                ),
                VoteButtonSmall(
                  usercounts: 10,
                  isLikeButton: false,
                  likestatus: 1,
                  isActive: false,
                  color: Colors.white,
                  oncallback: (value) {},
                ),
                GestureDetector(
                  onTap: () async {},
                  child: Container(
                    width: null,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      //  mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(APPICONS.replyIcon,
                            height: Get.height * 0.025),
                        UIHelper.horizontalSpaceSm,
                        Text("Reply".tr,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ), */
      ],
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
    final description = provider.viewFeedListModel.data!.data![0].description ?? "";
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
        if (restText.contains("nicknamed")) {
          oldName = restText
              .split(' ')
              .sublist(restText.split(' ').indexOf("nicknamed") + 1, restText.split(' ').indexOf("as"))
              .join(' ');
          newName =
              restText.split(' ').sublist(restText.split(' ').indexOf("as") + 1, restText.split(' ').length).join(' ');
        }
      }

      return Column(
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

          /// ✅ When user IS subscribed
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
      );
    }
  }

  updateTextPostContainerForProfilePhoto(String userId, String number) {
    final description = provider.viewFeedListModel.data!.data![0].description ?? "";

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
    }

    return Column(
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
      text = text.replaceAll("nicknamed", "saved");
      text = text.replaceAll("has", "");
      text = text.replaceAll("as", "");
      text = text;
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
        spans.add(TextSpan(text: " has saved the"));
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
}
