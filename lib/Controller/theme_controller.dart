import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  bool isDarkMode = true;

  void toggleDarkMode() {
    print("ppp");
    isDarkMode = !isDarkMode;
    if (isDarkMode) {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }
    update();
  }
}
