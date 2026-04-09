import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/config/const.dart';

import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/custom_textfield.dart.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddReviewDialog extends StatefulWidget {
  String id;
  String userID;

  AddReviewDialog({super.key, required this.id, required this.userID});

  @override
  _AddReviewDialogState createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  double rating = 0;
  List<XFile>? imageFile;
  TextEditingController nickname = TextEditingController();
  TextEditingController review = TextEditingController();
  bool isAnnonymos = false;
  var picker = ImagePicker();
  final Completer<String> _completer = Completer<String>();

  @override
  void initState() {
    rating = 0;
    nickname.clear();
    review.clear();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(25),
      ),
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Consumer<UserViewModel>(builder: (context, provider, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  UIHelper.verticalSpaceMd,
                  Params.Image == "null" ||
                          Params.Image == "https://via.placeholder.com/150"
                      ? CircleAvatar(
                          backgroundImage: AssetImage(APPICONS.feedImage),
                          radius: 50.0,
                        )
                      : CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            Params.Image,
                          ),
                          radius: 50.0,
                        ),
                  UIHelper.verticalSpaceMd,
                  CustomText(
                    text: 'Rate',
                    isHeading: true,
                    color: const Color(0xFF46464F),
                  ),
                  UIHelper.verticalSpaceSm,
                  RatingBar.builder(
                    initialRating: 0,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 30,
                    allowHalfRating: true,
                    itemPadding: const EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    glowColor: lightBlue,
                    unratedColor: lightGrey,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Color(0xffFCDB67),
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        this.rating = rating;
                      });
                    },
                  ),
                ],
              ),
              UIHelper.verticalSpaceSm,
              Visibility(
                visible: false,
                child: CustomTextField(
                  required: true,
                  hint: "Nickname".tr,
                  controller: nickname,
                ),
              ),
              /* if (provider.userModel.is_subscription_active != null &&
                  provider.userModel.is_subscription_active != false) ...[ */
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width * 0.36,
                      child: RadioListTile(
                        visualDensity: const VisualDensity(horizontal: -4),
                        contentPadding: EdgeInsets.zero,
                        title: CustomText(
                          text: "Anonymous",
                        ),
                        groupValue: isAnnonymos,
                        value: true,
                        onChanged: (val) {
                          setState(() {
                            isAnnonymos = true;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(horizontal: -4),
                        isThreeLine: false,
                        title: CustomText(
                          text: "Non Anonymous",
                        ),
                        groupValue: isAnnonymos,
                        value: false,
                        onChanged: (val) {
                          setState(() {
                            isAnnonymos = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // ],
              UIHelper.verticalSpaceSm,
              /* if (isAnnonymos == false) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                      required: true,
                      hint: "Nickname".tr,
                      controller: nickname,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Enter nickname".tr;
                        }
                        return null;
                      },
                      onChanged: (p0) {
                        setState(() {});
                      },
                    ),
                  ),
                  UIHelper.verticalSpaceSm
                ], */
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  minLines: 1,
                  maxLines: 3,
                  controller: review,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintStyle: textStyleWorkSense(
                        fontSize: 14.0,
                        color: const Color(0xFF46464F),
                        weight: fontWeightMedium),
                    hintText: 'Write Comment Here...'.tr,
                    labelText: 'Write Comment Here...'.tr,
                    labelStyle: textStyleWorkSense(
                        color: const Color(0xFF46464F), fontSize: 16.0),

                    border: const OutlineInputBorder(),
                    // icon: Icon(Icons.camera_alt_outlined),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: InkWell(
                        child: imageFile != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(
                                  File(
                                    imageFile![0].path,
                                  ),
                                ),
                                radius: 15.0,
                              )
                            : const Icon(Icons.camera_alt_outlined),
                        onTap: () {
                          _getFromCamera(ImageSource.gallery);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              UIHelper.verticalSpaceMd,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Consumer<UserViewModel>(
                    builder: (context, provider, child) {
                  return CustomButton(
                    () async {
                      if (provider.isAddComment == false) {
                        if (rating == 0 ||
                            review.text.trim().isEmpty ||
                            (nickname.text.trim().isNotEmpty &&
                                isAnnonymos == false)) {
                        } else {
                          provider
                              .addReviewAPI(
                                  widget.id.toString(),
                                  rating.toString(),
                                  isAnnonymos ? "yes" : "no",
                                  review.text.trim(),
                                  imageFile,widget.userID)
                              .then((value) {
                            if (value) {}
                          });
                        }
                      }
                    },
                    text: provider.isAddComment ? "loading" : "Submit",
                    color: rating == 0 ||
                            review.text.trim().isEmpty ||
                            (nickname.text.trim().isNotEmpty &&
                                isAnnonymos == false)
                        ? const Color(0xFFD7DCDD)
                        : primaryColor,
                    textcolor: rating == 0 ||
                            review.text.trim().isEmpty ||
                            (nickname.text.trim().isNotEmpty &&
                                isAnnonymos == false)
                        ? const Color(0xFF8F9395)
                        : whiteColor,
                    buttonBorderColor: rating == 0 ||
                            review.text.trim().isEmpty ||
                            (nickname.text.trim().isNotEmpty &&
                                isAnnonymos == false)
                        ? const Color(0xFFD7DCDD)
                        : primaryColor,
                  );
                }),
              ),
              UIHelper.verticalSpaceMd,
            ],
          );
        }),
      ),
    );
  }

  _getFromCamera(src) async {
    List<XFile>? pickedFile = await picker.pickMultiImage();
    if (pickedFile.isNotEmpty) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }
}
