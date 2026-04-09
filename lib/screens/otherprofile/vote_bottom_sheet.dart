// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/Controller/models/user_voting_model.dart';
import 'package:infosha/screens/viewUnregistered/component/view_unregistered_user.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/widgets/locked_widget.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class VoteBottomSheet {
  showVote(BuildContext context, String id, bool isLike) async {
    return await showModalBottomSheet(
      isDismissible: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22), topRight: Radius.circular(22))),
      isScrollControlled: true,
      context: context,
      builder: (_) => VoteSheet(
        id: id,
        isLike: isLike,
      ),
    );
  }
}

class VoteSheet extends StatefulWidget {
  String id;
  bool isLike;
  VoteSheet({super.key, required this.id, required this.isLike});

  @override
  State<VoteSheet> createState() => _VoteSheetState();
}

class _VoteSheetState extends State<VoteSheet> {
  late UserViewModel provider;
  late UserVotingModel userVotingModel;
  bool isLoading = false;

  @override
  void initState() {
    provider = Provider.of<UserViewModel>(context, listen: false);

    getData();

    super.initState();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    userVotingModel = await Provider.of<UserViewModel>(context, listen: false)
        .userVoting(widget.id, widget.isLike);
    setState(() {
      isLoading = false;
    });
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
          return Consumer<UserViewModel>(builder: (context, provider, child) {
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
                        text:
                            "List of people who ${widget.isLike ? "upvoted" : "downvoted"}",
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
                  isLoading
                      ? SizedBox(
                          height: Get.height * 0.4,
                          width: Get.width,
                          child: const Center(
                              child:
                                  CircularProgressIndicator(color: baseColor)),
                        )
                      : userVotingModel.data == null
                          ? const SizedBox()
                          : Expanded(
                              child: ListView.builder(
                                controller: controller,
                                itemCount: userVotingModel.data!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var data = userVotingModel.data![index];
                                  return reactionList(widget.isLike, data);
                                },
                              ),
                            )
                ],
              ),
            );
          });
        },
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

  reactionList(bool isLiked, Data data) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ViewUnregisteredUser(
              contactId: data.number.toString(),
              id: data.number.toString(),
              isOther: true,
            ));
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
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                          color: baseColor),
                                    ),
                                  ),
                      )),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Column(
                    children: [
                      Row(
                        children: [
                          if (data.createdAt != null) ...[
                            Text(
                              Jiffy.parse(
                                      data.createdAt != null
                                          ? utcToLocal(data.createdAt!)
                                          : DateTime.now().toString(),
                                      isUtc: true)
                                  .fromNow(),
                              style: const TextStyle(
                                  color: Color(0xFFABAAB4), fontSize: 14),
                            )
                          ],
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data.userName ?? "",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.verified,
                                color: Color(0xFF007EFF),
                                size: 16.0,
                              ),
                            ],
                          ),
                          SvgPicture.asset(
                            isLiked ? APPICONS.likedsvg : APPICONS.dislikedsvg,
                            // color: isLiked ? primaryColor : lightGrey,
                          )
                        ],
                      ),
                    ],
                  ),
                  subtitle: Text(
                    data.number ?? "",
                    style:
                        const TextStyle(color: Color(0xFF767680), fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          if (data.isLocked != null && data.isLocked == true) ...[LockWidget()]
        ],
      ),
    );
  }
}

String utcToLocal(String date) {
  DateTime utcTime = DateTime.parse(date);

  DateTime localTime = utcTime.toLocal();
  String formattedLocalTime =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(localTime);

  return formattedLocalTime;
}
