import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/Controller/models/comment_reaction_model.dart';
import 'package:infosha/screens/feed/component/feed_tile.dart';
import 'package:infosha/screens/feed/controller/feed_model.dart';
import 'package:infosha/screens/feed/model/feed_reaction_model.dart';
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';
import 'package:infosha/screens/otherprofile/vote_bottom_sheet.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/widgets/locked_widget.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class FeedReactionBottomSheet {
  showReactions(BuildContext context, String commentid,
      {String? catID, Function? callback, bool? isFullScreen}) async {
    return await showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Get.isDarkMode ? const Color(0xff13161a) : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22), topRight: Radius.circular(22))),
      isScrollControlled: true,
      context: context,
      builder: (_) => CustomSheet(
        commentid: commentid,
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomSheet extends StatefulWidget {
  String commentid;
  CustomSheet({super.key, required this.commentid});

  @override
  State<CustomSheet> createState() => _CustomSheetState();
}

class _CustomSheetState extends State<CustomSheet>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  late FeedModel provider;

  List<FeedReactionData> likeList = [];
  List<FeedReactionData> dislikeList = [];
  List<FeedReactionData> loveList = [];
  List<FeedReactionData> hahaList = [];
  List<FeedReactionData> wowList = [];
  List<FeedReactionData> angryList = [];
  List<FeedReactionData> cryList = [];
  List<FeedReactionData> facepalmList = [];

  @override
  void initState() {
    provider = Provider.of<FeedModel>(context, listen: false);
    Future.microtask(
            () => context.read<FeedModel>().getReactionOfFeed(widget.commentid))
        .then(
      (value) {
        filterList();
      },
    );
    _controller = TabController(vsync: this, length: 8);
    super.initState();
  }

  filterList() async {
    if (provider.feedReactionModel.data != null) {
      for (var item in provider.feedReactionModel.data!) {
        if (item.reactionName == 'like') {
          likeList.add(item);
        } else if (item.reactionName == 'dislike') {
          dislikeList.add(item);
        } else if (item.reactionName == 'love') {
          loveList.add(item);
        } else if (item.reactionName == 'haha') {
          hahaList.add(item);
        } else if (item.reactionName == 'wow') {
          wowList.add(item);
        } else if (item.reactionName == 'angry') {
          angryList.add(item);
        } else if (item.reactionName == 'cry') {
          cryList.add(item);
        } else if (item.reactionName == 'facepalm') {
          facepalmList.add(item);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.61,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) =>
            StatefulBuilder(builder: (context, setState) {
              return Consumer<FeedModel>(builder: (context, provider, child) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Image(
                          width: 35,
                          image: AssetImage('images/linee.png'),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.03),
                      Row(
                        children: [
                          CustomText(
                            text: 'List of people who reacted',
                            isHeading: true,
                            fontSize: 18.0,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(Icons.close),
                          )
                        ],
                      ),
                      provider.isReactionOfComment
                          ? SizedBox(
                              height: Get.height * 0.4,
                              width: Get.width,
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      color: baseColor)),
                            )
                          : Expanded(
                              child: Column(children: [
                                TabBar(
                                  controller: _controller,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicatorColor: const Color(0xFF1B2870),
                                  labelPadding: const EdgeInsets.all(5),
                                  indicatorPadding:
                                      const EdgeInsets.only(top: 15),
                                  padding: const EdgeInsets.only(top: 10),
                                  indicatorWeight: 2.5,
                                  labelColor: primaryColor,
                                  labelStyle: textStyleWorkSense(
                                      fontSize: 13.0,
                                      weight: fontWeightSemiBold),
                                  unselectedLabelColor: Colors.black,
                                  unselectedLabelStyle: textStyleWorkSense(
                                      fontSize: 13.0,
                                      color: Colors.black,
                                      weight: fontWeightMedium),
                                  onTap: (insex) {
                                    setState(() {
                                      _controller!.index = insex;
                                    });
                                    setState;
                                  },
                                  tabs: [
                                    tabReaction(provider, 0,
                                        likeList.length.toString()),
                                    tabReaction(provider, 1,
                                        dislikeList.length.toString()),
                                    tabReaction(provider, 2,
                                        loveList.length.toString()),
                                    tabReaction(provider, 3,
                                        hahaList.length.toString()),
                                    tabReaction(
                                        provider, 4, wowList.length.toString()),
                                    tabReaction(provider, 5,
                                        angryList.length.toString()),
                                    tabReaction(
                                        provider, 6, cryList.length.toString()),
                                    tabReaction(provider, 7,
                                        facepalmList.length.toString()),
                                  ],
                                ),
                                const Divider(),
                                Expanded(
                                  child: TabBarView(
                                    controller: _controller,
                                    children: [
                                      reactionList(
                                          provider.convertReactionIdToPath(0),
                                          controller,
                                          likeList),
                                      reactionList(
                                          provider.convertReactionIdToPath(1),
                                          controller,
                                          dislikeList),
                                      reactionList(
                                          provider.convertReactionIdToPath(2),
                                          controller,
                                          loveList),
                                      reactionList(
                                          provider.convertReactionIdToPath(3),
                                          controller,
                                          hahaList),
                                      reactionList(
                                          provider.convertReactionIdToPath(4),
                                          controller,
                                          wowList),
                                      reactionList(
                                          provider.convertReactionIdToPath(4),
                                          controller,
                                          angryList),
                                      reactionList(
                                          provider.convertReactionIdToPath(4),
                                          controller,
                                          cryList),
                                      reactionList(
                                          provider.convertReactionIdToPath(4),
                                          controller,
                                          facepalmList),
                                    ],
                                  ),
                                ),
                              ]),
                            )
                    ],
                  ),
                );
              });
            }));
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

  /// used to show each rection user used in listview
  reactionList(String imagepath, ScrollController controller,
      List<FeedReactionData> list) {
    return ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          var data = list[index];
          return InkWell(
            onTap: () {
              Get.to(() => ViewProfileScreen(id: data.userId.toString()));
            },
            child: Stack(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: Get.width * 0.18,
                      height: Get.height * 0.085,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: SizedBox(
                          width: Get.width * 0.12,
                          height: Get.height * 0.055,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: data.profile == null ||
                                    data.profile ==
                                        "https://via.placeholder.com/150"
                                ? Image.asset('images/aysha.png')
                                : isBase64(data.profile!)
                                    ? Image.memory(base64Decode(data.profile!),
                                        fit: BoxFit.cover)
                                    : CachedNetworkImage(
                                        imageUrl: data.profile!,
                                        fit: BoxFit.fill,
                                        errorWidget: (context, url, error) =>
                                            Image.asset('images/aysha.png'),
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(
                                            color: baseColor,
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  Jiffy.parse(data.createdAt != null
                                          ? utcToLocal(data.createdAt!)
                                          : data.createdAt.toString())
                                      .fromNow(),
                                  style: const TextStyle(
                                      color: Color(0xFFABAAB4), fontSize: 14),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        data.username != null
                                            ? data.username ?? ""
                                            : "",
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                      const SizedBox(width: 5),
                                      /* if (
                                          data.user!.activeSubscription != null) ...[
                                        SizedBox(
                                          height: 15,
                                          child: Image(
                                            image: AssetImage(data.user!.activeSubscription
                                                    .toString()
                                                    .contains("lord")
                                                ? 'images/vector.png'
                                                : 'images/kingstutspic.png'),
                                          ),
                                        )
                                      ],
                                      const SizedBox(width: 5),
                                      if (data.user != null &&
                                          data.user!.isSubscriptionActive == true) ...[
                                        const Icon(
                                          Icons.verified,
                                          size: 15,
                                          color: Color(0xFF007EFF),
                                        )
                                      ], */
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width: 20,
                                    child: getReactionEmoji(getReactionId(
                                        list[index].reactionName ?? "like"))),
                                /* Image.asset(
                                  imagepath,
                                  width: imagepath == "assets/emojies/wow.png"
                                      ? 20
                                      : 26,
                                ) */
                              ],
                            ),
                          ],
                        ),
                        subtitle: Text(
                          data.number != null ? data.number ?? "" : "",
                          style: const TextStyle(
                              color: Color(0xFF767680), fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                if (data.isLocked != null && data.isLocked == true) ...[
                  LockWidget()
                ]
              ],
            ),
          );
        });
  }

  Column tabReaction(FeedModel provider, reaction, counts) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        getReactionEmoji(reaction),
        /* Container(
          width: provider.convertReactionIdToPath(reaction) ==
                  "assets/emojies/wow.png"
              ? Get.width * 0.06
              : Get.width * 0.08,
          height: provider.convertReactionIdToPath(reaction) ==
                  "assets/emojies/wow.png"
              ? Get.height * 0.03
              : Get.height * 0.04,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(provider.convertReactionIdToPath(reaction)),
                  fit: BoxFit.fill)),
        ), */
        CustomText(
            text: counts,
            fontSize: 14.0,
            weight: fontWeightExtraBold,
            color: _controller!.index == reaction ? primaryColor : Colors.grey)
      ],
    );
  }
}
