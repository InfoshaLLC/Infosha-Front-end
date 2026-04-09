import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/text_styles.dart';

class CustomText extends StatelessWidget {
  String text;
  var color;
  double? fontSize;
  FontWeight? weight;
  var height;
  var isHeading;
  var textaligh;
  CustomText(
      {this.color,
      this.fontSize,
      this.height,
      required this.text,
      this.weight,
      this.textaligh,
      this.isHeading});

  @override
  Widget build(BuildContext context) {
    return isHeading == null
        ? Text(
            text.tr,
            textAlign: textaligh,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textStyleWorkSense(
                color: color ?? primaryColor,
                fontSize: fontSize ?? 14.0,
                weight: weight ?? FontWeight.normal,
                height: height ?? 0),
          )
        : Text(
            text.tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textStyleWorkSense(
              color: color ?? Colors.black,
              fontSize: fontSize ?? 22.0,
              weight: weight ?? fontWeightSemiBold,
            ),
          );
  }
}
