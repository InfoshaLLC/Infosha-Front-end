import 'colors.dart';
import 'text_styles.dart';
import 'custom_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
// ignore_for_file: constant_identifier_names

/// Contains useful consts to reduce boilerplate and duplicate code
class UIHelper {
  // Vertical spacing constants. Adjust to your liking.
  static const double _VerticalSpaceSm = 10.0;
  static const double _VerticalSpaceSm1 = 5.0;

  static const double _VerticalSpaceMd = 20.0;
  static const double _VerticalSpace30 = 30.0;
  static const double _VerticalSpaceL = 42.0;
  static const double _VerticalSpaceXL = 92.0;

  // Vertical spacing constants. Adjust to your liking.
  static const double _HorizontalSpaceSm = 10.0;
  static const double _HorizontalSpaceMd = 20.0;
  static const double _HorizontalSpaceL = 60.0;

  static const Widget verticalSpaceSm = SizedBox(height: _VerticalSpaceSm);
  static const Widget verticalSpaceSm1 = SizedBox(height: _VerticalSpaceSm1);

  static const Widget verticalSpaceMd = SizedBox(height: _VerticalSpaceMd);
  static const Widget verticalSpace30 = SizedBox(height: _VerticalSpace30);
  static const Widget verticalSpaceL = SizedBox(height: _VerticalSpaceL);
  static const Widget verticalSpaceXL = SizedBox(height: _VerticalSpaceXL);

  static const Widget horizontalSpaceSm = SizedBox(width: _HorizontalSpaceSm);
  static const Widget horizontalSpace3m = SizedBox(width: 3);
  static const Widget horizontalSpace5m = SizedBox(width: 5);

  static const Widget horizontalSpaceMd = SizedBox(width: _HorizontalSpaceMd);
  static const Widget horizontalSpaceL = SizedBox(width: _HorizontalSpaceL);
  // static void showMySnak({required String title, required String message, bool? isError}) {
  //   if (isError!) {
  //     Get.snackbar(title.tr, message.tr, backgroundColor: Colors.red, colorText: Colors.white);
  //   } else {
  //     Get.snackbar(title.tr, message.tr, backgroundColor: Colors.green, colorText: Colors.white);
  //   }
  // }

  static void showMySnak({
    required String title,
    required String message,
    bool? isError,
  }) {
    final context = Get.context;
    if (context == null) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$title: $message",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: isError == true ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  static FlashController? ccontroller;

  static String getCurrencyFormate(text) {
    final oCcy = NumberFormat("#,##0.00", "en_US");
    return oCcy.format(int.parse(text));
  }

  static String formatNumberText(int number) {
    if (number >= 1000000) {
      double result = number / 1000000.0;
      return '${result.toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      double result = number / 1000.0;
      return '${result.toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  static String formatPhoneNumber(String phoneNumber) {
    PhoneNumber number = PhoneNumber.fromCompleteNumber(completeNumber: phoneNumber);
    return number.countryCode;
  }

  static void showBottomFlash(
    context, {
    required title,
    required String message,
    required isError,
    bool persistent = true,
    EdgeInsets margin = EdgeInsets.zero,
  }) {
    showFlash(
      context: context,
      persistent: persistent,
      duration: const Duration(seconds: 5),
      builder: (_, controller) {
        ccontroller = controller;
        return Flash(
          controller: controller,

          // margin: EdgeInsets.all(15),
          // insetAnimationDuration: Duration(seconds: 3),

          // behavior: FlashBehavior.floating,
          position: FlashPosition.top,

          // borderRadius: BorderRadius.circular(8.0),
          // //  borderColor: Color(0xffD9FF9A),
          // backgroundColor: whiteColor,
          // boxShadows: kElevationToShadow[8],
          // backgroundGradient: RadialGradient(
          //   colors: [Color(0xffD9FF9A), Color(0xffD9FF9A), Color(0xffD9FF9A)],
          //   center: Alignment.center,
          //   tileMode: TileMode.decal,
          //   radius: 3,
          // ),

          forwardAnimationCurve: Curves.easeInCirc,
          reverseAnimationCurve: Curves.bounceIn,
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.black),
            child: FlashBar(
              title: Text(
                message.tr,
                style: textStyleLatoRegular(color: blackbutton, fontSize: 14.0),
              ),
              content: SizedBox(),

              indicatorColor: isError ? Colors.red : secondaryColor,
              //    icon: Icon(Icons.info_outline),
              primaryAction: TextButton(
                onPressed: () => controller.dismiss(),
                child: Icon(
                  Icons.close,
                  color: blackbutton,
                ),
              ),
              controller: controller,
            ),
          ),
        );
      },
    ).then((_) {
      if (_ != null) {
        //  _showMessage(_.toString());
      }
    });
  }

