import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/screens/subscription/component/subscription_screen.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/widgets/rewarded_ads_widget.dart';

class CommonDialogButton extends StatefulWidget {
  String title, buttonTitleNo, buttonTitleYes;
  void Function()? onPressedNo;
  void Function()? onPressedYes;
  CommonDialogButton({
    required this.title,
    required this.buttonTitleNo,
    required this.buttonTitleYes,
    this.onPressedNo,
    this.onPressedYes,
  });

  @override
  State<CommonDialogButton> createState() => _CommonDialogButtonState();
}

class _CommonDialogButtonState extends State<CommonDialogButton> {
  bool isLoading = false;

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
              widget.title,
              style: const TextStyle(color: Color(0xFf46464F), fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: Get.height * 0.060,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Get.close(1);
                        Get.back();
                      },
                      child: Text(widget.buttonTitleNo,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500))),
                ),
                SizedBox(
                  height: Get.height * 0.060,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (isLoading == false) {
                        setState(() {
                          isLoading = true;
                        });
                        RewardedScreen().loadAd(true);
                      }
                    },
                    child: isLoading == true
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 7),
                              child: CircularProgressIndicator(
                                color: baseColor,
                              ),
                            ),
                          )
                        : Text(
                            widget.buttonTitleYes,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
