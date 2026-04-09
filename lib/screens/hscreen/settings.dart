import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:infosha/screens/hscreen/contact_us.dart';
import 'package:infosha/screens/hscreen/privacyPolicy.dart';
import 'package:infosha/screens/hscreen/termsandservice.dart';
import 'package:infosha/screens/hscreen/settingsLocation.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          backgroundColor: Colors.transparent,
          title: CustomText(
            text: "Settings",
            fontSize: 18.0.sp,
            color: Colors.black,
            weight: fontWeightMedium,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: CustomText(
                        text: "General".tr,
                        fontSize: 18.0,
                        weight: fontWeightSemiBold,
                        color: Colors.black,
                      )),
                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListTilewidget(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const settingsLocation();
                          },
                        ),
                      );
                    },
                    text: 'Language'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 1,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: CustomText(
                        text: "Help and Support".tr,
                        fontSize: 18.0,
                        weight: fontWeightSemiBold,
                        color: Colors.black,
                      )),
                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListTilewidget(
                    onTap: () async {
                      if (Platform.isAndroid) {
                        // ANDROID ONLY overlay permission
                        if (await FlutterOverlayWindow.isPermissionGranted() == false) {
                          await FlutterOverlayWindow.requestPermission();
                        } else {
                          Get.back();
                          UIHelper.showMySnak(
                            title: "Permission",
                            message: 'Display over other apps permission is already granted',
                            isError: false,
                          );
                        }
                      } else if (Platform.isIOS) {
                        // iOS DOES NOT SUPPORT overlay windows
                        Get.back();
                        UIHelper.showMySnak(
                          title: "Unsupported",
                          message: "Overlay windows are not supported on iOS",
                          isError: true,
                        );
                      }
                    },

                    // onTap: () async {
                    //   if (await FlutterOverlayWindow.isPermissionGranted() ==
                    //       false) {
                    //     await FlutterOverlayWindow.requestPermission();
                    //   } else {
                    //     UIHelper.showMySnak(
                    //         title: "Permission",
                    //         message:
                    //             'Display over other permission is already granted',
                    //         isError: false);
                    //   }
                    // },
                    text: 'Show Call Dialog'),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Container(
                  height: 1,
                  color: Colors.grey[400],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListTilewidget(
                    onTap: () {
                      Get.to(() => const TermsAndServices());
                    },
                    text: 'Terms and Services'),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Container(
                  height: 1,
                  color: Colors.grey[400],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListTilewidget(
                  text: 'Privacy Policy',
                  onTap: () {
                    Get.to(() => const Privacy());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Container(
                  height: 1,
                  color: Colors.grey[400],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListTilewidget(text: 'About this App'),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Container(
                  height: 1,
                  color: Colors.grey[400],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListTilewidget(
                  text: 'Contact Us',
                  onTap: () {
                    Get.to(() => const ContactUs());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Container(
                  height: 1,
                  color: Colors.grey[400],
                ),
              ),
              /* Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListTilewidget(
                  text: 'Deactivate Account',
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              // shadowColor: Colors.transparent,
                              elevation: 0,
                              shape: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              title: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      'Are you sure you want to deactivate account?'
                                          .tr,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24),
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                'Once account is deactivated you will not be able to login in Infosha app'
                                    .tr,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),

                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: Text(
                                    'Cancel'.tr,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff1B2870),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'OK');
                                    Provider.of<UserViewModel>(context,
                                            listen: false)
                                        .deactiveUser();
                                  },
                                  child: Text(
                                    'Continue'.tr,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff1B2870),
                                    ),
                                  ),
                                ),
                              ],
                            ));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Container(
                  height: 1,
                  color: Colors.grey[400],
                ),
              ), */
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListTilewidget(
                  text: 'Log out',
                  onTap: () {
                    Provider.of<UserViewModel>(context, listen: false).signOut();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Container(
                  height: 1,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget ListTilewidget({required String text, void Function()? onTap}) {
  return ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
    isThreeLine: false,
    title: Text(
      text.tr,
      style: const TextStyle(color: Colors.black, fontSize: 16),
    ),
    trailing: const Icon(
      Icons.arrow_forward_ios,
      size: 16,
      color: Colors.black,
    ),
  );
}
