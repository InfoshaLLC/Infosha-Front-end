import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class settingsLocation extends StatefulWidget {
  const settingsLocation({super.key});

  @override
  State<settingsLocation> createState() => _settingsLocationState();
}

class _settingsLocationState extends State<settingsLocation> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserViewModel>(builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 64),
            Row(children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                iconSize: 25,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CustomText(
                text: "Language",
                fontSize: 18.0.sp,
                color: Colors.black,
                weight: fontWeightMedium,
              ),
            ]),
            const SizedBox(height: 40),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              CustomText(
                text: 'English (EN)'.tr,
                fontSize: 14.0,
                weight: fontWeightRegular,
              ),
              IconButton(
                icon: Icon(
                  provider.selectedLanguage == "English"
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: primaryColor,
                ),
                iconSize: 25,
                color: Colors.grey,
                onPressed: () {
                  provider.selectedLanguage = "English";
                  Get.updateLocale(const Locale('en', 'US'));
                  provider.setLanguage();
                },
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              CustomText(
                text: 'Arabic (AR)'.tr,
                fontSize: 14.0,
                weight: fontWeightRegular,
              ),
              IconButton(
                icon: Icon(
                  provider.selectedLanguage == "Arabic"
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: primaryColor,
                ),
                iconSize: 25,
                color: Colors.grey,
                onPressed: () {
                  provider.selectedLanguage = "Arabic";
                  Get.updateLocale(const Locale('ar', 'SA'));
                  provider.setLanguage();
                },
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              CustomText(
                text: 'French (FR)'.tr,
                fontSize: 14.0,
                weight: fontWeightRegular,
              ),
              IconButton(
                icon: Icon(
                  provider.selectedLanguage == "French"
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: primaryColor,
                ),
                iconSize: 25,
                color: Colors.grey,
                onPressed: () {
                  provider.selectedLanguage = "French";
                  Get.updateLocale(const Locale('fr'));
                  provider.setLanguage();
                },
              ),
            ]),
          ]),
        );
      }),
    );
  }
}
