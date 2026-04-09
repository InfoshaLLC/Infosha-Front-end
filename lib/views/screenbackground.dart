import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/theme_controller.dart';
import 'colors.dart';



class ScreenBackground extends StatelessWidget {
  Widget child;
  double? height;
  double? width;
  ScreenBackground({Key? key, required this.child, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = screenSize(context);

    Get.put(ThemeController());
    return GetBuilder<ThemeController>(builder: (builder) {
      return Container(
          height: height ?? size.height,
          width: width ?? size.width,
          child: child,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(!builder.isDarkMode
                      ? "images/bgdark.png"
                      // : "images/bglight.png"
                      : "images/bglight.png"))));
    });
  }
}
