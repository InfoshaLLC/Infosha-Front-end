import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infosha/config/const.dart';
import 'package:infosha/screens/feed/controller/feed_model.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class FeedPreview extends StatefulWidget {
  XFile? file;
  String? description;
  bool? isVideo;
  FeedPreview({super.key, this.file, this.description, this.isVideo});

  @override
  State<FeedPreview> createState() => _FeedPreviewState();
}

class _FeedPreviewState extends State<FeedPreview> {
  VideoPlayerController? controller;
  late FeedModel provider;

  @override
  void initState() {
    provider = Provider.of<FeedModel>(context, listen: false);

    if (widget.file != null && widget.isVideo!) {
      initializaVideo();
    }
    super.initState();
  }

  Future<void> initializaVideo() async {
    controller = VideoPlayerController.file(File(widget.file!.path))
      ..initialize().then((value) {
        setState(() {});
      })
      ..setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0BA7C1),
        title: Text(
          "Preview".tr,
          style: textStyleWorkSense(fontSize: 22),
        ),
      ),
      body: Consumer<FeedModel>(builder: (context, provider, child) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                APPICONS.feedBackground,
                height: Get.height * 0.4,
                width: Get.width,
                fit: BoxFit.fill,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    // height: Get.height,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headingContainer(),
                          if (widget.file != null) ...[
                            widget.isVideo!
                                ? videoPostContainer()
                                : imagePostContainer()
                          ],
                          if (widget.description != null) ...[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                widget.description ?? "",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.workSans(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }),
      bottomNavigationBar:
          Consumer<FeedModel>(builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomButton(
            () {
              if (provider.isUploading == false) {
                provider.addPost(widget.description, widget.file);
              }
            },
            text: provider.isUploading ? "loading" : "Post".tr,
            textcolor: whiteColor,
            color: primaryColor,
          ),
        );
      }),
    );
  }

  videoPostContainer() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      height: Get.height * 0.44,
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: controller!.value.isInitialized == false
            ? const CircularProgressIndicator(color: baseColor)
            : InkWell(
                onTap: () {
                  setState(() {
                    if (controller!.value.isPlaying) {
                      controller!.pause();
                    } else {
                      controller!.play();
                    }
                  });
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox.expand(
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: SizedBox(
                                width: constraints.maxWidth *
                                    controller!.value.aspectRatio,
                                height: controller!.value.aspectRatio,
                                child: VideoPlayer(
                                  controller!,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (controller!.value.isPlaying == false) ...[
                      const Align(
                          child: Icon(
                        Icons.play_circle_outline_rounded,
                        color: Colors.white,
                        size: 50,
                      ))
                    ]
                  ],
                ),
              ),
      ),
    );
  }

  imagePostContainer() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      height: Get.height * 0.44,
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.file(
          File(widget.file!.path),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  headingContainer() {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 10),
      leading: SizedBox(
        width: Get.width * 0.15,
        height: Get.height * 0.0702,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Params.Image == "null"
              ? Image.asset(APPICONS.feedImage)
              : CachedNetworkImage(
                  imageUrl: Params.Image,
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) =>
                      Image.asset(APPICONS.feedImage),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      color: baseColor,
                    ),
                  ),
                ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomText(
            text: Params.Name,
            color: const Color(0xFF46464F),
            weight: fontWeightSemiBold,
            fontSize: 14,
          ),
          // UIHelper.horizontalSpaceSm,
          /* Image(
            height: 20,
            image: AssetImage(
              APPICONS.lordicon,
            ),
          ), */
        ],
      ),
      subtitle: CustomText(
        text: Params.Number,
        color: const Color(0xFFABAAB4),
        weight: fontWeightSemiBold,
        fontSize: 14,
      ),
    );
  }
}
