import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:infosha/views/colors.dart';

class MyCustomAppBar extends StatelessWidget {
  var leading;
  var onBack;
  MyCustomAppBar({Key? key, this.leading, this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = Get.width;

    return Container(
        width: Get.width,
        //  height: 130,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         fit: BoxFit.cover, image: AssetImage("images/loginappbar.jpg"))),
        child: Container(
          color: Color(0xff1F1F1F),
          height: 150,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  "images/appbaricon.png",
                  color: whiteColor,
                  //  height: 120,
                  fit: BoxFit.cover,
                  width: Get.width * 0.5,
                ),
              ),
              AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: leading != null
                      ? leading
                      : onBack != null
                          ? IconButton(
                              onPressed: onBack,
                              icon: FaIcon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ))
                          : Container(
                              width: 0,
                              height: 0,
                            )),
            ],
          ),
        ));
  }
}
