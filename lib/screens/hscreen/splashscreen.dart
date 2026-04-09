import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/authentication/login_screen.dart';
import 'package:infosha/screens/Onboradscreens/terms_condition.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  late UserViewModel provider;
  bool isOnbordingCompleted = false;

  getSharedPref() async {
    var prefs = await SharedPreferences.getInstance();
    isOnbordingCompleted = prefs.getBool("onbording") ?? false;
  }

  @override
  void initState() {
    super.initState();
    getSharedPref();
    Future.microtask(() => context.read<UserViewModel>().loadSharedPref());
    provider = Provider.of<UserViewModel>(context, listen: false);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (isOnbordingCompleted) {
        if (provider.token != "null" && provider.token != "") {
          Get.offAll(() => const HomeScreen());
          /* if (provider.simCards!.isEmpty) {
            Get.offAll(() => const HomeScreen());
          } else {
            Get.offAll(() => const HomeScreen());
            /* if (provider.simCards!.any((element) => element.number!
                .substring(element.number!.length - 10)
                .contains(
                    provider.number.substring(provider.number.length - 10)))) {
              Get.offAll(() => const HomeScreen());
            } else {
              Get.offAll(() => const HomeScreen());
              // Get.offAll(() => const ChangeNumberDetected());
            } */
          } */
        } else {
          Get.offAll(() => const LoginScreen());
        }
      } else {
        Get.offAll(() => TermsCondition());
        // Get.offAll(() => const onBoardingScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Information About Everyone'.tr,
            style: textStyleInter(
              color: whiteColor,
              fontSize: 18.0,
            ),
          ),
          UIHelper.verticalSpaceMd,
        ],
      ),
      backgroundColor: primaryColor,
      body: Consumer<UserViewModel>(builder: (context, provider, child) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage('images/bg3.png'),
                width: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SvgPicture.asset(APPICONS.infoWhitelogosvg),
              )
            ],
          ),
        );
      }),
    );
  }
}
