import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infosha/config/const.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _privacyState();
}

class _privacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            size: 24,
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Privacy Policy'.tr,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
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
    );
  }
}
