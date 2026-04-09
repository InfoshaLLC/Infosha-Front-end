import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/colors.dart';

class SettingIconWidget extends StatelessWidget {
  var ontap;
  var imagesvgpath;
  var width;
  SettingIconWidget(
      {super.key, required this.imagesvgpath, required this.ontap, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: width ?? 40,
        height: width ?? 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
        child: SvgPicture.asset(imagesvgpath),
      ),
    );
  }
}
