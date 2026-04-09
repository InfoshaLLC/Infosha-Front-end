import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/views/text_styles.dart';

import 'colors.dart';
import 'ui_helpers.dart';

class CustomButton extends StatelessWidget {
  double? width;
  var color;
  var child;
  String text;
  var textcolor;
  var weight;
  var fsize;
  var onTap;
  var buttonBorderColor;
  var icon;
  var circleRadius;
  bool? isDisable;
  var elevation;
  CustomButton(this.onTap,
      {this.child,
      this.color,
      this.fsize,
      required this.text,
      this.textcolor,
      this.buttonBorderColor,
      this.weight,
      this.isDisable,
      this.icon,
      this.circleRadius,
      this.elevation,
      this.width});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      elevation: elevation ?? 10,
      disabledColor: inactiveColor,
      height: 50,
      highlightColor: primaryColor,
      hoverColor: primaryColor,
      focusColor: Colors.lightGreen,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: buttonBorderColor ?? primaryColor),
          borderRadius: BorderRadius.circular(circleRadius ?? 25)),
      minWidth: width ?? MediaQuery.of(context).size.width,
      //= height: 45,
      color: color ?? buttonColor,
      child: child ??
          (text == "loading"
              ? const CircularProgressIndicator(
                  color: whiteColor,
                )
              : Text(
                  text.tr,
                  textAlign: TextAlign.center,
                  style: textStyleWorkSense(
                      color: textcolor ?? backGroundColor,
                      weight: fontWeightMedium,
                      fontSize: fsize ?? 16.0),
                )),
    );
  }
}
