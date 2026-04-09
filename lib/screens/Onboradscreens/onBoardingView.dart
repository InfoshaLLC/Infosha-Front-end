import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/main.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/ui_helpers.dart';

import 'package:provider/provider.dart';

import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';

import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Controller/Viewmodel/userviewmodel.dart';
import '../../views/text_styles.dart';

// ignore: must_be_immutable
class OnBoardingData extends StatefulWidget {
  int? index;
  var title;
  var subtitle;
  var imagee;
  var onTapNextButton;
  var onTapSkipButton;
  var buttonText;
  var controller;
  OnBoardingData(
      {super.key,
      required this.index,
      this.title,
      this.subtitle,
      this.buttonText,
      this.imagee,
      this.controller,
      this.onTapSkipButton,
      this.onTapNextButton});

  @override
  State<OnBoardingData> createState() => _OnBoardingDataState();
}

class _OnBoardingDataState extends State<OnBoardingData> {
  int currentIndex = 0;
  bool isOpened = false;
  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<UserViewModel>(builder: (context, view, child) {
      return Scaffold(
        backgroundColor: whiteColor,
        body: Column(
          children: [
            Container(
              //  height: 710,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  filterQuality: FilterQuality.high,
                  image: AssetImage(widget.imagee ?? "images/onboarding1.png"),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (widget.index != 2) ...[
                          InkWell(
                            onTap: widget.onTapSkipButton,
                            child: CustomText(
                              text: "Skip",
                              fontSize: 16.sp,
                              color: primaryColor,
                              weight: fontWeightMedium,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60, left: 25),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            //  FirebaseCrashlytics.instance.crash();
                          },
                          child: CustomText(
                            text: widget.title,
                            fontSize: 22.0.px,
                            color: Colors.black,
                            weight: fontWeightSemiBold,
                          ),
                        )
                      ],
                    ),
                  ),
                  UIHelper.verticalSpaceSm,
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 25, right: 30),
                      child: SizedBox(
                        width: Get.width,
                        child: CustomText(
                          text: widget.subtitle,
                          textaligh: TextAlign.start,
                          fontSize: 16.0.px,
                          color: hintColor,
                          weight: fontWeightRegular,
                          height: 1.5,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
