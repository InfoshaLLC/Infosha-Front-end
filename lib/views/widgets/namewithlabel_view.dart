import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class NamewithlabelView extends StatelessWidget {
  String displayName;
  var fontsize;
  var iconsize;
  var textcolor;
  bool? showIcon;
  String? iconname;
  NamewithlabelView(
      {Key? key,
      required this.displayName,
      this.fontsize,
      this.iconsize,
      this.textcolor,
      this.showIcon,
      this.iconname})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: displayName.tr,
          color: textcolor ?? whiteColor,
          fontSize: fontsize ?? 16.0.sp,
          weight: fontWeightSemiBold,
        ),
        UIHelper.horizontalSpaceSm,
        if (iconname != null) ...[
          Image(
            height: iconsize ?? 20,
            image: AssetImage(
              iconname!.contains("lord")
                  ? APPICONS.lordicon
                  : iconname!.contains("god")
                      ? APPICONS.godstatuspng
                      : APPICONS.kingstutspicpng,
            ),
          ),
          const SizedBox(width: 5),
        ],
        if (showIcon != null && showIcon == true)
          Icon(
            Icons.verified,
            color: const Color(0xFF007EFF),
            size: iconsize,
          ),
      ],
    );
  }
}