  static showDialogOk(context, {required String title, required String message, onOk, onConfirm, onOkAction}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              //  width: Get.width * 0.3,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // gradient: LinearGradient(
                //   begin: Alignment(-0.71, 0.94),
                //   end: Alignment(0.8, -0.82),
                //   colors: [
                //     const Color(0xFFFFFFFF),
                //     const Color(0xFF000000),
                //     const Color(0xFFFFFFFF),
                //   ],
                //   stops: [0.0, 0.03, 1.0],
                // ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title.tr,
                    style: textStyleSegeouibold(fontSize: 22.0, color: Colors.black),
                  ),
                  UIHelper.verticalSpaceSm,
                  Text(
                    message.tr,
                    textAlign: TextAlign.center,
                    style: textStyleSegeoui(fontSize: 16.0, color: Colors.black),
                  ),
                  UIHelper.verticalSpaceMd,
                  onOk != null
                      ? SizedBox(
                          width: 150,
                          child: CustomButton(
                            onOk ??
                                () {
                                  Get.back();
                                },
                            text: "Ok",
                            textcolor: Colors.white,
                            buttonBorderColor: Colors.transparent,
                            circleRadius: 25.0,
                            color: secondaryColor,
                          ),
                        )
                      : Container(),
                  onConfirm != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              child: CustomButton(
                                () {
                                  Get.back();
                                },
                                text: "Cancel",
                                textcolor: Colors.white,
                                buttonBorderColor: Colors.transparent,
                                circleRadius: 25.0,
                                color: grey600,
                              ),
                            ),
                            UIHelper.horizontalSpaceMd,
                            SizedBox(
                              width: 120,
                              child: CustomButton(
                                onConfirm,
                                text: "Confirm",
                                textcolor: Colors.white,
                                buttonBorderColor: Colors.transparent,
                                circleRadius: 25.0,
                                color: redButton,
                              ),
                            ),
                          ],
                        )
                      : Container()
                ],
              ),
            ),
          );
        });
  }

  static const mapKey = "AIzaSyDVX6dMqw5wbVC1t47hNg3xOEuseEwmA_c";

//todo modify the theme
/* static ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
    backgroundColor: Colors.grey[700],
    brightness: Brightness.dark,
  );
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.red,
    accentColor: Colors.red[400],
    backgroundColor: Colors.grey[200],
    brightness: Brightness.light,
  );*/
  static Widget WidgetCustomTextMed({required text, size, color}) {
    return Text(
      text,
      //maxLines: 2,
      style: textStyleLatoSemiBold(fontSize: size ?? 16.0, color: color ?? Colors.black),
    );
  }

  static String getShortName({required string, required limitTo}) {
    string = string.toString().trim().replaceAll(RegExp(r'\s+'), '');
    if (string == false) {
      string = 'NA';
    }

    if (string.toString().isEmpty) {
      string = 'NA';
    }

    var buffer = StringBuffer();
    var split = string.toString().trim().replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(RegExp(r'\s+'), '').split(' ');

    if (split.isNotEmpty) {
      for (var i = 0; i < (split.length > limitTo ? 1 : split.length); i++) {
        try {
          if (split[i].isNotEmpty) {
            buffer.write(split[i][0].toString().toUpperCase());
          } else {
            return 'NA';
          }
        } catch (e) {
          rethrow;
        }
      }
    } else {
      return 'NA';
    }

    return buffer.toString();
  }

  static Widget ricHText({text, text1, fsize, weight}) {
    return RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
              text: text,
              style: textStyleLMS(
                fontSize: fsize ?? 14.0,
              )),
          const WidgetSpan(child: UIHelper.horizontalSpaceSm),
          WidgetSpan(
              child: text1 != null
                  ? Text("$text1", style: textStyleLMS(fontSize: fsize ?? 18.0, color: darkGreenColor, weight: FontWeight.bold))
                  : Container())
          // WidgetSpan(
          //   child: Image.asset(image,
          //       width: 22.0, height: 22, color: Colors.black54),
          // ),
        ]));
  }

  static bool isEmailValid(email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}
