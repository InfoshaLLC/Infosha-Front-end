import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';

// ignore: must_be_immutable
class LikeDislikeButton extends StatefulWidget {
  bool? isLikeButton;
  int usercounts;
  int likestatus;
  bool isActive;
  var oncallback;
  Color? color;
  double? elevation;
  double? fontSize;
  FontWeight? fontWeight;
  void Function()? onTap;

  LikeDislikeButton(
      {super.key,
      this.isLikeButton,
      this.oncallback,
      this.color,
      this.elevation,
      this.fontSize,
      this.fontWeight,
      required this.usercounts,
      required this.likestatus,
      required this.isActive,
      this.onTap});

  @override
  State<LikeDislikeButton> createState() => _LikeDislikeButtonState();
}

class _LikeDislikeButtonState extends State<LikeDislikeButton> {
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
    return Container(
      width: Get.width * 0.24,
      height: Get.height * 0.054,
      decoration: BoxDecoration(
        color: widget.color ?? const Color.fromARGB(255, 221, 248, 255),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 0.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
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
                  child: CustomText(
                    text: UIHelper.formatNumberText(widget.usercounts),
                    fontSize: widget.fontSize ?? 14.0,
                    color: Colors.black,
                    weight: widget.fontWeight ?? fontWeightSemiBold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
    /* return Row(
      children: [
        MaterialButton(
          elevation: widget.elevation ?? 2,
          onLongPress: () {},
          onPressed: () async {
            widget.oncallback(widget.likestatus);
          },
          color: widget.color ?? const Color.fromARGB(255, 221, 248, 255),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  widget.isLikeButton!
                      ? widget.isActive
                          ? APPICONS.likedsvg
                          : APPICONS.likesvg
                      : widget.isActive
                          ? APPICONS.dislikedsvg
                          : APPICONS.dislikesvg,
                ),
                UIHelper.horizontalSpaceSm,
                InkWell(
                  onTap: widget.onTap,
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 5, top: 4, bottom: 4, right: 10),
                    color: Colors.transparent,
                    child: CustomText(
                      text: UIHelper.formatNumberText(widget.usercounts),
                      fontSize: widget.fontSize ?? 14.0,
                      color: Colors.black,
                      weight: widget.fontWeight ?? fontWeightSemiBold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          width: Get.width * 0.24,
          height: Get.height * 0.054,
          decoration: BoxDecoration(
            color: widget.color ?? const Color.fromARGB(255, 221, 248, 255),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 0.0),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Row(
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
                      child: CustomText(
                        text: UIHelper.formatNumberText(widget.usercounts),
                        fontSize: widget.fontSize ?? 14.0,
                        color: Colors.black,
                        weight: widget.fontWeight ?? fontWeightSemiBold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ); */
  }
}
