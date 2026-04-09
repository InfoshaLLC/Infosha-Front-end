import 'package:flutter/material.dart';
import 'package:flutter_feed_reaction/flutter_feed_reaction.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/reaction.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/otherprofile/all_reaction_sheet.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';

import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyReactionButton extends StatefulWidget {
  String reactionCount, commentid, reactionName;
  void Function(int) oncallback;
  MyReactionButton(
      {super.key,
      required this.reactionCount,
      required this.reactionName,
      required this.commentid,
      required this.oncallback});

  @override
  _MyReactionButtonState createState() => _MyReactionButtonState();
}

class _MyReactionButtonState extends State<MyReactionButton>
    with SingleTickerProviderStateMixin {
  int selectedReactionId = -1;
  TabController? _controller;

  void initState() {
    setState(() {
      selectedReactionId = widget.reactionName == "love"
          ? 0
          : widget.reactionName == "wow"
              ? 1
              : widget.reactionName == "lol"
                  ? 2
                  : widget.reactionName == "sad"
                      ? 3
                      : widget.reactionName == "angry"
                          ? 4
                          : -1;
    });

    _controller = TabController(vsync: this, length: 5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return FlutterFeedReaction(
        // containerWidth: Get.width * 0.1,
        reactions: EmojiReactions.reactions,
        spacing: 0.0,

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
                Image(
                  width: selectedReactionId == -1 ? 40 : 30.0,
                  image: AssetImage(
                      provider.convertReactionIdToPath(selectedReactionId)),
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    Get.bottomSheet(AllReactionSheet(),
                        isScrollControlled: true, isDismissible: true);
                    // ScrollableBottomSheet().openBottomSheet(context, headerWidget:
                    //         StatefulBuilder(builder: (context, setState) {
                    //   return Container(
                    //     color: whiteColor,
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Center(
                    //           child: Image(
                    //             width: 35,
                    //             image: AssetImage('images/linee.png'),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 20,
                    //         ),
                    //         CustomText(
                    //           text: 'List of people who reacted',
                    //           isHeading: true,
                    //           fontSize: 18.0,
                    //         ),
                    //         UIHelper.verticalSpaceSm,
                    //         TabBar(
                    //           //  dividerColor: Color(0xFF1B2870),
                    //           controller: _controller,
                    //           indicatorSize: TabBarIndicatorSize.label,

                    //           indicatorColor: Color(0xFF1B2870),
                    //           labelPadding: EdgeInsets.all(5),
                    //           //indicatorPadding: EdgeInsets.only(top: 15),
                    //           indicatorPadding: EdgeInsets.only(top: 15),
                    //           padding: EdgeInsets.only(top: 10),
                    //           indicatorWeight: 2.5,
                    //           labelColor: primaryColor,
                    //           labelStyle: textStyleWorkSense(
                    //               fontSize: 13.0, weight: fontWeightSemiBold),

                    //           unselectedLabelColor: Colors.black,
                    //           unselectedLabelStyle: textStyleWorkSense(
                    //               fontSize: 13.0,
                    //               color: Colors.black,
                    //               weight: fontWeightMedium),
                    //           onTap: (insex) {
                    //             setState(() {
                    //               _controller!.index = insex;
                    //             });
                    //             setState;
                    //           },
                    //           tabs: [
                    //             tabReaction(provider, 0, "4"),
                    //             tabReaction(provider, 1, "1"),
                    //             tabReaction(provider, 2, "2"),
                    //             tabReaction(provider, 3, "3"),
                    //             tabReaction(provider, 4, "4"),
                    //
                    // ],
                    //         ),
                    //       ],
                    //     ),
                    //   );
                    // }),
                    //     bodyWidget: TabBarView(
                    //       controller: _controller,
                    //       children: [
                    //         reactionList(),
                    //         reactionList(),
                    //         reactionList(),
                    //         reactionList(),
                    //         reactionList(),
                    //       ],
                    //     ),
                    //     backgroundColor: Colors.black,
                    //     backgroundOpacity: 0.1,
                    //     headerHeight: 175.0,
                    //     hasRadius: true);
                  },
                  child: Text(widget.reactionCount,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        }),
        onReactionSelected: (val) {
          setState(() {
            selectedReactionId = val.id;
          });
          String name = val.id == 0
              ? "love"
              : val.id == 1
                  ? "wow"
                  : val.id == 2
                      ? "lol"
                      : val.id == 3
                          ? "sad"
                          : "angry";

          UserViewModel provider = Provider.of(context, listen: false);
          provider.addReaction(widget.commentid, name).then((value) {
            widget.oncallback(value);
          });
        },
        onPressed: () {
          String name = selectedReactionId == 0
              ? "love"
              : selectedReactionId == 1
                  ? "wow"
                  : selectedReactionId == 2
                      ? "lol"
                      : selectedReactionId == 3
                          ? "sad"
                          : "angry";

          UserViewModel provider = Provider.of(context, listen: false);
          provider.addReaction(widget.commentid, name).then((value) {
            widget.oncallback(value);
          });
          setState(() {
            selectedReactionId = -1;
          });
        },
        dragSpace: 50.0,
      );
    });
  }

  Widget reactionList() {
    // return Expanded(
    //   child: SliverList(
    //       delegate: SliverChildBuilderDelegate(
    //           (context, index) => Container(
    //                 color: Colors.red,
    //                 alignment: Alignment.centerLeft,
    //                 padding: EdgeInsets.symmetric(vertical: 10),
    //                 child: Text("$index"),
    //               ),
    //           childCount: 100)),
    // );
    return const SliverToBoxAdapter();
  }

  Column tabReaction(UserViewModel provider, reaction, counts) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(
          width: 40,
          image: AssetImage(provider.convertReactionIdToPath(reaction)),
        ),
        CustomText(
            text: counts,
            fontSize: 14.0,
            weight: fontWeightExtraBold,
            color: _controller!.index == reaction ? primaryColor : Colors.grey)
      ],
    );
  }
}
