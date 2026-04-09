import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/config/const.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/widgets/locked_widget.dart';
import 'package:infosha/followerscreen/followerscreen.dart';
import 'package:infosha/screens/feed/component/edit_feed.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infosha/screens/feed/controller/feed_model.dart';
import 'package:infosha/screens/feed/model/feed_list_model.dart';
import 'package:infosha/screens/otherprofile/view_profile_screen.dart';

class CommentBottomSheet {
  showComments(BuildContext context, int index) async {
    return await showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Get.isDarkMode ? const Color(0xff13161a) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(22), topRight: Radius.circular(22))),
      isScrollControlled: true,
      context: context,
      builder: (_) => CustomSheet(index: index),
    );
  }
}

// ignore: must_be_immutable
class CustomSheet extends StatefulWidget {
  int index;
  CustomSheet({required this.index});

  @override
  State<CustomSheet> createState() => _CustomSheetState();
}

class _CustomSheetState extends State<CustomSheet> {
  late FeedModel provider;
  TextEditingController commentController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isReply = false;
  String replyId = "";

  @override
  void initState() {
    isReply = false;
    provider = Provider.of<FeedModel>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.61,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Consumer<FeedModel>(builder: (context, provider, child) {
              return Stack(
                children: [
                  Padding(
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
                              text: "Comments",
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
                        SizedBox(height: Get.height * 0.03),
                        if (provider.feedListModel.data != null && provider.feedListModel.data!.data![widget.index].repliesComment != null) ...[
                          Expanded(
                            child: ListView.separated(
                              controller: controller,
                              itemCount: provider.feedListModel.data!.data![widget.index].repliesComment!.length,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Divider(color: Colors.grey.shade300, height: 1),
                              ),
                              itemBuilder: (context, index) {
                                var data = provider.feedListModel.data!.data![widget.index].repliesComment![index];
                                return replyCommentContainer(index, data);
                              },
                            ),
                          )
                        ],
                        SafeArea(
                          child: SizedBox(
                            height: Get.height * 0.06,
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: Get.width,
                      height: Get.height * 0.07,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              child: Form(
                                child: TextFormField(
                                  focusNode: focusNode,
                                  controller: commentController,
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
                                      hintStyle: textStyleWorkSense(fontSize: 14.0, color: const Color(0xFF46464F), weight: fontWeightRegular)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: Get.width * 0.02),
                          GestureDetector(
                            onTap: () {
                              if (commentController.text.trim().isNotEmpty) {
                                focusNode.unfocus();

                                if (isReply) {
                                  provider.addReviewReply(replyId, commentController.text.trim()).then((value) {
                                    isReply = false;
                                    provider.fetchPostsData(provider.feedListModel.data!.data![widget.index].id.toString()).then((value) {
                                      print("fetchPostsData then ===> ${value.toJson()}");
                                      setState(() {
                                        provider.feedListModel.data!.data![widget.index] = value;
                                      });
                                    });

                                    commentController.clear();
                                  });
                                } else {
                                  provider
                                      .addFeedReply(provider.feedListModel.data!.data![widget.index].id.toString(), commentController.text.trim())
                                      .then((value) {
                                    provider.fetchPostsData(provider.feedListModel.data!.data![widget.index].id.toString()).then((value) {
                                      setState(() {
                                        provider.feedListModel.data!.data![widget.index] = value;
                                      });
                                    });

                                    commentController.clear();
                                  });
                                }
                              }
                            },
                            child: provider.isAddComment
                                ? const CircularProgressIndicator(color: baseColor)
                                : Image.asset(
                                    "images/sendIcon.png",
                                    height: Get.height * 0.06,
                                  ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
          );
        },
      ),
    );
  }

  headingCommentContainer(String image, String name, String number, String id, String commentId, bool isShow) {
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
                ],
              ),
              trailing: isShow == false
                  ? null
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
                          PopupMenuItem<int>(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              value: 0,
                              onTap: () {
                                replyId = commentId;
                                isReply = true;
                                focusNode.requestFocus();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 10),
                                  const Image(
                                    image: AssetImage("images/comments.png"),
                                    height: 20,
                                    width: 20,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 10),
                                  Text("Reply Comment".tr),
                                ],
                              ))
                        ];
                      },
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
    );
  }

  replyCommentContainer(int index, RepliesComment data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: headingCommentContainer(
                  data.profile ?? "", data.username ?? "", data.number ?? "", data.addedBy.toString(), data.id.toString(), true),
            ),
            if (data.isLocked != null && data.isLocked == true) ...[LockWidget()]
          ],
        ),
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
        if (data.feedCommentReplies != null && data.feedCommentReplies!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 5),
            child: Text(
              "Reply",
              style: GoogleFonts.workSans(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ListView.builder(
            itemCount: data.feedCommentReplies!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var tempData = data.feedCommentReplies![index];
              return innerComment(index, tempData);
            },
          )
        ],
      ],
    );
  }

  innerComment(int index, FeedCommentReplies data) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => ViewProfileScreen(id: data.feedUserId!.toString()));
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: Get.width * 0.17,
                        height: Get.height * 0.08,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: (data.profile ?? "").isEmpty
                              ? Image.asset(APPICONS.profileicon)
                              : isBase64(data.profile!)
                                  ? Image.memory(base64Decode(data.profile!), fit: BoxFit.cover)
                                  : CachedNetworkImage(
                                      imageUrl: data.profile!,
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
                                text: data.username ?? "",
                                color: const Color(0xFF46464F),
                                weight: fontWeightSemiBold,
                                fontSize: 14,
                              ),
                            ],
                          ),
                          subtitle: CustomText(
                            text: data.number ?? "",
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
              if (data.isLocked != null && data.isLocked == true) ...[LockWidget()]
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 10, bottom: 15, top: 0),
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
      ),
    );
  }
}
