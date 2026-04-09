import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetCheck extends StatefulWidget {
  const InternetCheck({super.key});

  @override
  State<InternetCheck> createState() => _InternetCheckState();
}

class _InternetCheckState extends State<InternetCheck> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Image(
                image: AssetImage('images/background1.png'),
              ),
              SizedBox(
                height: Get.height * 0.1,
              ),
              const Icon(
                Icons.wifi_off_sharp,
                size: 50,
                color: Colors.red,
              ),
              SizedBox(height: Get.height * 0.03),
              Text(
                "Connection Lost",
                style: GoogleFonts.workSans(
                    fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: Get.height * 0.01),
              SizedBox(
                width: Get.width * 0.8,
                child: Text(
                  "Internet connection required to access Infosha app",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.workSans(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CustomButton(
            () async {
              /* if (await InternetConnectionCheckerPlus().hasConnection) {
                Get.back();
              } */
            },
            text: 'Retry',
            textcolor: whiteColor,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
