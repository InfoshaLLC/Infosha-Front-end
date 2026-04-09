import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/config/const.dart';
import 'package:infosha/screens/authentication/login_screen.dart';
import 'package:infosha/screens/subscription/component/subscription_screen.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:provider/provider.dart';

class TermsAndConditions extends StatefulWidget {
  var payload;
  TermsAndConditions({super.key, required this.payload});

  @override
  State<TermsAndConditions> createState() => _termsandConditionsState();
}

class _termsandConditionsState extends State<TermsAndConditions> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: BottomSheet(
          onClosing: () {},
          enableDrag: false,
          elevation: 30,
          backgroundColor: Colors.white,
          builder: (context) {
            return Consumer<UserViewModel>(builder: (context, provider, child) {
              return Container(
                height: Get.height * 0.14,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Checkbox(
                              value: isChecked,
                              onChanged: (val) {
                                if (provider.isAuthenticating == false) {
                                  setState(() {
                                    isChecked = val!;
                                  });
                                }
                              },
                              checkColor: Colors.white,
                              activeColor: const Color(0xff1B2870),
                              hoverColor: Colors.green,
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                            ),
                          ),
                          Text('${"I agree with the".tr} '),
                          Text(
                            'Privacy Policy'.tr,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                  Colors.white,
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side:
                                        const BorderSide(color: Colors.black54),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (provider.isAuthenticating == false) {
                                  Get.offAll(() => const LoginScreen());
                                }
                              },
                              child: Text(
                                'Decline'.tr,
                                style: const TextStyle(
                                  color: Color(0xff1B2870),
                                ),
                              ),
                            ),
                          ),
                          UIHelper.horizontalSpaceMd,
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                  Color(0xff1B2870),
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (isChecked == false) {
                                  UIHelper.showMySnak(
                                      title: AppName,
                                      message: "Please agree Privacy Policy".tr,
                                      isError: true);
                                } else {
                                  UserViewModel provider =
                                      Provider.of<UserViewModel>(context,
                                          listen: false);

                                  if (provider.isAuthenticating == false) {
                                    provider
                                        .registerUser(widget.payload)
                                        .then((value) {
                                      /* if (value == true) {
                                        Get.offAll(() => SubscriptionScreen(
                                            isNewUser: true));
                                      } */
                                    });
                                  }
                                }
                              },
                              child: provider.isAuthenticating
                                  ? SizedBox(
                                      height: Get.height * 0.03,
                                      width: Get.width * 0.062,
                                      child: const CircularProgressIndicator(
                                        color: whiteColor,
                                      ),
                                    )
                                  : Text('Accept'.tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
          },
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          /* leading: Consumer<UserViewModel>(builder: (context, provider, child) {
            return IconButton(
                onPressed: () {
                  if (provider.isAuthenticating == false) {
                    Get.back();
                  }
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ));
          }), */
          title: CustomText(
            text: 'Terms and Conditions'.tr,
            isHeading: true,
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            // height: MediaQuery.of(context).size.height,
            width: Get.width,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    termscondition,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
