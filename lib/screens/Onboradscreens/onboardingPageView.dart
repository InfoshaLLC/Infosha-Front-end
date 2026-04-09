import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/Onboradscreens/onBoardingView.dart';
import 'package:infosha/screens/authentication/login_screen.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
// import 'package:mobile_number/mobile_number.dart';
// import 'package:mobile_number/sim_card.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';

class onBoardingScreen extends StatefulWidget {
  const onBoardingScreen({super.key});

  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  final pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  List<Widget> list = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: const Color(0xffD9D9D9),
      child: Stack(children: [
        SizedBox(
          height: Get.height,
          width: Get.width,
          child: PageView(
            controller: pageController,
            onPageChanged: (i) {
              setState(() {
                currentIndex = i;
              });
            },
            children: [
              OnBoardingData(
                index: 0,
                imagee: "images/onboarding1.png",
                title: "Ride The Social Wave",
                subtitle:
                    "Welcome to Infosha, where social possibilities are endless. Ride the wave of connection.",
                buttonText: "Next".tr,
                //   controller: pageController,
                onTapNextButton: () {
                  pageController.nextPage(
                      duration: const Duration(milliseconds: 2),
                      curve: Curves.linear);
                },
                onTapSkipButton: () {
                  pageController.jumpToPage(2);
                  // Get.off(NumberScreen());
                  // Get.off(SignUpScreen());
                },
              ),
              OnBoardingData(
                index: 1,
                buttonText: "Next",
                imagee: "images/onboarding2.png",
                title: "Your Network Oasis",
                subtitle:
                    "Find people, share your thoughts, and\n create memories together.",
                onTapNextButton: () {
                  pageController.nextPage(
                      duration: const Duration(milliseconds: 2),
                      curve: Curves.linear);
                },
                onTapSkipButton: () {
                  pageController.jumpToPage(2);
                  // Get.off(NumberScreen());
                  // Get.off(SignUpScreen());
                },
                //    controller: pageController,
              ),
              OnBoardingData(
                index: 2,
                imagee: "images/onboarding3.png",
                buttonText: "Get Started",
                title: "Unite Your World",
                subtitle:
                    "Connect, comment, rate, discover, and\nshare with people who matter.",
                // controller: pageController,
                onTapNextButton: () {
                  pageController.nextPage(
                      duration: const Duration(milliseconds: 2),
                      curve: Curves.linear);
                  // Get.off(NumberScreen());
                  // Get.off(SignUpScreen());
                },
                onTapSkipButton: () {
                  pageController.jumpToPage(2);

                  // Get.off(NumberScreen());
                  // Get.off(SignUpScreen());
                },
              )
            ],
          ),
        ),
        Positioned(
          // top: 0,
          bottom: 60,
          left: 20,
          right: 20,
          child: Container(
            height: 40,
            width: Get.width * 0.2,
            color: Colors.transparent,
            child: Consumer<UserViewModel>(builder: (context, vmodel, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      for (int i = 0; i < 3; i++)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: i == currentIndex
                              ? Container(
                                  height: 10,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B2870),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )
                              // SvgPicture.asset(
                              //     "images/dotgr.svg",
                              //     height: 22,
                              //     width: 22,
                              //   )
                              : Container(
                                  height: 10,
                                  width: 15,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF808080),
                                      shape: BoxShape.circle),
                                ),
                        ),
                    ],
                  ),
                  MaterialButton(
                    onPressed: () async {
                      if (currentIndex != 2) {
                        setState(() {
                          currentIndex++;
                        });
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 2),
                            curve: Curves.linear);
                      } else {
                        await Provider.of<UserViewModel>(context, listen: false)
                            .askPermissionscontact(context);
                        // ignore: use_build_context_synchronously
                        await Provider.of<UserViewModel>(context, listen: false)
                            .askPermissionsPhone(context);

                        // ignore: use_build_context_synchronously
                        await Provider.of<UserViewModel>(context, listen: false)
                            .askPermissionsLocation(context);

                        PermissionStatus permissionStatus =
                            await Permission.contacts.status;
                        if (permissionStatus.isGranted) {
                          // ignore: use_build_context_synchronously
                          await Provider.of<UserViewModel>(context,
                                  listen: false)
                              .completeOnbording(true);
                          Get.off(() => const LoginScreen());
                        } else if (permissionStatus.isDenied) {
                          Permission.contacts.request();
                        } else {
                          openAppSettings();
                        }
                      }
                    },
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: whiteColor),
                        borderRadius: BorderRadius.circular(25)),
                    color: primaryColor,
                    child: CustomText(
                      text: currentIndex != 2 ? "Next".tr : "Get Started".tr,
                      color: whiteColor,
                    ),
                  )
                ],
              );
            }),
          ),
        ),
        // Positioned(
        //   top: 50,
        //   right: 30,
        //   child: Container(
        //     child: Text(
        //       "Skip",
        //       style: TextStyle(
        //         fontSize: 17,
        //         fontFamily: 'workSans',
        //         fontWeight: fontWeightBold,
        //         decoration: TextDecoration.none,
        //         color: Color(0xFF1B2870),
        //       ),
        //     ),
        //   ),
        // ),
      ]),
    );
  }
}
