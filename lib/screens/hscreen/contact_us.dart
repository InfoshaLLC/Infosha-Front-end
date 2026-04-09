import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/config/const.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            size: 24,
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Contact Us'.tr,
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
                  contactUs,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
