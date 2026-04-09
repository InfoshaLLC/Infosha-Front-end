// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infosha/views/app_icons.dart';

class FeedVoteButton extends StatefulWidget {
  bool? isLikeButton;
  int usercounts;
  int likestatus;
  bool isActive;
  var oncallback;
  Color? color;
  void Function()? onTap;

  FeedVoteButton(
      {super.key,
      this.isLikeButton,
      this.oncallback,
      this.color,
      required this.usercounts,
      required this.likestatus,
      required this.isActive,
      this.onTap});

  @override
  State<FeedVoteButton> createState() => _VoteButtonState();
}

class _VoteButtonState extends State<FeedVoteButton> {
  int favoriteCount = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      favoriteCount = widget.usercounts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.24,
      height: Get.height * 0.058,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                widget.oncallback(widget.likestatus);
              },
              child: Container(
                height: Get.height * 0.055,
                padding: const EdgeInsets.only(left: 14),
                color: Colors.transparent,
                child: Center(
                  child: SvgPicture.asset(
                    widget.isLikeButton!
                        ? widget.isActive
                            ? APPICONS.likedsvg
                            : APPICONS.likesvg
                        : widget.isActive
                            ? APPICONS.dislikedsvg
                            : APPICONS.dislikesvg,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: widget.onTap,
              child: Container(
                height: Get.height * 0.055,
                padding: const EdgeInsets.only(right: 14),
                color: Colors.transparent,
                child: Center(
                    child: Text(widget.usercounts.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
