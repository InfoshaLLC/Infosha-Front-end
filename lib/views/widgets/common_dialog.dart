import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/screens/subscription/component/subscription_screen.dart';
import 'package:infosha/views/colors.dart';

class CommonDialog extends StatelessWidget {
  String title, buttonTitle;
  void Function()? onPressed;
  CommonDialog({
    required this.title,
    required this.buttonTitle,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      contentPadding: EdgeInsets.zero,
      backgroundColor: const Color(0xFfAAEDFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFfAAEDFF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(color: Color(0xFf46464F), fontSize: 16),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: Get.width,
              height: Get.height * 0.060,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                    ),
                  ),
                  onPressed: onPressed ??
                      () {
                        Get.close(1);
                        Get.to(() => SubscriptionScreen(isNewUser: false));
                      },
                  child: Text(buttonTitle,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500))),
            )
          ],
        ),
      ),
    );
  }
}
