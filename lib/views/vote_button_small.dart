import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/ui_helpers.dart';

class VoteButtonSmall extends StatefulWidget {
  bool? isLikeButton;
  int usercounts;
  int likestatus;
  bool isActive;
  var oncallback;
  Color? color;

  VoteButtonSmall(
      {super.key,
      this.isLikeButton,
      this.oncallback,
      this.color,
      required this.usercounts,
      required this.likestatus,
      required this.isActive});

  @override
  State<VoteButtonSmall> createState() => _VoteButtonState();
}

class _VoteButtonState extends State<VoteButtonSmall> {
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
    return GestureDetector(
      onTap: () async {
        widget.oncallback(widget.likestatus);
      },
      // elevation: 0,
      // onPressed: () async {
      //   widget.oncallback(widget.likestatus);
      // },
      // color: widget.color ?? const Color.fromARGB(255, 221, 248, 255),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: null,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          //  mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              widget.isLikeButton!
                  ? widget.isActive
                      ? APPICONS.likedsvg
                      : APPICONS.likesvg
                  : widget.isActive
                      ? APPICONS.dislikedsvg
                      : APPICONS.dislikesvg,
              // color: isLiked ? primaryColor : lightGrey,
              color: const Color(0xFf1B2870),
            ),
            UIHelper.horizontalSpaceSm,
            Text(widget.usercounts.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
