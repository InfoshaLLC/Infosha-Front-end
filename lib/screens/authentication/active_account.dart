import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/screens/authentication/signupContinued.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveAccount extends StatefulWidget {
  const ActiveAccount({super.key});

  @override
  State<ActiveAccount> createState() => _ActiveAccountState();
}

class _ActiveAccountState extends State<ActiveAccount> {
  String mail = "infosha@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  Get.to(() => const signupContinued());
                },
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "Don’t have an account?".tr,
                      style: textStyleWorkSense(
                          color: Colors.black,
                          fontSize: 15.0,
                          weight: fontWeightMedium)),
                  const WidgetSpan(child: UIHelper.horizontalSpaceSm),
                  TextSpan(
                      text: "Sign Up".tr,
                      style: textStyleWorkSense(
                          color: primaryColor,
                          fontSize: 16,
                          textDecoration: TextDecoration.underline,
                          weight: fontWeightExtraBold))
                ])),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Image(
                image: AssetImage('images/background1.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIHelper.verticalSpaceMd,
                    CustomText(
                      text: "Welcome Back",
                      fontSize: 22.0.px,
                      color: Colors.black,
                      weight: fontWeightSemiBold,
                    ),
                    UIHelper.verticalSpaceMd,
                    Text(
                      "You have deactivated your account. Please contact admin to activate your account again."
                          .tr,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    UIHelper.verticalSpaceMd,
                    TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () async {
                          String uri =
                              'mailto:$mail?subject=Account Activation';
                          Uri url = Uri.parse(uri.toString());
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            print('Could not launch $url');
                          }
                        },
                        child: Text(
                          mail,
                          style: const TextStyle(fontSize: 22),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
