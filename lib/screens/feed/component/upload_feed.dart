import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:infosha/config/const.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:video_player/video_player.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/screens/feed/component/feed_preview.dart';

class UploadFeed extends StatefulWidget {
  const UploadFeed({super.key});

  @override
  State<UploadFeed> createState() => _UploadFeedState();
}

class _UploadFeedState extends State<UploadFeed> {
  XFile? pickedFile;
  final _picker = ImagePicker();
  bool isVideo = false;
  TextEditingController descController = TextEditingController();
  VideoPlayerController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1EBEC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0BA7C1),
        title: Text(
          "Upload Post".tr,
          style: textStyleWorkSense(fontSize: 22),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
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
              child: Container(
                margin: const EdgeInsets.all(15),
                height: Get.height * 0.55,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      DottedBorder(
                        // borderType: BorderType.RRect,
                        // radius: const Radius.circular(10),
                        options: RoundedRectDottedBorderOptions(
                          radius: const Radius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: SizedBox(
                            height: Get.height * 0.17,
                            width: Get.width,
                            child: pickedFile != null
                                ? isVideo
                                    ? controller!.value.isInitialized == false
                                        ? const Center(
                                            child: CircularProgressIndicator(color: baseColor),
                                          )
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
                                                LayoutBuilder(
                                                  builder: (context, constraints) {
                                                    return SizedBox.expand(
                                                      child: FittedBox(
                                                        fit: BoxFit.fill,
                                                        child: SizedBox(
                                                          width: constraints.maxWidth * controller!.value.aspectRatio,
                                                          height: controller!.value.aspectRatio,
                                                          child: VideoPlayer(
                                                            controller!,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                if (controller!.value.isPlaying == false) ...[
                                                  const Align(
                                                      child: Icon(
                                                    Icons.play_circle_outline_rounded,
                                                    color: Colors.white,
                                                    size: 50,
                                                  ))
                                                ],
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          pickedFile = null;
                                                        });
                                                      },
                                                      icon: Container(
                                                          decoration: const BoxDecoration(color: baseColor, shape: BoxShape.circle),
                                                          child: const Icon(
                                                            Icons.close_outlined,
                                                            color: Colors.white,
                                                          ))),
                                                )
                                              ],
                                            ),
                                          )
                                    : Stack(
                                        children: [
                                          Image.file(
                                            File(pickedFile!.path),
                                            fit: BoxFit.fitWidth,
                                            width: Get.width,
                                            height: Get.height * 0.17,
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    pickedFile = null;
                                                  });
                                                },
                                                icon: Container(
                                                    decoration: const BoxDecoration(color: baseColor, shape: BoxShape.circle),
                                                    child: const Icon(
                                                      Icons.close_outlined,
                                                      color: Colors.white,
                                                    ))),
                                          )
                                        ],
                                      )
                                : InkWell(
                                    onTap: () async {
                                      showAlertForImageSelection(context);
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          APPICONS.uploadIcon,
                                          height: Get.height * 0.07,
                                        ),
                                        SizedBox(height: Get.height * 0.01),
                                        Text(
                                          "Upload Image / video".tr,
                                          style: GoogleFonts.workSans(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.025),
                      TextFormField(
                        controller: descController,
                        maxLines: 9,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          hintText: 'Description'.tr,
                          labelText: 'Description'.tr,
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(),
                          ),
                          hintStyle: textStyleWorkSense(fontSize: 14.0, color: const Color(0xFF46464F), weight: fontWeightMedium),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CustomButton(
          () {
            if (pickedFile == null && descController.text.trim().isEmpty) {
              UIHelper.showBottomFlash(context, title: "Fail", message: "Please select Image/Video or enter description".tr, isError: false);
            } else {
              Get.to(() => FeedPreview(file: pickedFile, description: descController.text.trim(), isVideo: isVideo));
            }
          },
          text: "Next".tr,
          textcolor: whiteColor,
          color: primaryColor,
        ),
      ),
    );
  }

  showAlertForImageSelection(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Photo".tr),
      onPressed: () {
        Navigator.pop(context);
        _selectImage(false);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Video".tr),
      onPressed: () {
        Navigator.pop(context);
        _selectImage(true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Media".tr),
      content: Text("Choose a Photo or Video".tr),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _selectImage(bool isFromCamera) async {
    if (isFromCamera) {
      var temp = await _picker.pickVideo(source: ImageSource.gallery);
      if (temp != null) {
        int sizeInBytes = await temp.length();
        double sizeInMB = sizeInBytes / (1024 * 1024);
        if (sizeInMB > 3) {
          UIHelper.showMySnak(title: "Media", message: 'Maximum allowed size is 3 MB', isError: true);
        } else {
          pickedFile = temp;
          isVideo = true;
          initializaVideo();
        }
      }
    } else {
      var temp = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 40);
      if (temp != null) {
        int sizeInBytes = await temp.length();
        double sizeInMB = sizeInBytes / (1024 * 1024);
        if (sizeInMB > 3) {
          UIHelper.showMySnak(title: "Media", message: 'Maximum allowed size is 3 MB', isError: true);
        } else {
          pickedFile = temp;
          isVideo = false;
        }
      }
    }
    setState(() {});
  }

  Future<void> initializaVideo() async {
    controller = VideoPlayerController.file(File(pickedFile!.path))
      ..initialize().then((value) {
        setState(() {});
      })
      ..setLooping(true);
  }
}
