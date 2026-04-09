import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/ui_helpers.dart';

class VoteButton extends StatefulWidget {
  bool? isLikeButton;
  int usercounts;
  int likestatus;
  bool isActive;
  var oncallback;
  Color? color;

  VoteButton(
      {super.key,
      this.isLikeButton,
      this.oncallback,
      this.color,
      required this.usercounts,
      required this.likestatus,
      required this.isActive});

  @override
  State<VoteButton> createState() => _VoteButtonState();
}

class _VoteButtonState extends State<VoteButton> {
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
    return MaterialButton(
      elevation: 0,
      onPressed: () async {
        widget.oncallback(widget.likestatus);
      },
      color: widget.color ?? const Color.fromARGB(255, 221, 248, 255),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
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
