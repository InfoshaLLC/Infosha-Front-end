import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class MenuPopupClass extends StatelessWidget {
  const MenuPopupClass({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        constraints: const BoxConstraints(maxHeight: 150, maxWidth: 190),
        offset: const Offset(0, 6),
        position: PopupMenuPosition.under,
        iconSize: 22,
        icon: const Icon(
          Icons.more_vert,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                value: 0,
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      // shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      title: Column(
                        children: [
                          Center(
                            child: Text(
                              'Are you sure you want to block?'.tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ),
                        ],
                      ),

                      content: Text(
                        'In order to delete this comment, you have to purchase status subscriptions'
                            .tr,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),

                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: Text(
                            'Cancel'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xff1B2870),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: Text(
                            'Continue'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xff1B2870),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage("images/delete.png"),
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text("Block User".tr),
                  ],
                )),
            PopupMenuItem<int>(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                value: 1,
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      //shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      title: Column(
                        children: [
                          Center(
                            child: Text(
                              'Are you sure you want to report?'.tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ),
                        ],
                      ),
                      //Ye wala code delete ker lena GOD screen ke liye is text ki zaroorat nahi
                      //(
                      content: Text(
                        'In order to report this comment, you have to purchase status subscriptions'
                            .tr,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                      //)
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: Text(
                            'Cancel'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xff1B2870),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: Text(
                            'Report'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xff1B2870),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Image.asset(
                      'images/report.png',
                      height: 20,
                      width: 17,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text("Report User".tr),
                  ],
                )),
          ];
        },
        onSelected: (value) {
          if (value == 0) {
          } else if (value == 1) {
          } else if (value == 2) {}
        });
  }
}
