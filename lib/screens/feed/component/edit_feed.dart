import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:video_player/video_player.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infosha/screens/feed/controller/feed_model.dart';
import 'package:infosha/screens/feed/model/feed_list_model.dart';

class EditFeed extends StatefulWidget {
  FeedListData feedListData;
  EditFeed({required this.feedListData});

  @override
  State<EditFeed> createState() => _UploadFeedState();
}

class _UploadFeedState extends State<EditFeed> {
  XFile? pickedFile;
  final _picker = ImagePicker();
  bool isVideo = false;
  TextEditingController descController = TextEditingController();
  VideoPlayerController? controller;

  @override
  void initState() {
    if (widget.feedListData.description != null) {
      descController.text = widget.feedListData.description!;
    }

    if (widget.feedListData.fileUrl != null) {
      if (widget.feedListData.fileUrl!.contains('.mp4') ||
          widget.feedListData.fileUrl!.contains('.m4v') ||
          widget.feedListData.fileUrl!.contains('.mov')) {
        initializNetworkVideo();
      } else {
        setState(() {
          isVideo = false;
        });
      }
    }
    super.initState();
  }

  Future<void> initializaVideo() async {
    controller = VideoPlayerController.file(File(pickedFile!.path))
      ..initialize().then((value) {
        setState(() {});
      })
      ..setLooping(true);
  }

  Future<void> initializNetworkVideo() async {
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.feedListData.fileUrl!))
      ..initialize().then((value) {
        setState(() {
          isVideo = true;
        });
      })
      ..setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1EBEC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0BA7C1),
        title: Text(
          "Edit Post".tr,
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
                            child: widget.feedListData.fileUrl != null
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
                                                          showAlertForImageSelection(context);
                                                        });
                                                      },
                                                      icon: Container(
                                                          padding: const EdgeInsets.all(5),
                                                          decoration: const BoxDecoration(
                                                              color: baseColor, shape: BoxShape.circle),
                                                          child: const Icon(
                                                            Icons.edit,
                                                            color: Colors.white,
                                                            size: 18,
                                                          ))),
                                                )
                                              ],
                                            ),
                                          )
                                    : Stack(
                                        children: [
                                          pickedFile != null
                                              ? Image.file(
                                                  File(pickedFile!.path),
                                                  fit: BoxFit.fitWidth,
                                                  width: Get.width,
                                                  height: Get.height * 0.17,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: widget.feedListData.fileUrl!,
                                                  fit: BoxFit.fitWidth,
                                                  width: Get.width,
                                                  height: Get.height * 0.18,
                                                ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    showAlertForImageSelection(context);
                                                  });
                                                },
                                                icon: Container(
                                                    padding: const EdgeInsets.all(5),
                                                    decoration:
                                                        const BoxDecoration(color: baseColor, shape: BoxShape.circle),
                                                    child: const Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                      size: 18,
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
                          hintStyle: textStyleWorkSense(
                              fontSize: 14.0, color: const Color(0xFF46464F), weight: fontWeightMedium),
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
      bottomNavigationBar: Consumer<FeedModel>(builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomButton(
            () {
              if (widget.feedListData.fileUrl == null && descController.text.trim().isEmpty) {
                UIHelper.showBottomFlash(context,
                    title: "Fail", message: "Please select Image/Video or enter description".tr, isError: false);
              } else {
                Provider.of<FeedModel>(context, listen: false)
                    .editPost(descController.text.trim(), pickedFile, widget.feedListData.id.toString());
              }
            },
            text: provider.isUploading ? "loading" : "Update".tr,
            textcolor: whiteColor,
            color: primaryColor,
          ),
        );
      }),
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
        if (sizeInMB > 7) {
          UIHelper.showMySnak(title: "Media", message: 'Maximum allowed size is 5 MB', isError: true);
        } else {
          pickedFile = temp;
          isVideo = true;
          // ignore: prefer_conditional_assignment
          if (widget.feedListData.fileUrl == null) {
            widget.feedListData.fileUrl = temp.path;
          }
          initializaVideo();
        }
      }
    } else {
      var temp = await _picker.pickImage(source: ImageSource.gallery);
      if (temp != null) {
        int sizeInBytes = await temp.length();
        double sizeInMB = sizeInBytes / (1024 * 1024);
        print(sizeInMB);
        if (sizeInMB > 3) {
          UIHelper.showMySnak(title: "Media", message: 'Maximum allowed size is 3 MB', isError: true);
        } else {
          // ignore: prefer_conditional_assignment
          if (widget.feedListData.fileUrl == null) {
            widget.feedListData.fileUrl = temp.path;
          }
          pickedFile = temp;
          isVideo = false;
        }
      }
    }
    setState(() {});
  }
}
