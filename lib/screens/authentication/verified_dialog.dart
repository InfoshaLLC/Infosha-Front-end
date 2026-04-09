import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/screens/authentication/signupContinued.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VerifiedDialog extends StatelessWidget {
  const VerifiedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //                        shadowColor: Colors.transparent,
      elevation: 0,

      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(25),
      ),
     
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage('images/verified.png'),
          ),
          SizedBox(
            height: 20,
          ),
          CustomText(
            text: 'Verified Successfully',
            isHeading: true,
          ),
        ],
      ),
     
      content: CustomText(
        text: 'Your phone number is verified successfully.',
        fontSize: 16.0.sp,
        color: hintColor,
      ),

      actions: <Widget>[
        TextButton(
          onPressed: () {
            Get.back();
            Get.to(signupContinued());
          },
          child: CustomText(
            text: "Continue",
            color: primaryColor,
            fontSize: 16.sp,
            weight: fontWeightMedium,
          ),
        ),
      ],
    );
  }
}
