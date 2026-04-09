import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';

class FullScreenImage extends StatefulWidget {
  String image, name;
  bool? isBase64, showDefault;
  Uint8List? base64Data;
  FullScreenImage(
      {required this.image,
      required this.name,
      this.isBase64,
      this.showDefault,
      this.base64Data});

  @override
  State<FullScreenImage> createState() => _FullScreenimageState();
}

class _FullScreenimageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          color: Colors.black,
          child: Stack(
            children: [
              Align(
                child: widget.showDefault != null && widget.showDefault == true
                    ? Image.asset('images/aysha.png')
                    : widget.isBase64 != null && widget.isBase64 == true
                        ? Image.memory(widget.base64Data!,
                            width: Get.width,
                            height: Get.height,
                            fit: BoxFit.fitWidth)
                        : widget.image.isEmpty
                            ? CircleAvatar(
                                radius: Get.height * 0.1,
                                child: CustomText(
                                  text: UIHelper.getShortName(
                                      string: widget.name, limitTo: 2),
                                  fontSize: 40.0,
                                  color: Colors.black,
                                  weight: fontWeightMedium,
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: widget.image,
                                width: Get.width,
                                height: Get.height,
                                progressIndicatorBuilder:
                                    (context, url, progress) => const Center(
                                  child: CircularProgressIndicator(
                                      color: baseColor),
                                ),
                                errorWidget: (context, url, error) {
                                  return CircleAvatar(
                                    radius: Get.height * 0.1,
                                    child: CustomText(
                                      text: UIHelper.getShortName(
                                          string: widget.name, limitTo: 2),
                                      fontSize: 40.0,
                                      color: Colors.black,
                                      weight: fontWeightMedium,
                                    ),
                                  );
                                },
                              ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle),
                    child: const Center(
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
